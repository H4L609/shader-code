#ifndef LINE_PATTERN_INCLUDED
#define LINE_PATTERN_INCLUDED

// 45度
// 横
// 縦

/*
    float2 uv       : (x,y)共に 0~1
    int    interval : 線の引かれる間隔
    int    brightness     : 色の明るさ(saturateがかかるため、intervalより大きくする必要はない)
    float  offset   : タイリングの基準位置をズラす。offsetはマス単位。
    half   tiling   : 何本分敷き詰めるか。

*/

float diagonalPattern(
    float2 uv,
    float  offset,
    int    interval,
    int    brightness,
    half   tiling=1
){
    float  color;
    float2 pixel    = uv;
           pixel    = pixel*tiling;
           pixel.x += offset;
    pixel = floor(pixel) / interval;
    color = frac(pixel.x + pixel.y)*brightness;
    return saturate(color);
};

float verticalPattern (
    float2 uv,
    float  offset,
    int    interval,
    int    brightness,
    half   tiling=1
){
    float color;
    float pixel  = uv.x;
          pixel  = pixel*tiling;
          pixel += offset;
    pixel = floor(pixel) / interval;
    color = frac(pixel.x)*brightness;
    return saturate(color);
}

float horizontalPattern (
    float2 uv,
    float  offset,
    int    interval,
    int    brightness,
    half   tiling=1
){
    float color;
    float pixel  = uv.y;
          pixel  = pixel*tiling;
          pixel += offset;
    pixel = floor(pixel) / interval;
    color = frac(pixel)  * brightness;
    return saturate(color);
};

#endif