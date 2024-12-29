/*
 * Copyright (c) 2025 Matthew Chen, Jovan Koledin, Ryan Leahy
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt10_vga_crossyroad (
    input wire move,

    output wire vga_hsync,
    output wire vga_vsync,
    output wire [3:0] vga_red,
    output wire [3:0] vga_green,
    output wire [3:0] vga_blue,

    input wire clk,
    input wire sys_rst,

);

wire [9:0] vaddr;
wire [9:0] haddr;



module vga (
    .vaddr(vaddr),
    .haddr(haddr),
    .vsync(vs),
    .hsync(hs),

    .rst(sys_rst),
    .clk(clk)
);

endmodule