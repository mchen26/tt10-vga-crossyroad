/*
 * Copyright (c) 2025 Matthew Chen, Jovan Koledin, Ryan Leahy
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_10_vga_crossyroad (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  wire hsync, vsync;
  wire [2:0] rgb;
  wire unused;
  wire [7:0] unused_8;
  wire [6:0] unused_7;

  crossyroad game1 (
    .clk(clk),          // System clock
    .rst_man(!rst_n),      // Reset signal
    .move_btn(ui_in[0]),      // Button input for scrolling
    .hsync(hsync),       // Horizontal sync for VGA
    .vsync(vsync),       // Vertical sync for VGA
    .rgb(rgb)
  );
  
  /*
  uo_out Pinout:

  uo_out[0] - R1
  uo_out[1] - G1
  uo_out[2] - B1
  uo_out[3] - vsync
  uo_out[4] - R0
  uo_out[5] - G0
  uo_out[6] - B0
  uo_out[7] - hsync
  */
  assign uo_out = {hsync, rgb[0], rgb[1], rgb[2], vsync, rgb[0], rgb[1], rgb[2]};
  // All output/input pins must be assigned. If not used, assign to 0.
  assign uio_out = 0;
  assign uio_oe  = 0;
  assign unused = ena;
  assign unused_8 = uio_in;
  assign unused_7 = ui_in[7:1];

endmodule