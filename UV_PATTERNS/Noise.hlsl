# Noise関数

#UnityShaderProgramingBookに載っていたコードをそのままコピペ

## 説明
UV座標などのベクトルを使って、1~3次ベクトルの乱数を出力するアルゴリズム
各成分の大きさは { 0 ~ 1 }

_______| input | out |
noise1 |   2   |  1  |
noise2 |   2   |  2  |
noise3 |   3   |  3  |

- - - code - - -

#ifndef Noise
#define Noise

float noise1(float2 seeds)
{
    return frac(sin(dot(seeds, float2(12.9898, 78.233))) * 43758.5453);
}
float2 noise2(float2 seeds)
{
    seeds = float2(dot(seeds, float2(127.1, 311.7)),
    dot(seeds, float2(269.5, 183.3)));
    return frac(sin(seeds) * 43758.5453123);
}
float3 noise3(float3 seeds)
{
    seeds = float3(dot(seeds, float3(127.1, 311.7, 542.3)),
    dot(seeds, float3(269.5, 183.3, 461.7)),
    dot(seeds, float3(732.1, 845.3, 231.7)));
    return frac(sin(seeds) * 43758.5453123);
}

#endif