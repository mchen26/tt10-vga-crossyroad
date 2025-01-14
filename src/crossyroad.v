/*
 * Copyright (c) 2025 Matthew Chen, Jovan Koledin, Ryan Leahy
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module crossyroad  (
    input clk,          // System clock
    input rst_man,      // Reset signal
    input move_btn,      // Button input for scrolling
    output hsync,       // Horizontal sync for VGA
    output vsync,       // Vertical sync for VGA
    output [2:0] rgb
);

    // VGA Resolution
    localparam SCREEN_WIDTH = 640;
    localparam SCREEN_HEIGHT = 480;
    localparam OBSTACLE_WIDTH = 50;
    localparam OBSTACLE_HEIGHT = 30;
    localparam CHICKEN_X = 310;
    localparam CHICKEN_Y = 400;
    localparam CHICKEN_WIDTH = 30;
    localparam CHICKEN_HEIGHT = 40;

    // Internal signals
    wire [9:0] pixel_x, pixel_y; // VGA pixel coordinates
    wire [9:0] obstacle_y;       // Obstacle Y position
    wire [9:0] obstacle_x;       // Obstacle X position (Corrected typo)
    wire [7:0] score;
    wire rst;
    wire video_on;            // VGA video enable

    // VGA Controller Instance
    vga vga_inst (
        .clk(clk),
        .reset(rst),
        .hsync(hsync),
        .vsync(vsync),
        .display_on(video_on),
        .hpos(pixel_x),
        .vpos(pixel_y)
    );

    scroll_v scroll_v_inst (
        .clk(clk),
        .reset(rst),
        .move_btn(move_btn),
        .score(score),
        .y_pos(obstacle_y)
    );

    scroll_h scroll_h_inst (
        .clk(clk),
        .reset(rst),
        .h_pos(obstacle_x)
    );

    // VGA Display & Collision Logic (Optimized)
    wire obstacle_hit = (pixel_x >= obstacle_x) && (pixel_x < obstacle_x + OBSTACLE_WIDTH) &&
                         (pixel_y >= obstacle_y) && (pixel_y < obstacle_y + OBSTACLE_HEIGHT);

    wire chicken_hit = (pixel_x >= CHICKEN_X) && (pixel_x < CHICKEN_X + CHICKEN_WIDTH) &&
                        (pixel_y >= CHICKEN_Y) && (pixel_y < CHICKEN_Y + CHICKEN_HEIGHT);

    assign rgb = (video_on) ?
                 (obstacle_hit && chicken_hit) ? 3'b011 : // Obstacle and chicken overlap (Yellow)
                 (obstacle_hit) ? 3'b100 :           // Obstacle (Red)
                 (chicken_hit) ? 3'b010 :            // Chicken (Green)
                 3'b001 :                          // Background (Blue)
                 3'b000;                           // Blanking (Black)

    wire rst_collision = obstacle_hit && chicken_hit; // If collision activate reset
    assign rst = rst_man | rst_collision;

endmodule