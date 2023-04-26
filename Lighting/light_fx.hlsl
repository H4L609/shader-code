#ifndef LIGHT_FX_INCLUDED
#define LIGHT_FX_INCLUDED

/* Lambert拡散反射モデル(余弦則) -------------------------------------------------------
    鏡面反射計算のように"ツヤ"を求めるのではなく、物体の表面にどれだけ光が当たっているのかを求める
    拡散反射

    lightDir : 光線の方向
    normal   : 法線の方向

    このふたつのベクトルの内積が、lambert拡散反射の強さにあたる。

    問題点
    - 内積の計算結果の値域は-1~1となり、0を下回る部分が別のライト計算の妨げになること
    - 光と影の境界がはっきりしすぎる場合があること

    解決策
    - saturate
    - 正規化
    - lerp

    ----------------------------------------------------------------------------------
*/
float lambert(float3 lightDir, float3 normal) {
    float lambert = dot(lightDir, normal);
    return lambert;
}

/*  SPECULAR --------------------------------------------------------------------------

    物体の表面の"滑らかさ"と、面に当たる光の"反射ベクトル"を使って、"つや"を表現する
        lightDir : 光源の方向
        viewDir  : 視線方向(_WorldSpaceCameraPos - i.vertexW)
        normal   : 法線方向(normal)

    鏡面反射を導き出すモデルは主に2つ
        Phong       鏡面反射モデル : Reflect関数で求めた反射ベクトルと視線ベクトルの内積を使うアルゴリズム
        Bling Phong 鏡面反射モデル : ハーフベクトル(視線+光線) と法線の内積を使うアルゴリズム

    これらの関数の結果に以下の計算をするとそれっぽくなる
    - LightColor :
        その点にあたるライトの色
    - Glossiness :
        Glossinessが大きいほど、
          ①艶の出る範囲が狭く
          ②艶の明るさの密度が高くなる。
        また、Glossinessの指数が大きいほど、②の傾向は強まる
    pow(Specular * LightColor, Glossiness * Gossiness)

    ----------------------------------------------------------------------------------
*/
float specularHalf(float3 lightDir, float3 viewDir, float3 normal) {
    float3 halfVector = normalize(lightDir + viewDir);
    return dot(normal, halfVector);
};

float specularTrueRef(float3 lightDir, float3 viewDir, float3 normal) {
    float3 reflection = normalize(reflect(-lightDir, normal));
    return dot(viewDir, reflection);
};

