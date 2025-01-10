/*
 * Copyright (c) 2025 Matthew Chen, Jovan Koledin, Ryan Leahy
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module crossyroad  (
    input clk,          // System clock
    input reset,        // Reset signal
    input move_btn,       // Button input for scrolling
    output hsync,       // Horizontal sync for VGA
    output vsync,       // Vertical sync for VGA
    output [2:0] rgb
);

    // VGA Resolution
    parameter SCREEN_WIDTH = 640;
    parameter SCREEN_HEIGHT = 480;
    parameter OBSTACLE_WIDTH = 50;
    parameter OBSTACLE_HEIGHT = 30;

    // Internal signals
    wire [9:0] pixel_x, pixel_y; // VGA pixel coordinates
    wire [9:0] obstacle_y;        // Obstacle Y position
    wire [9:0] obstacle_x;        // Obstacle Y position
    wire video_on;               // VGA video enable

    // VGA Controller Instance
    vga vga_inst (
        .clk(clk),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .display_on(video_on),
        .hpos(pixel_x),
        .vpos(pixel_y)
    );

    scroll_v scroll_v_inst (
      .clk(clk),
      .reset(reset),
      .move_btn(move_btn),
      .y_pos(obstacle_y)
    );
  
    scroll_h scroll_h_inst (
      .clk(clk),
      .reset(reset),
      .h_pos(obstacle_x)
    );
    

    // VGA Display Logic
    reg vga_red, vga_green, vga_blue;

    always @(posedge clk) begin
        if (video_on) begin
            if (pixel_x >= obstacle_x && pixel_x < obstacle_x + OBSTACLE_WIDTH &&
                pixel_y >= obstacle_y && pixel_y < obstacle_y + OBSTACLE_HEIGHT) begin
                vga_red   <= 1; // Obstacle color
                vga_green <= 0;
                vga_blue  <= 0;
            end else begin
                vga_red   <= 0; // Background color
                vga_green <= 0;
                vga_blue  <= 1;
            end
        end else begin
            vga_red <= 0;
            vga_green <= 0;
            vga_blue <= 0;
        end
    end

  assign rgb = {vga_blue, vga_green, vga_red};

endmodule

