module scroll_h (
    output reg [9:0] h_pos, // Counter for scrolling down
    input wire reset,
    input wire clk
);

    // Parameters
    localparam move_amt = 2;           // Move amount per 10ms
    localparam SCREEN_WIDTH = 640;    // Screen height
    localparam SPEED = 15000;         // 10ms at 25MHz clock

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
              if ((h_pos + move_amt) >= SCREEN_WIDTH) begin
                  h_pos <= 0;
              end else begin
                  h_pos <= h_pos + move_amt;
              end 
            end
        end
    end
endmodule