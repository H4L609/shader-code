【パリピグリッチシェーダー v1.1.0】

ダウンロードありがとうございます

◆商品概要
パリピグリッチシェーダーは、VRChat用の空間グリッチシェーダーです。

3Dモデルの頂点位置をずらすことによって、特殊な効果を生み出すことができます。

頂点・フラグメントシェーダーのみを使用しています。

また、パリピグリッチシェーダーは、Unlit(ライティングの影響を受けない)シェーダーです。

パリピグリッチシェーダーは3Dモデルのマテリアルにセットして使うことを想定しています。

※【無料版】と【有料版】の中身は同じです。


◆UnityPackage内のフォルダ構成

■PartyGlitchShader

┣■Object　サンプルオブジェクトのデータ
┣■Shader シェーダー本体とインクルード用ファイル
┗■VRchat VRChatで利用するときのためのファイル

・VRChatフォルダ内のファイルはでExpression Menu等を使ってシェーダーの表現を調整したい際にご利用ください。

◆パリピグリッチシェーダーのパラメータについて
・MainTex
　3Dモデルの通常の表面色として使うテクスチャをセットする部分です。

・EmissionMap
　部分ごとの明るさを設定するためのテクスチャです。白い部分ほど明るくなります

・TransparentMask
　透明部分を作るためのテクスチャです。真っ黒な部分が完全に透過されます。

・Entire GlitchScale
　R,G,Bすべての色の、ズレ幅を一括で変更するためのパラメータです。このパラメータの値と、以下のRed / Green / Blue GlitchScaleとの掛け算結果が大きいほど、それぞれの色のグリッチが強くなります。

・Red / Green / Blue GlitchScale
　赤、緑、青各色のグリッチの大きさの設定できます。

・Hue
　表面色の"色相"を変えることができます。
　デフォルト値は0です。

・Saturate
　表面色の"彩度"を変えることができます。"Value"パラメータの値を高めたときに、3Dモデルの表面色が白く薄まることを防いだり、見え方をより激しくするときに使います。
　デフォルト値は1です。

・Value
　表面の"明るさ"を変えることができます。
　ポストプロセッシングに Bloom が含まれているワールドでは、このパラメータの値を高く設定することで、モデルを発光しているように見せることができます。
　デフォルト値は1です。

・GlitchMask
　グリッチのかかる強さを部分ごとに指定するためのテクスチャです。明るい部分ほどグリッチが強くなります。

・ Fineness
　ポリゴンを細かく分割し、グリッチマスクの精確さを高めるためのパラメータです。上げすぎると重くなります。

・CRACKED
　グリッチマスクをかけた箇所が、元のメッシュから分離されるか否かを指定するパラメータです。

◆導入方法
1. Unity 2019.4.31f1 で新規のプロジェクトを作成してください
2. unitypackageをインポートしてください。
3. パリピグリッチシェーダーを適用したい3Dモデルのマテリアルを作成し、複製先のマテリアルにこのシェーダを割り当てる
4. 3.で変更を加えたマテリアルを、3Dモデルが元々持っていたマテリアルと置き換える

※複数のマテリアルを置き換える際には、クロツグミ(https://kurotu.booth.pm/ )さんの、Material Replacer(https://booth.pm/ja/items/4023240 )を使うのがをおすすめです。

◆利用規約
本商品を購入した時点で本利用規約に同意したとみなします。
利用規約の内容は変更する場合があり、最新のものが適用されます。
本モデルの使用によって生じた何らかのトラブル、損失について
製作者であるはるまきは一切の責任を負わないものとします。
本シェーダー及びおまけ3Dモデルの著作権は　はるまき　に帰属するものとします。


◆パリピグリッチシェーダー利用規約
1. 改造可能
2. Unityを使用して開発されたコンテンツ及びサービス（ゲーム、VRChat等）での利用可能
3. 利用の際にクレジットの表記等は不要(利用を報告していただけると飛び跳ねます)
4. 再配布、再販売の禁止
5. 商用利用可能

◆連絡先
はるまき（https://twitter.com/h4L609）

◆バージョン
・v1.0.0 2023年3月21日　初版
・v1.1.0 2023年4月27日　機能追加


## ver 1.1.0 への変更内容
    ver 1.0.0 「簡易版」に機能を追加し、「高機能版」を作った。

## 具体的な更新内容


### 機能追加
- ポリゴンの表裏の描画有無を設定する機能を追加
  - Culling を Front / Back / Off で切り替える機能を追加
            
- グリッチマスク機能を追加
  - グリッチの強さをマスク画像で設定可能に！

- エミッションマップが使用可能に！
  - EmissionMap に設定した画像の明るさが全体に反映される
        
- アルファマスクによる透過機能を追加
  - Entire Glitch Scale の最大値を10倍にしてより激しいグリッチが可能に

- Inspector内の表示 "Color Calibration" を "Color Correction" に変更

- その他
  - "CGINC"ディレクトリの名前を"INCLUDES"に変更
  - "ColorVibration.cginc"の名前を"PartyGlitch.cginc"に変更
  - "RGB_HSV.hlsl"の内部処理を一部変更
  - "LinePatterns.hlsl"の内部処理を一部変更
  - 日本語バージョンを作った