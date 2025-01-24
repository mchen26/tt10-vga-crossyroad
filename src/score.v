/*
 * Copyright (c) 2025 Matthew Chen, Jovan Koledin, Ryan Leahy
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none

// Calculate and render score, score increments while user holds move button
module score #(
    //parameter SCORE_BACKGROUND_WIDTH = 640,
    parameter SCORE_BACKGROUND_HEIGHT = 32,
    //parameter SCORE_TOTAL_WIDTH = 46,
    parameter SCORE_WIDTH = 12,
    parameter SCORE_GAP = 4,
    parameter SCORE_HEIGHT = 28,
    parameter SCORE_HORIZONTAL_START_OFFSET = 590,
    parameter SCORE_VERTICAL_START_OFFSET = 2,
    parameter BANNER_COLOR = 3'b000, // WARNING: Black means no draw
    parameter DIGIT_COLOR  = 3'b100
)
(
    input wire i_clk,
    input wire i_rst_n,
    input wire [9:0] i_vpos,
    input wire [9:0] i_hpos,
    input wire [7:0] i_score,

    output reg [2:0] o_score_rgb
);

    reg [1:0] r_current_digits_place;
    reg [9:0] r_digit_horizontal_offset;

    wire w_digit_geometries[8:0];

    wire w_digit[9:0];

    /**
     * Determines which Nth place should be currently drawn on the screen for the score
     * given the horizontal position.
     *
     * Also indicates when the horizontal position is not in a place to draw the score.
    */
    assign r_current_digits_place = (i_hpos >= SCORE_HORIZONTAL_START_OFFSET &&
                                     i_hpos <  SCORE_HORIZONTAL_START_OFFSET + SCORE_WIDTH) ? 
                                        2'd2 : // 100's place
                                    (i_hpos >= SCORE_HORIZONTAL_START_OFFSET + SCORE_WIDTH + SCORE_GAP &&
                                     i_hpos <  SCORE_HORIZONTAL_START_OFFSET + 2*SCORE_WIDTH + SCORE_GAP) ?
                                        2'd1 : // 10's place
                                   (i_hpos >= SCORE_HORIZONTAL_START_OFFSET + 2*SCORE_WIDTH + 2*SCORE_GAP &&
                                    i_hpos <  SCORE_HORIZONTAL_START_OFFSET + 3*SCORE_WIDTH + 2*SCORE_GAP) ?
                                        2'd0 : // 1's place
                                        2'd3;  // Not in digit section.

    /**
     * Sets the horizontal draw offset for the score digits taking into account the Nth place horizontal position.
    */
    assign r_digit_horizontal_offset = (r_current_digits_place == 2'd2) ?
                                        SCORE_HORIZONTAL_START_OFFSET : // 100's place horizontal offset
                                       (r_current_digits_place == 2'd1) ? 
                                        SCORE_HORIZONTAL_START_OFFSET + SCORE_WIDTH + SCORE_GAP - 1 : // 10's place horizontal offset
                                        SCORE_HORIZONTAL_START_OFFSET + 2*SCORE_WIDTH + 2*SCORE_GAP - 1; // 1's place horizontal offset

    /**
     * The digits 0-9 are composed of different combinations of 9 geometrical shapes that overlap.
     *
     * In the docs directory, you can find an image showing these geometries represented as different colors.
    */
    // RED
    assign w_digit_geometries[0] = (i_vpos >= SCORE_VERTICAL_START_OFFSET      && i_vpos < SCORE_VERTICAL_START_OFFSET +  4) &&
                                   (i_hpos >= r_digit_horizontal_offset        && i_hpos < r_digit_horizontal_offset   +  8);

    // CYAN
    assign w_digit_geometries[1] = (i_vpos >= SCORE_VERTICAL_START_OFFSET      && i_vpos < SCORE_VERTICAL_START_OFFSET + 16) &&
                                   (i_hpos >= r_digit_horizontal_offset        && i_hpos < r_digit_horizontal_offset   +  4);

    // MAGENTA
    assign w_digit_geometries[2] = (i_vpos >= SCORE_VERTICAL_START_OFFSET + 16 && i_vpos < SCORE_VERTICAL_START_OFFSET + 24) &&
                                   (i_hpos >= r_digit_horizontal_offset        && i_hpos < r_digit_horizontal_offset   +  4);

    // YELLOW
    assign w_digit_geometries[3] = (i_vpos >= SCORE_VERTICAL_START_OFFSET + 24 && i_vpos < SCORE_VERTICAL_START_OFFSET + 28) &&
                                   (i_hpos >= r_digit_horizontal_offset        && i_hpos < r_digit_horizontal_offset   + 12);

    // PURPLE
    assign w_digit_geometries[4] = (i_vpos >= SCORE_VERTICAL_START_OFFSET + 16 && i_vpos < SCORE_VERTICAL_START_OFFSET + 28) &&
                                   (i_hpos >= r_digit_horizontal_offset   +  8 && i_hpos < r_digit_horizontal_offset   + 12);

    // BLUE
    assign w_digit_geometries[5] = (i_vpos >= SCORE_VERTICAL_START_OFFSET      && i_vpos < SCORE_VERTICAL_START_OFFSET + 16) &&
                                   (i_hpos >= r_digit_horizontal_offset   +  8 && i_hpos < r_digit_horizontal_offset   + 12);

    // GREEN
    assign w_digit_geometries[6] = (i_vpos >= SCORE_VERTICAL_START_OFFSET + 12 && i_vpos < SCORE_VERTICAL_START_OFFSET + 16) &&
                                   (i_hpos >= r_digit_horizontal_offset        && i_hpos < r_digit_horizontal_offset   + 12);

    // ORANGE
    assign w_digit_geometries[7] = (i_vpos >= SCORE_VERTICAL_START_OFFSET +  4 && i_vpos < SCORE_VERTICAL_START_OFFSET + 24) &&
                                   (i_hpos >= r_digit_horizontal_offset   +  4 && i_hpos < r_digit_horizontal_offset   +  8);

    // BLACK
    assign w_digit_geometries[8] = (i_vpos >= SCORE_VERTICAL_START_OFFSET      && i_vpos < SCORE_VERTICAL_START_OFFSET +  4) &&
                                   (i_hpos >= r_digit_horizontal_offset   +  8 && i_hpos < r_digit_horizontal_offset   + 12);

    /**
     * In the doc directory, you can find an image showing the different geometries that compose the digits.
    */
    assign w_digit[0] = w_digit_geometries[0] || w_digit_geometries[1] || w_digit_geometries[2] || w_digit_geometries[3] ||
                        w_digit_geometries[4] || w_digit_geometries[5];

    assign w_digit[1] = w_digit_geometries[0] || w_digit_geometries[7] || w_digit_geometries[3];


    assign w_digit[2] = w_digit_geometries[0] || w_digit_geometries[5] || w_digit_geometries[6] || w_digit_geometries[2] ||
                        w_digit_geometries[3];

    assign w_digit[3] = w_digit_geometries[0] || w_digit_geometries[5] || w_digit_geometries[6] || w_digit_geometries[4] ||
                        w_digit_geometries[3];

    assign w_digit[4] = w_digit_geometries[1] || w_digit_geometries[6] || w_digit_geometries[5] || w_digit_geometries[4];


    assign w_digit[5] = w_digit_geometries[8] || w_digit_geometries[0] || w_digit_geometries[1] || w_digit_geometries[6] ||
                        w_digit_geometries[4] || w_digit_geometries[3];

    assign w_digit[6] = w_digit_geometries[8] || w_digit_geometries[0] || w_digit_geometries[1] || w_digit_geometries[6] ||
                        w_digit_geometries[4] || w_digit_geometries[3] || w_digit_geometries[2];

    assign w_digit[7] = w_digit_geometries[0] || w_digit_geometries[5] || w_digit_geometries[4];


    assign w_digit[8] = w_digit_geometries[8] || w_digit_geometries[0] || w_digit_geometries[1] || w_digit_geometries[6] ||
                        w_digit_geometries[4] || w_digit_geometries[3] || w_digit_geometries[2] || w_digit_geometries[5];

    assign w_digit[9] = w_digit_geometries[8] || w_digit_geometries[0] || w_digit_geometries[1] || w_digit_geometries[6] ||
                        w_digit_geometries[4] || w_digit_geometries[5];


always @(posedge i_clk) begin
    if (i_rst_n && i_vpos <= SCORE_BACKGROUND_HEIGHT) begin
        if(i_vpos < SCORE_VERTICAL_START_OFFSET   && i_vpos > SCORE_VERTICAL_START_OFFSET + SCORE_HEIGHT &&
           r_current_digits_place == 2'd3) begin
            o_score_rgb <= BANNER_COLOR; // Currently not in the region that the score can be drawn in. Draw the banner background.
        end
        else if (r_current_digits_place == 2'd2) begin // Draw 100's place digit
            o_score_rgb <= (w_digit[i_score / 100]) ? DIGIT_COLOR : BANNER_COLOR;
        end
        else if (r_current_digits_place == 2'd1) begin // Draw 10's place digit
            o_score_rgb <= (w_digit[(i_score / 10) % 10]) ? DIGIT_COLOR : BANNER_COLOR;
        end
        else begin // Draw 1's place digit
            o_score_rgb <= (w_digit[(i_score) % 10]) ? DIGIT_COLOR : BANNER_COLOR;
        end
    end
    else begin
        o_score_rgb <= 3'b000; // WARNING: Black means no draw
    end
end

endmodule
