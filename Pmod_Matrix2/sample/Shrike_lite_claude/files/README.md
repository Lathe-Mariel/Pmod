# =============================================================================
# LED Matrix "Renesas" Display - Shrike lite / SLG47910V
# =============================================================================

## 概要

8×8 2色マトリクスLED（アノードコモン）をダイナミックドライブし、
「Rene」（→ "Renesas"の先頭4文字）を色付きで表示するFPGAデザインです。
PWMによる3bitカラー（R3G3 = 6bit色深度）に対応しています。

---

## ファイル構成

```
led_matrix_top.v   - トップモジュール（Verilog HDL）
led_matrix_tb.v    - シミュレーション用テストベンチ
led_matrix.pcf     - ピン制約ファイル（GCSH / nextpnr向け）
README.md          - 本ファイル
```

---

## ハードウェア構成

```
                    ForgeFPGA SLG47910V
                   ┌─────────────────────┐
    OSC_CLK ──────▶│ clk                 │
                   │                     │
                   │ sr_dat_red (GPIO12) ├──▶ 74LS595 #1 SER ─▶ 赤カソード Col0-7
                   │ sr_dat_grn (GPIO15) ├──▶ 74LS595 #2 SER ─▶ 緑カソード Col0-7
                   │ sr_dat_row (GPIO14) ├──▶ 74LS595 #3 SER ─▶ アノード   Row0-7
                   │ sr_clk     (空きGPIO)├──▶ 595×3 SHCP（共通）
                   │ sr_lat     (空きGPIO)├──▶ 595×3 STCP（共通）
                   └─────────────────────┘

  74LS595 #1 (赤カソード):
    Q0-Q7 → LED Col0-Col7 赤カソード (Low=点灯)

  74LS595 #2 (緑カソード):
    Q0-Q7 → LED Col0-Col7 緑カソード (Low=点灯)

  74LS595 #3 (アノード行選択):
    Q0-Q7 → LED Row0-Row7 アノード (High=選択)
```

---

## 動作仕様

### タイミング

| パラメータ           | 値            | 備考                    |
|---------------------|--------------|------------------------|
| システムクロック     | 50 MHz       | 内蔵OSC_CLK            |
| PWMビット数         | 3 bit        | 8階調 (0=消灯, 7=最大輝度)|
| スキャン周波数       | ~200 Hz      | ちらつきなし            |
| 1行表示時間         | ~625 µs      | 8 PWMステップ × 78µs   |
| フレーム切り替え     | 0.5秒        | アニメーション速度       |
| フレーム数           | 4            | 'R','e','n','e' 循環    |

### フレームバッファ形式

```
[31:24] = 赤カラムマスク (bit7=Col0, bit0=Col7)
[23:16] = 緑カラムマスク (bit7=Col0, bit0=Col7)
[15: 6] = 未使用
[ 5: 3] = 行の赤輝度 (3bit, 0-7)
[ 2: 0] = 行の緑輝度 (3bit, 0-7)
```

### 色定義

| フレーム | 文字 | 色   | R輝度 | G輝度 |
|---------|-----|------|------|------|
| 0       | R   | 赤   | 7    | 0    |
| 1       | e   | 黄   | 7    | 7    |
| 2       | n   | 緑   | 0    | 7    |
| 3       | e   | 橙   | 7    | 2    |

---

## ビルド手順

### 1. シミュレーション (iverilog)

```bash
iverilog -o sim.vvp led_matrix_tb.v led_matrix_top.v
vvp sim.vvp
gtkwave led_matrix.vcd &
```

### 2. 合成 (Yosys + nextpnr-himbaechel)

```bash
# 合成
yosys -p "synth_himbaechel -top led_matrix_top -json led_matrix.json" led_matrix_top.v

# 配置配線
nextpnr-himbaechel --device SLG47910V \
    --json led_matrix.json \
    --pcf led_matrix.pcf \
    --write led_matrix_routed.json

# ビットストリーム生成
gowin_pack -d SLG47910V -o led_matrix.fs led_matrix_routed.json
```

### 3. FPGA書き込み (Shrike liteのMicroPython経由)

```python
# Shrike lite MicroPython (RP2040)
from shrike_fpga import ShrikeFPGA

fpga = ShrikeFPGA()
fpga.load_bitstream("led_matrix.fs")
```

---

## 注意事項

1. **ピン番号の確認**: `led_matrix.pcf` の `IOB_12` 等はFPGAの物理ピン番号です。
   ボードのシルク印刷やGitHubのピンアウト図（`Docs/images/shrike_pinouts.png`）と
   照合して正しいピン番号を設定してください。

2. **OE端子**: 74LS595のOE（出力イネーブル）はGNDに固定接続してください。

3. **電流制限抵抗**: 各LEDカソードラインに適切な電流制限抵抗（例：100Ω）を
   入れてください。

4. **sr_clkとsr_latの空きGPIO**: `led_matrix.pcf` で `IOB_8`, `IOB_9` を
   割り当てていますが、使用していない任意のFPGA GPIOに変更可能です。

5. **LUT使用量見積もり**: 本設計は約150〜250 LUT程度を使用する見込みです
   （SLG47910Vの1120 LUT中の約15〜22%）。BRAMは使用せず分散RAMを使用します。

---

## 拡張アイデア

- フレームバッファを8×8×6bit（各ピクセル個別色）に拡張
- "Renesas" 全7文字のスクロール表示
- RP2040からSPIでフレームデータを動的更新
