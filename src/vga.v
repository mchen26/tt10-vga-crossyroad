/*
 * Copyright (c) 2025 Matthew Chen, Jovan Koledin, Ryan Leahy
 * SPDX-License-Identifier: Apache-2.0
 */


`ifndef HVSYNC_GENERATOR_H
`define HVSYNC_GENERATOR_H

module vga (
    output reg [9:0] vpos,
    output reg [9:0] hpos,
    output reg vsync,
    output reg hsync,
    output display_on,

    input reset,
    input clk
);

    // declarations for TV-simulator sync parameters
    // horizontal constants
    parameter H_DISPLAY       = 640; // horizontal display width
    parameter H_BACK          =  48; // horizontal left border (back porch)
    parameter H_FRONT         =  16; // horizontal right border (front porch)
    parameter H_SYNC          =  96; // horizontal sync width
    // vertical constants
    parameter V_DISPLAY       = 480; // vertical display height
    parameter V_TOP           =  33; // vertical top border
    parameter V_BOTTOM        =  10; // vertical bottom border
    parameter V_SYNC          =   2; // vertical sync # lines
    // derived constants
    parameter H_SYNC_START    = H_DISPLAY + H_FRONT;
    parameter H_SYNC_END      = H_DISPLAY + H_FRONT + H_SYNC - 1;
    parameter H_MAX           = H_DISPLAY + H_BACK + H_FRONT + H_SYNC - 1;
    parameter V_SYNC_START    = V_DISPLAY + V_BOTTOM;
    parameter V_SYNC_END      = V_DISPLAY + V_BOTTOM + V_SYNC - 1;
    parameter V_MAX           = V_DISPLAY + V_TOP + V_BOTTOM + V_SYNC - 1;

    wire hmaxxed = (hpos == H_MAX) || reset; // set when hpos is maximum
    wire vmaxxed = (vpos == V_MAX) || reset; // set when vpos is maximum

    // position counter
    always @(posedge clk)
    begin
        if(hmaxxed) begin
            if(vmaxxed)
                vpos <= 0;
            else
                vpos <= vpos + 1;
            hpos <= 0;
        end 
        else begin
            hpos <= hpos + 1;
        end
        hsync <= (hpos >= H_SYNC_START && hpos <= H_SYNC_END);
        vsync <= (vpos >= V_SYNC_START && vpos <= V_SYNC_END);
    end

    // display_on is set when beam is in "safe" visible frame
    assign display_on = (hpos < H_DISPLAY) && (vpos < V_DISPLAY);

endmodule

`endif
