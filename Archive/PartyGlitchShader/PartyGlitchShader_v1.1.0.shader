Shader "Harumaki/PartyGlitchShader_v1.1.0"

{
    Properties{
        [Enum(UnityEngine.Rendering.CullMode)]
        _Cull("Cull", Float) = 2// 0=Off
        [Space(10)]

        [Header(TEXTURE)] [Space(10)]
        [NoScaleOffset][MainTexture]
        _MainTex ("BaseColor", 2D) = "white"   {}
        [Space(10)]
        [NoScaleOffset]
        _EmissionMap ("EmissionMask", 2D) = "white" {}
        // _EmissionMapStrength("EmissionMask Strength",Range(0,1))=0
        [Space(10)]
        [NoScaleOffset]
        _TransparentMask ("TransparentMask", 2D) = "white" {}

        [Header(GLITCH SCALE)] [Space(10)]
        [PowerSlider(2)]
        _EntireGlitchScale("  Entire Glitch Scale" , Range(0, 10)) = 0.5
        [Space(5)]
        _RedGlitchScale   ("  Red Glitch Scale"  , Range(0, 0.04)) = 0.01
        _GreenGlitchScale ("  Green Glitch Scale", Range(0, 0.04)) = 0.01
        _BlueGlitchScale  ("  Blue Glitch Scale" , Range(0, 0.04)) = 0.01

        [Header(COLOR CORRECTION)] [Space(10)]
        _Hue     ("  Hue",      Range(0,1))    = 0
        _Saturate("  Saturate", Range(0,5))    = 1
        _Value   ("  Value",    Range(0,10)) = 1


        [Header(GLITCH AREA CONTROL( Experimental ))] [Space(10)]
        [NoScaleOffset]    _GlitchMask ("  GlitchMask", 2D) = "white" {}
        [IntRange]         _TessFactor ("  Fineness", Range(1,100)) = 2
        [Toggle(CRACKED)]  _CRACKED    ("  CRACKED",  float) = 0
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