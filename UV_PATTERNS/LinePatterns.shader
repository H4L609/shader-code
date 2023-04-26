Shader "UV_PATTERN/LinePattern"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "red" {}
        [KeywordEnum(DIAGONAL, VERTICAL, HORIZONTAL)]
            _Pattern("Select Pattern", int) = 0
        [Space(10)]
            _LineInterval("Interval",   float) = 3
            _Tiling      ("Repeat",     float) = 1
            _Offset      ("Slide Width",float) = 0
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
            #include "LinePattern.hlsl"
            #pragma multi_compile _ _PATTERN_DIAGONAL _PATTERN_VERTICAL _PATTERN_HORIZONTAL

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float _LineInterval;
            float _Gradient;
            float _Offset;
            float _Tiling;

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

                #ifdef _PATTERN_DIAGONAL
                    col.rgb += diagonalPattern(i.uv, _LineInterval, _Offset, _Tiling);
                #endif

                #ifdef _PATTERN_VERTICAL
                    col.rgb += verticalPattern(i.uv, _LineInterval, _Offset, _Tiling);
                #endif

                #ifdef _PATTERN_HORIZONTAL
                    col.rgb += horizontalPattern(i.uv, _LineInterval, _Offset, _Tiling);
                #endif
                return col;
            }
            ENDCG
        }
    }
}
