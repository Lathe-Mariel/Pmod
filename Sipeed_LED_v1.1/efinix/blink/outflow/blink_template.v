
// Efinity Top-level template
// Version: 2026.1.132
// Date: 2026-06-11 04:01

// Copyright (C) 2013 - 2026 Efinix Inc. All rights reserved.

// This file may be used as a starting point for Efinity synthesis top-level target.
// The port list here matches what is expected by Efinity constraint files generated
// by the Efinity Interface Designer.

// To use this:
//     #1)  Save this file with a different name to a different directory, where source files are kept.
//              Example: you may wish to save as blink.v
//     #2)  Add the newly saved file into Efinity project as design file
//     #3)  Edit the top level entity in Efinity project to:  blink
//     #4)  Insert design content.


module blink
(
  (* syn_peri_port = 0 *) input clk,
  (* syn_peri_port = 0 *) output led_d1,
  (* syn_peri_port = 0 *) output led_d2,
  (* syn_peri_port = 0 *) output led_d3,
  (* syn_peri_port = 0 *) output led_d4,
  (* syn_peri_port = 0 *) output led0,
  (* syn_peri_port = 0 *) output led1,
  (* syn_peri_port = 0 *) output led2,
  (* syn_peri_port = 0 *) output led3,
  (* syn_peri_port = 0 *) output led4,
  (* syn_peri_port = 0 *) output led5,
  (* syn_peri_port = 0 *) output led6,
  (* syn_peri_port = 0 *) output led7
);


endmodule

