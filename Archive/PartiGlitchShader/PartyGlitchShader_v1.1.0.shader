Shader "Harumaki/PartyGlitchShader_v1.1.0"

/*
# ver 1.1.0 への変更内容
    ver 1.0.0 を「簡易版」として残しつつ、少し複雑だが高機能な「高機能版」を作ってみる
        ただし、高機能版を入れることで、ユーザーの意思決定の負荷が増える可能性もあることに注意する。

    ## 具体的な更新内容
        ### 機能追加
        ポリゴンの表裏の描画有無を設定する機能を追加
            Culling を Front / Back / Off で切り替える機能を追加
               
        グリッチマスク機能を追加
            グリッチの強さをマスク画像で設定可能に！

        エミッションマップが使用可能に！
            EmissionMap に設定した画像の明るさが全体に反映される
            
        アルファマスクによる透過機能を追加
        Entire Glitch Scale の最大値を10倍にしてより激しいグリッチが可能に
        Inspector内の表示 "Color Calibration" を "Color Correction" に変更

        その他
            "CGINC"ディレクトリの名前を"INCLUDES"に変更
            "ColorVibration.cginc"の名前を"PartyGlitch.cginc"に変更
            "RGB_HSV.hlsl"の内部処理を一部変更
            "LinePatterns.hlsl"の内部処理を一部変更
*/
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