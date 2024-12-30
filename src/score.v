/*
 * Copyright (c) 2025 Matthew Chen, Jovan Koledin, Ryan Leahy
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none

// Calculate and render score, score increments while user holds move button
module score (
    input wire [9:0] vaddr,
    input wire [9:0] haddr,
    input wire move_btn,
    input wire halt,

    output reg pixel,
    output wire [15:0] score_out,

	  input wire game_rst,
    input wire clk,
    input wire sys_rst
);

localparam SCORE_INC_TIME = 5000000;
