# Rotary encoder counter for Tang Primer 25K

This project is a Veryl design for Tang Primer 25K. It reads a Digilent Pmod ENC rotary encoder on PMOD connector 3 and shows the count on a six-digit multiplexed 7-segment LED module connected to PMOD connectors 1 and 2.

## Behavior

- Encoder A/B are synchronized and filtered before quadrature decoding.
- The decimal value wraps from `999999` to `000000` when incrementing, and from `000000` to `999999` when decrementing.
- Pushing the encoder switch resets the displayed value to `000000`.
- The slide switch reverses the displayed count direction.
- Segment anodes are active-high and digit cathodes are active-low.

## Assumptions

- The onboard Tang Primer 25K clock is connected to FPGA pin `E2` and is `50 MHz`.
- The Pmod ENC push switch and slide switch are active-high, matching the Digilent reference manual description that outputs are low in their native/off state.
- Segment bit order is `{DP, G, F, E, D, C, B, A}` in the generated SystemVerilog vector, so `o_seg_anode[0]` drives segment A.

## Build

```powershell
veryl check
veryl build
```

The generated SystemVerilog is emitted under `target/`. Use `tang_primer_25k.cst` as the Gowin constraint file and set `rotary_encoder_Top` as the top-level module.
