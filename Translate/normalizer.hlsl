#ifndef NORMALIZER_INCLUDED
#define NORMALIZER_INCLUDED

// -1~1の値を、0~1に変換する
// dot, cos, sinなどに使う
float sin2uv(float i){
    return (i+1)*0.5;
};


// 0~1の値を、-1~1に変換する
float uv2sin(float i){
    return (i*2)-1;
};

/* 
  スカラーの正規化をする関数
    入力値 target と、
    入力値が取りうる 下限値 iMin と iMax 上限値 を渡し、
    出力値に渡したい 下限値 oMin と oMax 上限値 を返す。

  線形補間の基本
    元となる線分の最小値 min と最大値 max
    min < 点P < max である、点Pが、minとmaxの間のどの位置にいるのか、割合で示したい。
    そういうときは、(P - min) / (max - min)で求められる。

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