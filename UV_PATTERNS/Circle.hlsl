#ifndef CIRCLE_INCLUDED
#define CIRCLE_INCLUDED

bool perfectCircle(
        float2 pixel,   // 現在の座標(x,y共に0~1)
        float2 origin,  // 原点の座標
        float  radius,  // 半径
        fixed  tiling=1 // 敷き詰める個数
    )
    {
    float  color;
    float2 position = frac(pixel*tiling);
    float  distance = length(position-origin);
           color    = 1-step(r, distance);
    return color;
};
#endif

/*
## 関数の説明

input座標はすべて0~1を想定している

perfectCircle() : 真円を描く為の関数

## 機能拡張アイデア

# 基本形を増やす
- 楕円
- リサージュ図形


# 色
- フェードアウト
    線の形
        線形
        べき乗
        対数関数
    線のエフェクト
        グリッチ
        ノイズ
        階段
        点線
        色変化


# アニメーション
- タイムラインに値を渡すと任意の動きをする
    下記の内発的なアクション
    下記の外部とのインタラクションを起こす

# 内発的なアクション
    跳ねる
    寝そべる
    膨らむ
    爆ぜる

# 外部とのインタラクション
- 凹む
    指でつまんだような凹み
    つまようじでつついたようなとがった凹み
    風船みたいな凹み

- ねじる

- 融け合う

- 押し付ける

- 引っ張る

- 欠ける

- 崩れる

- とろける
    ある部分を避けるような動き

- 波打つ


# タイリングの工夫
- 上下左右にはみ出た分が左から出てくるやつ
- １つの平面に複数の図形を描く
    複数の図形が重なったところに特別な処理をかける

- 値を裏返す

# 別のパターンとレイヤーを成す
