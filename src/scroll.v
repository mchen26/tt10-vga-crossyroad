module scroll (
    output reg [9:0] y_pos, // Counter for scrolling down
    input wire move_btn,
    input wire reset,
    input wire clk
);

    // Parameters
    localparam move_amt = 5;           // Move amount per 10ms
    localparam SCREEN_HEIGHT = 480;    // Screen height
    localparam SPEED = 250000;         // 10ms at 25MHz clock

    // Internal Registers
    reg [17:0] ctr;                    // Counter for timing
    reg move_active;                   // Tracks whether the move action is active

    // Obstacle Movement Logic
    always @(posedge clk) begin
        if (reset) begin
            y_pos <= 0;                // Reset position to top
            ctr <= 0;                  // Reset counter
            move_active <= 0;          // Deactivate movement
        end else begin
            // Button press triggers movement
            if (move_btn) begin
                if (!move_active) begin
                    move_active <= 1;  // Activate movement
                end
            end else begin
                move_active <= 0;      // Deactivate movement
            end

            // Counter for speed control
            if (move_active) begin
                ctr <= ctr + 1;
                if (ctr >= SPEED) begin
                    ctr <= 0;
                    y_pos <= y_pos + move_amt; // Move down
                    if (y_pos >= SCREEN_HEIGHT) begin
                        y_pos <= 0;    // Reset to top when exceeding screen height
                    end
                end
            end else begin
                ctr <= 0;              // Reset counter if not active
            end
        end
    end

endmodule
