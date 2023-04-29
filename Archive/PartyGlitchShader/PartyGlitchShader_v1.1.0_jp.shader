Shader "Harumaki/PartyGlitchShader_v1.1.0" {
    Properties{
        [Enum(UnityEngine.Rendering.CullMode)]
        _Cull("カリング", Float) = 2// 0=Off
        [Space(10)]

        [Header(テクスチャ)] [Space(10)]
        [NoScaleOffset][MainTexture]
        _MainTex ("ベースカラー", 2D) = "white"   {}
        [Space(10)]
        [NoScaleOffset]
        _EmissionMap ("エミッションマップ", 2D) = "white" {}
        // _EmissionMapStrength("EmissionMask Strength",Range(0,1))=0
        [Space(10)]
        [NoScaleOffset]
        _TransparentMask ("透過マスク", 2D) = "white" {}

        [Header(GLITCH SCALE)] [Space(10)]
        [PowerSlider(2)]
        _EntireGlitchScale("  全体的なグリッチの強さ" , Range(0, 10)) = 0.5
        [Space(5)]
        _RedGlitchScale   ("  グリッチの強さ(赤)"  , Range(0, 0.04)) = 0.01
        _GreenGlitchScale ("  グリッチの強さ(緑)", Range(0, 0.04)) = 0.01
        _BlueGlitchScale  ("  グリッチの強さ(青)" , Range(0, 0.04)) = 0.01

        [Header(色の調整)] [Space(10)]
        _Hue     ("  色相",      Range(0,1))    = 0
        _Saturate("  鮮やかさ", Range(0,5))    = 1
        _Value   ("  明るさ",    Range(0,10)) = 1


        [Header(GLITCH AREA CONTROL( Expermental ))] [Space(10)]
        [NoScaleOffset]    _GlitchMask ("  グリッチマスク", 2D) = "white" {}
        [IntRange]         _TessFactor ("  グリッチマスクの精確さ(高負荷)", Range(1,100)) = 2
        [Toggle(CRACKED)]  _CRACKED    ("  グリッチ部分の分離",  float) = 0
    }

    SubShader
    {
        LOD 300

        Tags{
            "RenderType"="TransparentCutout"
            "Queue"="AlphaTest"
        }
        AlphaToMask On
        Cull [_Cull]

        // #########################################################
        Pass // R
        {
            CGPROGRAM
            #pragma target 4.0

            #define COLOR_SPLIT  6
            #define OFFSET  0
            #define COLOR_BALANCE float4(1,0,0,1)
            #define GREY_SCALE    float3(0,0,1)

            #pragma vertex vert
            #pragma fragment frag
            #pragma hull hullMain
            #pragma domain domain
            #pragma geometry geom
            #pragma shader_feature _ CRACKED


            #include "INCLUDES/PartyGlitch.hlsl"
            ENDCG
        }
        // #########################################################

        Pass // RG
        {
            CGPROGRAM
            #pragma target 4.0

            #define COLOR_SPLIT  6
            #define OFFSET  1
            #define COLOR_BALANCE float4(1,1,0,1)
            #define GREY_SCALE    float3(0,0,1)

            #pragma vertex vert
            #pragma fragment frag
            #pragma hull hullMain
            #pragma domain domain
            #pragma geometry geom
            #pragma shader_feature _ CRACKED


            #include "INCLUDES/PartyGlitch.hlsl"

            ENDCG
        }
        // #########################################################

        Pass // G
        {
            CGPROGRAM
            #pragma target 4.0

            #define COLOR_SPLIT  6
            #define OFFSET  2
            #define COLOR_BALANCE float4(0,1,0,1)
            #define GREY_SCALE    float3(0,0,1)

            #pragma vertex vert
            #pragma fragment frag
            #pragma hull hullMain
            #pragma domain domain
            #pragma geometry geom
            #pragma shader_feature _ CRACKED


            #include "INCLUDES/PartyGlitch.hlsl"

            ENDCG
        }
        // #########################################################

        Pass // GB
        {
            CGPROGRAM
            #pragma target 4.0

            #define COLOR_SPLIT  6
            #define OFFSET  3
            #define COLOR_BALANCE float4(0,1,1,1)
            #define GREY_SCALE    float3(0,0,1)

            #pragma vertex vert
            #pragma fragment frag
            #pragma hull hullMain
            #pragma domain domain
            #pragma geometry geom
            #pragma shader_feature _ CRACKED


            #include "INCLUDES/PartyGlitch.hlsl"

            ENDCG
        }
        // #########################################################

        Pass // B
        {
            CGPROGRAM
            #pragma target 4.0

            #define COLOR_SPLIT  6
            #define OFFSET  4
            #define COLOR_BALANCE float4(0,0,1,1)
            #define GREY_SCALE    float3(0,0,1)

            #pragma vertex vert
            #pragma fragment frag
            #pragma hull hullMain
            #pragma domain domain
            #pragma geometry geom
            #pragma shader_feature _ CRACKED


            #include "INCLUDES/PartyGlitch.hlsl"

            ENDCG
        }        // #########################################################

        Pass // GB
        {
            CGPROGRAM
            #pragma target 4.0

            #define COLOR_SPLIT  6
            #define OFFSET  5
            #define COLOR_BALANCE float4(1,0,1,1)
            #define GREY_SCALE    float3(0,0,1)

            #pragma vertex vert
            #pragma fragment frag
            #pragma hull hullMain
            #pragma domain domain
            #pragma geometry geom
            #pragma shader_feature _ CRACKED


            #include "INCLUDES/PartyGlitch.hlsl"

            ENDCG 
        }
    }
    Fallback "Unlit/Color"
}