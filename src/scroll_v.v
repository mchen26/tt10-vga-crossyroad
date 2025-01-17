module scroll_v (
    output reg [9:0] y_pos, // Counter for scrolling down
    output reg [7:0] score,
    input wire [9:0] start_posy,
    input wire move_btn,
    input wire reset,
    input wire clk
);

    // Parameters
    localparam move_amt = 2;           // Move amount per 10ms
    localparam SCREEN_HEIGHT = 480;    // Screen height
    localparam SPEED = 25000;          // 10ms at 25MHz clock
    localparam SCORE_SPEED = 100;       // 1s score update
  
    // Internal Registers
    reg [17:0] ctr;                    // Counter for timing
    reg [7:0] score_ctr;
    reg move_active;                   // Track button press state

    // Obstacle Movement Logic
    always @(posedge clk) begin
        if (reset) begin
            y_pos <= start_posy;        // Reset position to top
            ctr <= 0;                  // Reset counter
            move_active <= 0;          // Deactivate movement
            score_ctr <= 0;
            score <= 0;
        end else begin
            if (move_btn) begin
                move_active <= 1;      // Activate movement
            end else begin
                move_active <= 0;      // Deactivate movement
            end

            // Counter for speed control
            if (move_active) begin
                ctr <= ctr + 1;
                if (ctr >= SPEED) begin
                    ctr <= 0;
                    score_ctr <= score_ctr + 1; 
                    if ((y_pos + move_amt) >= SCREEN_HEIGHT) begin
                        y_pos <= 0;
                    end else begin
                        y_pos <= y_pos + move_amt;
                    end    
                end
                if (score_ctr == SCORE_SPEED) begin
                    score_ctr <= 0;
                    score <= score + 1;
                end
            end else begin
                ctr <= 0; // Reset counter when not moving
            end
        end
    end

endmodule