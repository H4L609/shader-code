#ifndef LINE_PATTERN_INCLUDED
#define LINE_PATTERN_INCLUDED

// 45度
// 横
// 縦

/*
    float2 uv       : (x,y)共に 0~1
    int    interval : 線の引かれる間隔
    float  offset   : タイリングの基準位置をズラス
    half   tiling   : 何本分敷き詰めるか。

*/

int diagonalPattern(
    float2 uv,
    int    interval,
    float  offset,
    half   tiling=1
){
    float color;
    float2 pixel = uv.xy*tiling;
    pixel.x += offset;
    pixel = floor(pixel) / interval;
    color = round(frac(pixel.x + pixel.y)*interval);

    return color-(interval-1);
};

int verticalPattern (
    float2 uv,
    int    interval,
    float  offset,
    half   tiling=1
) {
    float color;
    float2 pixel = uv.xy*tiling;
    pixel.x += offset;
    pixel = floor(pixel) / interval;
    color = round(frac(pixel.x)*interval);

    return color-(interval-1);
};

int horizontalPattern (
    float2 uv,
    int    interval,
    float  offset,
    half   tiling=1
) {
    float color;
    float2 pixel = uv.xy*tiling;
    pixel.y += offset;
    pixel = floor(pixel) / interval;
    color = round(frac(pixel.y)*interval);

    return color-(interval-1);
};

#endif