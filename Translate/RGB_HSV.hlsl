#ifndef RGB_HSV
#define RGB_HSV
// RGBで表現された色をHSVに変換して、色を調整する

// RGB->HSV変換
// https://techblog.kayac.com/unity_advent_calendar_2018_15 を改変
float3 rgb2hsv(float3 rgb) {
    float3 hsv;

    // RGBの三つの値で最大のもの
    float maxVal = max(rgb.r, max(rgb.g, rgb.b));
    // RGBの三つの値で最小のもの
    float minVal = min(rgb.r, min(rgb.g, rgb.b));
    // 最大値と最小値の差
    float delta = maxVal - minVal;
    
    // V（明度）
    // 一番強い色をV値にする
    hsv.z = maxVal;
    
    // S（彩度）
    // 最大値と最小値の差を正規化して求める
    hsv.y = delta / (maxVal+0.0000000001);
    
    // H（色相）
    // RGBのうち最大値と最小値の差から求める
    if (hsv.y > 0.0){
        if (rgb.r == maxVal) {
            hsv.x = (rgb.g - rgb.b) / delta;
        } else if (rgb.g == maxVal) {
            hsv.x = 2 + (rgb.b - rgb.r) / delta;
        } else {
            hsv.x = 4 + (rgb.r - rgb.g) / delta;
        }
        hsv.x /= 6.0;
        if (hsv.x < 0)
        {
            hsv.x += 1.0;
        }
    }
    
    return hsv;
}

// HSV->RGB変換
// Qiitaよりコピペ : https://qiita.com/keim_at_si/items/c2d1afd6443f3040e900
float3 hsv2rgb(float3 hsv) {
    float
        h = hsv.x,
        s = hsv.y,
        v = hsv.z;

    return
    (
        (
            clamp(
                abs(
                    frac(
                        h+float3(0,2,1)/3.
                    )*6.-3.
                )-1.,0.,1.
            )-1.
        )*s+1.
    )*v;

}

float3 shift_col(float3 rgb, half3 shift) {
    // RGB->HSV変換
    float3 hsv = rgb2hsv(rgb);
    // HSV操作
    hsv.x += shift.x;
    if (1.0 <= hsv.x)
    {
        hsv.x -= 1.0;
    }
    hsv.y *= shift.y;
    hsv.z *= shift.z;
    
    // HSV->RGB変換
    return hsv2rgb(hsv);
}
#endif