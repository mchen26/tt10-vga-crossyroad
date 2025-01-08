/*
 * Copyright (c) 2025 Matthew Chen, Jovan Koledin, Ryan Leahy
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none

// Calculate y-position for safe areas (sidewalks) and unsafe areas (roads with cars) 
// Updates while user holds move button

module scroll (
    output reg [10:0] pos,

    input wire move_btn,
    input wire game_rst,
    input wire clk,
    input wire sys_rst
);

localparam INITIAL_SPEED = 250000; // 10ms at 25Mhz
