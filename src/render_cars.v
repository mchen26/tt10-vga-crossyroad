/*
 * Copyright (c) 2025 Matthew Chen, Jovan Koledin, Ryan Leahy
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none

// Calculate X-position for car obstacles
module rendering (
    output wire pixel,
    output wire collision,
    output reg [2:0] car_select,

    input wire game_over,
    input wire game_start_blink,
    input wire score_pixel,
    
    input wire [2:0] car_type,
    input wire [9:0] vaddr,
    input wire [9:0] haddr,
    input wire [10:0] scrolladdr,

    input wire clk,
    input wire sys_rst
);
