#ifndef NORMALIZER_INCLUDED
#define NORMALIZER_INCLUDED

float sin2uv(float i){
    return (i+1)*0.5;
    // -1~1の値を、0~1に変換するだけ
};

float uv2sin(float i){
    return (i*2)-1;
    // 0~1の値を、-1~1に変換するだけ
};

/* スカラーの正規化をする関数
    sin のように、入力値が定まっている関数の iMin 下限値と iMax 上限値 を渡し、
*/
float mlerp
(
    float iMin,
    float iMax,
    float oMin,
    float oMax,
    float target
)
{
    /* 線形補間の基本
        元となる線分の最小値 min と最大値 max
        min < 点P < max である、点Pが、minとmaxの間のどの位置にいるのか、割合で示したい。
        そういうときは、(P - min) / (max - min)で求められる。

    */
    float w = (target - iMin) / (iMax-iMin);
    return lerp(oMin, oMax, w);

    // float inputCenter = (iMin + iMax) * 0.5;
    // float outputCenter = (oMin + oMax) * 0.5;

    // float compressRatio = (oMax - oMin) / (iMax - iMin);

    // target = (target - inputCenter) * compressRatio; // input値の中心を基準にして膨張、収縮
    // target += outputCenter; // 平行移動

    // return clamp(oMin,oMax,target);
}
#endif