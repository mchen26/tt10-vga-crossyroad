/*
 * Copyright (c) 2025 Matthew Chen, Jovan Koledin, Ryan Leahy
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt10_vga_crossyroad (
    input wire move,

    output wire [7:0] VGA_rgb;


    input wire clk,
    input wire sys_rst,

);
    
    // VGA signal wires
    wire hsync;
	wire vsync;
	wire [1:0] vga_red;
	wire [1:0] vga_green;
	wire [1:0] vga_blue;
    wire [9:0] vaddr;
    wire [9:0] haddr;

    module vga (
        .vaddr(vaddr),
        .haddr(haddr),
        .vsync(vsync),
        .hsync(hsync),
        .display_on(display_on)

        .rst(sys_rst),
        .clk(clk)
    );

    //  Assign each color bit to individual wires.
    wire vga_red = display_on & ;
    wire vga_green = display_on & ;
    wire vga_blue = display_on & ;

   	assign VGA_rgb = {hsync, vga_blue[0], vga_green[0], vga_red[0], 
                      vsync, vga_blue[1], vga_green[1], vga_red[1]};


endmodule