# Sipeed PMOD_LEDx8 サンプル (Tang Primer 25K / GOWIN EDA)

[Sipeed PMOD_LEDx8](https://wiki.sipeed.com/hardware/en/tang/tang-PMOD/FPGA_PMOD.html) の8個のLEDを使ったパターン表示デモです．

## ハードウェア
- FPGAボード: Tang Primer 25K Dock (GW5A-LV25MG121NES)
- Pmod: Sipeed PMOD_LEDx8 (LEDはアクティブLow)
- 接続ポート: G11,D11,B11,C11 / G10,D10,B10,C10 のPmodポート (Pmod_LCD096, Sipeed_POMD_DTx2 と同じポート)

## 動作
| ボタン | 機能 |
|---|---|
| S1 (H10) | リセット |
| S2 (H11) | 表示モード切替 |

| モード | 表示 |
|---|---|
| 0 | 流れるLED (L1 → L8) |
| 1 | ナイトライダー (往復) |
| 2 | 8bit バイナリカウンタ |
| 3 | ホタル (PWMで全LEDをゆっくり明滅) |

パターン更新は 8Hz です (`top.sv` のパラメータ `STEP_HZ` で変更できます)．

## ピン割り当て
| 信号 | LED | FPGAピン |
|---|---|---|
| led_n[0] | L1 | C10 |
| led_n[1] | L2 | C11 |
| led_n[2] | L3 | B10 |
| led_n[3] | L4 | B11 |
| led_n[4] | L5 | D10 |
| led_n[5] | L6 | D11 |
| led_n[6] | L7 | G10 |
| led_n[7] | L8 | G11 |

PMOD_LEDx8 は L1,L3,L5,L7 と L2,L4,L6,L8 がそれぞれ別の列に配線されているため，上下の列を交互に使う割り当てになっています (Pmod_DS2 の `pmod_led` と同じ割り当て)．

## ファイル
- `PMOD_LEDx8/PMOD_LEDx8.gprj` : GOWIN EDA プロジェクト
- `PMOD_LEDx8/src/top.sv` : デザイン本体 (SystemVerilog)
- `PMOD_LEDx8/src/top.cst` : 物理制約
- `PMOD_LEDx8/src/top.sdc` : タイミング制約 (50MHz)
- `PMOD_LEDx8/sim/tb_top.sv` : テストベンチ

## シミュレーション
```
cd PMOD_LEDx8
iverilog -g2012 -o tb sim/tb_top.sv src/top.sv && vvp tb
```
