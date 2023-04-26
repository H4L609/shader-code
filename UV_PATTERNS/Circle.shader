Shader "UV_PATTERN/Circle"
{
    Properties
    {
        [NoScaleOffset]
        _MainTex ("Texture", 2D) = "white" {}

        _Radius  ("Radius",Range(0,1)) = 0.5
        _Center_X  ("Center X", Range(0,1)) = 0.5
        _Center_Y  ("Center Y", Range(0,1)) = 0.5

        [IntRange]
        _Tiling("Tiling", Range(1,100)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Circle.hlsl"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float _Radius;
            float _Center_X;
            float _Center_Y;
            fixed _Tiling;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);                
                float2 center = float2(_Center_X, _Center_Y);
                col *= perfectCircle(i.uv, center, _Radius,_Tiling);
                return col;
            }
            ENDCG
        }
    }
}
