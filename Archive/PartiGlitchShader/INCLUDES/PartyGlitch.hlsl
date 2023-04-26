#ifndef PARTY_GLITCH
#define PARTY_GLITCH


sampler2D _MainTex;
sampler2D _GlitchMask;
sampler2D _EmissionMap;
sampler2D _TransparentMask;

float _EntireGlitchScale;
float _RedGlitchScale;
float _GreenGlitchScale;
float _BlueGlitchScale;

float _Saturate;
float _Value;
float _Hue;

int _TessFactor;


#include "UnityCG.cginc"
#include "Tessellation.cginc"
#include "LinePattern.hlsl"
#include "RGB_HSV.hlsl"

#define INPUT_PATCH_SIZE  3
#define OUTPUT_PATCH_SIZE 3

struct appdata
{
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
};

struct v2h
{
    float2 uv : TEXCOORD0;
    float4 pos : POSITION;
};

struct h2d_const
{
    float tessFactor[3] : SV_TessFactor;
    float insideTessFactor : SV_InsideTessFactor;
};

struct h2d_main
{
    float4 pos : POSITION;
    float2 uv : TEXCOORD0;
};

struct d2g
{
    float4 pos : POSITION;
    float2 uv : TEXCOORD0;
};

struct g2f {
    float4 pos : SV_POSITION;
    float2 uv : TEXCOORD0;
};

g2f construct(float3 wp, float2 uv) {
    g2f o;
    o.pos = UnityWorldToClipPos(float4(wp,1));
    o.uv  = uv;
    return o;
};

v2h vert(appdata v) {
    v2h o;
    o.uv = v.uv;
    o.pos = v.vertex;
    return o;
};

h2d_const hullConst(InputPatch<v2h, INPUT_PATCH_SIZE> i) {
    h2d_const o;
    o.tessFactor[0]       = _TessFactor;
    o.tessFactor[1]       = _TessFactor;
    o.tessFactor[2]       = _TessFactor;
    o.insideTessFactor    = _TessFactor;
    // o.insideTessFactor    = _InsideTessFactor;
    return o;
};

[domain("tri")]
[partitioning("integer")]
[outputtopology("triangle_cw")]
[outputcontrolpoints(OUTPUT_PATCH_SIZE)]
[patchconstantfunc("hullConst")]
h2d_main hullMain(InputPatch<v2h, INPUT_PATCH_SIZE> v, uint id:SV_OutputControlPointID) {
    h2d_main o = (h2d_main)0;
    o.pos = v[id].pos;
    o.uv  = v[id].uv;
    return o;
};

[domain("tri")]
d2g domain(
    h2d_const h2d_const,
    const OutputPatch<h2d_main, OUTPUT_PATCH_SIZE> i,
    float3 bary:SV_DomainLocation
)
{
    d2g o;
    float3 pos =
        i[0].pos * bary.x+
        i[1].pos * bary.y+
        i[2].pos * bary.z;
    o.pos = mul(unity_ObjectToWorld,float4(pos, 1));


    float2 uv =
        i[0].uv * bary.x+
        i[1].uv * bary.y+
        i[2].uv * bary.z;
    o.uv = uv;


    return o;
}

[maxvertexcount(3)]
void geom(triangle d2g input[3], inout TriangleStream<g2f> outStream) {
    float3 wp0 = input[0].pos.xyz;
    float3 wp1 = input[1].pos.xyz;
    float3 wp2 = input[2].pos.xyz;

    
    float glitchScale =
        _RedGlitchScale  * COLOR_BALANCE.r+
        _GreenGlitchScale* COLOR_BALANCE.g+
        _BlueGlitchScale * COLOR_BALANCE.b;

    glitchScale /= length(COLOR_BALANCE.rgb) * length(COLOR_BALANCE.rgb);

    float angleXZ = UNITY_PI * (floor(_Time.w*(OFFSET+1)) * 0.5357);
    float angleY  = UNITY_PI * (floor(_Time.w*(OFFSET+1)) * 0.5357 * 1.2247);

    float slideX = sign(sin(angleXZ))-sin(angleXZ);
    float slideY = sign(sin(angleY ))-sin(angleY);
    float slideZ = sign(sin(angleXZ))-cos(angleXZ);

    slideX*=_EntireGlitchScale*glitchScale;
    slideY*=_EntireGlitchScale*glitchScale;
    slideZ*=_EntireGlitchScale*glitchScale;

    float3 glitch = float3(
        slideX,
        slideY,
        slideZ
    );

    float4 glitchMaskUV0 = float4(input[0].uv,0,0);
    float4 glitchMaskUV1 = float4(input[1].uv,0,0);
    float4 glitchMaskUV2 = float4(input[2].uv,0,0);

    float glitchMaskUV = (glitchMaskUV0+glitchMaskUV1+glitchMaskUV2)/3;

    

    float glitchFactor0 = shift_col(tex2Dlod(_GlitchMask, glitchMaskUV0).rgb, GREY_SCALE).r+0.5;
    float glitchFactor1 = shift_col(tex2Dlod(_GlitchMask, glitchMaskUV1).rgb, GREY_SCALE).r+0.5;
    float glitchFactor2 = shift_col(tex2Dlod(_GlitchMask, glitchMaskUV2).rgb, GREY_SCALE).r+0.5;

    #ifdef CRACKED
        float  glitchFactor = max(max(glitchFactor0,glitchFactor1), glitchFactor2);
        wp0 += glitchFactor * glitch;
        wp1 += glitchFactor * glitch;
        wp2 += glitchFactor * glitch;
    #else // 分割する
        wp0 += glitchFactor0 * glitch;
        wp1 += glitchFactor1 * glitch;
        wp2 += glitchFactor2 * glitch;      
    #endif

    outStream.Append(construct(wp0, input[0].uv));
    outStream.Append(construct(wp1, input[1].uv));
    outStream.Append(construct(wp2, input[2].uv));
    outStream.RestartStrip();
    
}

fixed4 frag (g2f i) : SV_Target
{
    clip(1-diagonalPattern(i.pos.xy, OFFSET,  COLOR_SPLIT, COLOR_SPLIT)-0.01);

    

    float4 alphaMask     = tex2D(_TransparentMask, i.uv);
           alphaMask.rgb = shift_col(alphaMask.rgb, GREY_SCALE);
    clip(alphaMask.r*alphaMask.a- 0.01);


    fixed4  baseColor       = tex2D(_MainTex, i.uv);
    fixed4  emissionMap     = tex2D(_EmissionMap, i.uv);
            emissionMap.rgb = shift_col(emissionMap.rgb, GREY_SCALE);
    float   emission        = emissionMap.r*emissionMap.a;
    
    fixed3 colorCorrection = fixed3(
        _Hue,
        _Saturate,
        _Value * emission
    );
    fixed4 pixelColor = fixed4(shift_col(baseColor.rgb, colorCorrection), 1) * COLOR_BALANCE;
    return pixelColor;
}

#endif