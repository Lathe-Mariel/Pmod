# 7セグメント LED カウンタ
## Tang Primer 25K (GW5A-25) + Sipeed PMOD-DTx2

---

## 概要

Tang Primer 25K の PMODポートに Sipeed PMOD-DTx2 を接続し、  
0〜99 を1秒ごとにカウントアップして2桁の7セグメントLEDに表示します。

---

## ファイル構成

```
seg7_counter/
└── src/
    ├── top.v    ← トップモジュール (Verilog)
    ├── top.cst  ← 物理ピン制約
    └── top.sdc  ← タイミング制約
```

---

## PMOD-DTx2 ピン配置

PMOD-DTx2 は 12ピン PMOD インターフェースを使用します。

```
PMOD コネクタ (基板から見た場合):
┌─────────────────────────────────┐
│ PIN1  PIN2  PIN3  PIN4  GND VCC │  ← 上段
│ PIN7  PIN8  PIN9 PIN10  GND VCC │  ← 下段
└─────────────────────────────────┘

信号割り当て:
  上段: PIN1=seg_a, PIN2=seg_b, PIN3=seg_c, PIN4=seg_d
  下段: PIN7=seg_e, PIN8=seg_f, PIN9=seg_g, PIN10=seg_dp
  桁選択 dig0, dig1 は PMOD2 ポートに接続
```

### 7セグメント セグメント配置

```
 --a--
f     b
 --g--
e     c
 --d--  (dp=小数点)
```

セグメント出力は**アクティブLow** (0 = 点灯)

---

## Tang Primer 25K PMOD ピン番号

⚠️ **重要**: `.cst` ファイルのFPGAピン番号はプレースホルダーです。  
以下の手順で実際のピン番号に変更してください。

1. [Tang Primer 25K 回路図](https://dl.sipeed.com/shareURL/TANG/Primer_25K)をダウンロード
2. PMOD1 コネクタの各ピン番号を確認
3. `top.cst` の `IO_LOC` を実際のピン番号に書き換える

### 参考: 公式サンプルのピン番号 (pmod_digitalTube-2bit)
公式 GitHub: https://github.com/sipeed/TangPrimer-25K-example

---

## GOWIN EDA プロジェクト作成手順

1. GOWIN EDA を起動
2. **New Project** → Device: `GW5A-LV25MG121NC1/I0`
3. プロジェクト名を設定 (例: `seg7_counter`)
4. ソースファイルを追加:
   - `src/top.v` (Verilog ソース)
   - `src/top.cst` (物理制約)
   - `src/top.sdc` (タイミング制約)
5. **Process** → **Run All** で合成・配置配線
6. **Programmer** でビットストリームを書き込み

---

## 動作説明

| モジュール | 機能 |
|-----------|------|
| 1秒カウンタ | 50MHz クロックを分周して1秒パルスを生成 |
| 表示値管理 | 0〜99 をカウントアップ (99→0 でリセット) |
| BCD変換 | 表示値を十の位・一の位に分離 |
| ダイナミック点灯 | 1ms ごとに桁を切り替えて2桁を表示 |
| 7セグデコーダ | 0〜9 の数値をセグメント信号に変換 |

---

## 注意事項

- クロック周波数が 50MHz でない場合は `top.v` の `CLK_FREQ` パラメータを変更
- リセットは **アクティブLow** (H10 ピンのボタン S1)
- PMOD-DTx2 のセグメントが **アクティブHigh** の場合は `r_seg` の値をビット反転
- 実際のFPGAピン番号は必ず回路図で確認すること
