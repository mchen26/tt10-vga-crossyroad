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
    //localparam SCREEN_WIDTH = 640;
    //localparam SCREEN_HEIGHT = 480;
    //localparam SCORE_WIDTH = 640;
    //localparam SCORE_HEIGHT = 32;
    localparam OBSTACLE_WIDTH = 50;
    localparam OBSTACLE_HEIGHT = 30;
    localparam CHICKEN_X = 310;
    localparam CHICKEN_Y = 400;
    localparam CHICKEN_WIDTH = 30;
    localparam CHICKEN_HEIGHT = 40;
    localparam OB_Y_OFFSET = 10'd150;
    localparam OB_X_OFFSET = 10'd250;


    // Internal signals
    wire [9:0] pixel_x, pixel_y; // VGA pixel coordinates
    wire [9:0] obstacle1_y, obstacle2_y;//, obstacle3_y;       // Obstacle Y position
    wire [9:0] obstacle1_x, obstacle2_x;//, obstacle3_x;       // Obstacle X position (Corrected typo)
    wire [7:0] score;
    wire [7:0] dummy_score1, dummy_score2; // Only want one scroll_v module to drive score
    wire [2:0] score_rgb;
    wire rst;
    wire video_on;            // VGA video enable

    // VGA Controller Instance
    vga vga_inst (
        .clk(clk),
        .reset(rst_man), // The VGA controller does not need to be reset when the game restarts.
        .hsync(hsync),
        .vsync(vsync),
        .display_on(video_on),
        .hpos(pixel_x),
        .vpos(pixel_y)
    );

    scroll_v scroll1_v_inst (
        .clk(clk),
        .reset(rst),
        .move_btn(move_btn),
        .score(score),
        .start_posy(10'b0),
        .y_pos(obstacle1_y)
    );

    scroll_h scroll1_h_inst (
        .clk(clk),
        .reset(rst),
        .score(score),
        .start_posx(10'b0),
        .h_pos(obstacle1_x)
    );

     scroll_v scroll2_v_inst (
        .clk(clk),
        .reset(rst),
        .move_btn(move_btn),
        .score(dummy_score1),
        .start_posy(OB_Y_OFFSET),
        .y_pos(obstacle2_y)
    );

    scroll_h scroll2_h_inst (
        .clk(clk),
        .reset(rst),
        .score(score),
        .start_posx(OB_X_OFFSET),
        .h_pos(obstacle2_x)
    );
    
    /*
    scroll_v scroll3_v_inst (
        .clk(clk),
        .reset(rst),
        .move_btn(move_btn),
        .score(dummy_score2),
        .start_posy(OB_Y_OFFSET << 1),
        .y_pos(obstacle3_y)
    );

    scroll_h scroll3_h_inst (
        .clk(clk),
        .reset(rst),
        .score(score),
        .start_posx(OB_X_OFFSET << 1),
        .h_pos(obstacle3_x)
    );
    */

    score score_inst(
        .i_clk(clk),
        .i_rst_n(~rst),
        .i_vpos(pixel_y),
        .i_hpos(pixel_x),
        .i_score(score),
        .o_score_rgb(score_rgb)
    );

    // VGA Display & Collision Logic (Optimized)
    wire obstacle1_hit = (pixel_x >= obstacle1_x) && (pixel_x < obstacle1_x + OBSTACLE_WIDTH) &&
                         (pixel_y >= obstacle1_y) && (pixel_y < obstacle1_y + OBSTACLE_HEIGHT);
    
    // VGA Display & Collision Logic for the second obstacle
    wire obstacle2_hit = (pixel_x >= obstacle2_x) && (pixel_x < obstacle2_x + OBSTACLE_WIDTH) &&
                         (pixel_y >= obstacle2_y) && (pixel_y < obstacle2_y + OBSTACLE_HEIGHT);
    
    // VGA Display & Collision Logic for the second obstacle
    /*
    wire obstacle3_hit = (pixel_x >= obstacle3_x) && (pixel_x < obstacle3_x + OBSTACLE_WIDTH) &&
                         (pixel_y >= obstacle3_y) && (pixel_y < obstacle3_y + OBSTACLE_HEIGHT);
    */
    // Check if vga scan hits chicken location
    wire chicken_hit = (pixel_x >= CHICKEN_X) && (pixel_x < CHICKEN_X + CHICKEN_WIDTH) &&
                       (pixel_y >= CHICKEN_Y) && (pixel_y < CHICKEN_Y + CHICKEN_HEIGHT);

    assign rgb = (video_on) ?
                    (score_rgb != 3'b000) ? score_rgb : // If score_rbg is not black. Draw it.
                    (obstacle1_hit && chicken_hit) ? 3'b011 : // Obstacle and chicken overlap (Yellow)
                    (obstacle2_hit && chicken_hit) ? 3'b011 : // Obstacle and chicken overlap (Yellow)
                    //(obstacle3_hit && chicken_hit) ? 3'b011 : // Obstacle and chicken overlap (Yellow)
                    (obstacle1_hit) ? 3'b100 :           // Obstacle (Red)
                    (obstacle2_hit) ? 3'b100 :           // Obstacle (Red)
                    //(obstacle3_hit) ? 3'b100 :           // Obstacle (Red)
                    (chicken_hit) ? 3'b010 :            // Chicken (Green)
                    3'b001 :                          // Background (Blue)
                 3'b000;                           // Blanking (Black)

    wire rst_collision = (obstacle1_hit || obstacle2_hit) && chicken_hit; // If collision activate reset
    assign rst = rst_man | rst_collision;

endmodule
