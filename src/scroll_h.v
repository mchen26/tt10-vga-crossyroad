module scroll_h (
    output reg [9:0] h_pos, // Counter for scrolling down
    input wire reset,
    input wire clk
);

    // Parameters
    localparam move_amt = 5;           // Move amount per 10ms
    localparam SCREEN_WIDTH = 640;    // Screen height
    localparam SPEED = 250000;         // 10ms at 25MHz clock

    // Internal Registers
    reg [17:0] ctr;                    // Counter for timing

    // Obstacle Movement Logic
    always @(posedge clk) begin
        if (reset) begin
            h_pos <= 0;                // Reset position to top
            ctr <= 0;                  // Reset counter
        end else begin
            ctr <= ctr + 1;
            if (ctr >= SPEED) begin
                ctr <= 0;
                h_pos <= (h_pos + move_amt) % SCREEN_WIDTH; // Wrap back to 0
            end
        end
    end
endmodule