module scroll_v (
    output reg [9:0] y_pos, // Counter for scrolling down
    output reg [6:0] score,
    output reg move_followers, // Tells follower obstacles to move 
    input wire move_btn,
    input wire reset,
    input wire clk
);

    // Parameters
    localparam move_amt = 2;           // Move amount per 40ms
    localparam SCREEN_HEIGHT = 480;    // Screen height
    localparam SPEED = 100000;          // 40ms at 25MHz clock
    localparam SCORE_SPEED = 30;       // 1s score update
  
    // Internal Registers
    reg [17:0] ctr;                    // Counter for timing
    reg [6:0] score_ctr;

    // Obstacle Movement Logic
    always @(posedge clk) begin
        if (reset) begin
            y_pos <= 10'b0;        // Reset position to top
            ctr <= 0;                  // Reset counter
            score_ctr <= 0;
            score <= 0;
            move_followers <= 0;
        end else begin

            // Counter for speed control
            if (move_btn) begin
                ctr <= ctr + 1;
                if (ctr >= SPEED) begin
                    move_followers <= 1;
                    ctr <= 0;
                    score_ctr <= score_ctr + 1; 
                    if ((y_pos + move_amt) >= SCREEN_HEIGHT) begin
                        y_pos <= 0;
                    end else begin
                        y_pos <= y_pos + move_amt;
                    end    
                end else
                  move_followers <= 0;
                if (score_ctr == SCORE_SPEED) begin
                    score_ctr <= 0;
                    if(score < 99) begin
                        score <= score + 1;
                    end else
                        score <= 0;
                end
            end else begin
                move_followers <= 0;
            end
        end
    end

endmodule