/*  MatCap ----------------------------------------------------------------------------------
    疑似コードとして書く
    スフィア環境マップと呼ばれるテクスチャを用意する。これは、自分が透明半球の中心にいると仮定し、
    その中心から見た景色を半球に"イイ感じ"に(適切な計算をして)投影し、それを二次元の画像に変換したものって感じ。
*/

    // 導出方法1
        // sampler2D _MainTex
        // sampler2D _MatcapTexture とする
    float4 matcap(float3 viewSpaceNormal) {
        float4 maintex = tex2D(_MainTex, i.uv);
        float2 matcap_uv = viewSpaceNormal.xy * 0.5 + 0.5;
        float3 matcap_sample = tex2D(_MatcapTexture, matcap_uv).rgb;
        return maintex.rgb + matcap_sample;
    }

    // 導出方法2 :https://marina.sys.wakayama-u.ac.jp/~tokoi/?date=20050107
    float4 matcap() {
        normalVS : View空間での 法線方向
        view     : View空間での 視線方向ベクトル = 0,0,1
        f        : 視線方向と法線から導き出した反射ベクトル

        float3 f = reflect(view, i.normalVS);
        float  m = 2 * sqrt(f.x*f.x + f.y*f.y + f.z*f.z);
        float2 matcap_uv = float2(f.x / m + 0.5, f.y / m + 0.5);
        return maintex.rgb + matcap_sample;
    }

    // 導出方法3 : liltoon(lil_common_frag.hlsl)
        float2 lilCalcMatCapUV(float2 uv1, float3 normalWS, float3 viewDirection, float3 headDirection, float4 matcap_ST, float2 matcapBlendUV1, bool zRotCancel, bool matcapPerspective, float matcapVRParallaxStrength)
        {
            // Simple
            //return mul((float3x3)LIL_MATRIX_V, normalWS).xy * 0.5 + 0.5;
            float3 normalVD = lilBlendVRParallax(headDirection, viewDirection, matcapVRParallaxStrength);
            normalVD = lilIsPerspective() && matcapPerspective ? normalVD : lilCameraDirection();
            float3 bitangentVD = zRotCancel ? float3(0,1,0) : LIL_MATRIX_V._m10_m11_m12;
            bitangentVD = lilOrthoNormalize(bitangentVD, normalVD);
            float3 tangentVD = cross(normalVD, bitangentVD);
            float3x3 tbnVD = float3x3(tangentVD, bitangentVD, normalVD);
            float2 uvMat = mul(tbnVD, normalWS).xy;
            uvMat = lerp(uvMat, uv1*2-1, matcapBlendUV1);
            uvMat = uvMat * matcap_ST.xy + matcap_ST.zw;
            uvMat = uvMat * 0.5 + 0.5;
            return uvMat;
        }

        #if(_UseMatCap)
        {
            // Normal
            float3 N = fd.matcapN;
            #if defined(LIL_FEATURE_NORMAL_1ST) || defined(LIL_FEATURE_NORMAL_2ND)
                N = lerp(fd.origN, fd.matcapN, _MatCapNormalStrength);
            #endif
            #if defined(LIL_FEATURE_MatCapBumpMap)
                if(_MatCapCustomNormal)
                {
                    float4 normalTex = LIL_SAMPLE_2D_ST(_MatCapBumpMap, samp, fd.uvMain);
                    float3 normalmap = lilUnpackNormalScale(normalTex, _MatCapBumpScale);
                    N = normalize(mul(normalmap, fd.TBN));
                    N = fd.facing < (_FlipNormal-1.0) ? -N : N;
                }
            #endif

            // UV
            float2 matUV = lilCalcMatCapUV(fd.uv1, normalize(N), fd.V, fd.headV, _MatCapTex_ST, _MatCapBlendUV1.xy, _MatCapZRotCancel, _MatCapPerspective, _MatCapVRParallaxStrength);

            // Color
            float4 matCapColor = _MatCapColor;
            #if defined(LIL_FEATURE_MatCapTex)
                matCapColor *= LIL_SAMPLE_2D_LOD(_MatCapTex, lil_sampler_linear_repeat, matUV, _MatCapLod);
            #endif
            #if !defined(LIL_PASS_FORWARDADD)
                matCapColor.rgb = lerp(matCapColor.rgb, matCapColor.rgb * fd.lightColor, _MatCapEnableLighting);
                matCapColor.a = lerp(matCapColor.a, matCapColor.a * fd.shadowmix, _MatCapShadowMask);
            #else
                if(_MatCapBlendMode < 3) matCapColor.rgb *= fd.lightColor * _MatCapEnableLighting;
                matCapColor.a = lerp(matCapColor.a, matCapColor.a * fd.shadowmix, _MatCapShadowMask);
            #endif
            #if LIL_RENDER == 2 && !defined(LIL_REFRACTION)
                if(_MatCapApplyTransparency) matCapColor.a *= fd.col.a;
            #endif
            matCapColor.a = fd.facing < (_MatCapBackfaceMask-1.0) ? 0.0 : matCapColor.a;
            float3 matCapMask = 1.0;
            #if defined(LIL_FEATURE_MatCapBlendMask)
                matCapMask = LIL_SAMPLE_2D_ST(_MatCapBlendMask, samp, fd.uvMain).rgb;
            #endif

            // Blend
            matCapColor.rgb = lerp(matCapColor.rgb, matCapColor.rgb * fd.albedo, _MatCapMainStrength);
            fd.col.rgb = lilBlendColor(fd.col.rgb, matCapColor.rgb, _MatCapBlend * matCapColor.a * matCapMask, _MatCapBlendMode);
        }
    // 色補正(LIL_LITE)
        col.rgb = lerp(col.rgb, _MatCapMul ? fd.col.rgb * matcap : col.rgb + matcap, triMask.r)


    -----------------------------------------------------------------------------------------
*/



/*  FRESNEL --------------------------------------------------------------------------

    物体の境界における"屈折率"と、面への光の"入射角"を使って、"映る環境光の量"を計算する
    - view              : 視線方向(_WorldSpaceCameraPos - i.vertexW)
    - normal            : 法線方向(normal)
    - dot(view, normal) : 入射角

    fresnel : 物質固有の反射率

    これらの関数は、Fresnelの提唱するアルゴリズムに近似した値を、より少ない計算量で導き出す。

    光造形の3Dプリンターで出力した物体のように、"どこか透明感のある物体"を表現したいときに使うといい
    
    ----------------------------------------------------------------------------------
*/
float fresnelSchlick(float3 view, float3 normal, float fresnel)
{
    return saturate(fresnel + ( 1 - fresnel) * pow(1 - dot(view,normal), 5));
    // 法線が視線からそっぽを向いているほど、pow,exp以降の値は大きくなる
}

float fresnelFast(float3 view, float3 normal, float fresnel)
{
    return saturate(fresnel + ( 1 - fresnel) * exp(-6 * dot(view, normal)));
}

/*  RIM LIGHT ----------------------------------------------------------------------------------
    物体の縁の辺りが光っているように見せたい時に使う。
    Toon表現以外ではほとんど出番がない。

    viewDir : 視線の方向 = cameraPos - vertex
    normal  : 法線の方向

    ----------------------------------------------------------------------------------
*/
float rimLight(float3 viewDir, float3 normal, float3 lightDir) {
    return 1 - dot(normal, viewDir);
};

float4 rimToon(float3 viewDir, float3 normal, float3 lightDir) {
    float4 _RimColor;
    float  _RimThreshold; // Rimを光らせるか否かを分ける、境界値を決める
    float  _RimAmount;    // RimDotに補正をかける。この値を上げるほどLambertの影響を受けやすくなる
                          //   = 影で暗く、日向では明るくなる
    
    float rimDot  = 1 - dot(viewDir, normal);
    float lambert = ~ ~ ~;
        
    float  RimIntensity = rimDot * pow(lambert, _RimAmount);
           RimIntensity = smoothstep(_RimThreshold - 0.01, _RimThreshold + 0.01, RimIntensity);
    float4 rim = RimIntensity * _RimColor;

    reutrn rim
}



/* 異方性反射

*/

#endif