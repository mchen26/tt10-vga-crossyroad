module scroll_h (
    output reg [9:0] h_pos, // Counter for scrolling down
    input wire reset,
    input wire [9:0] start_posx,
    input wire [7:0] score,
    input wire clk
);

    // Parameters
    localparam move_amt = 2;           // Move amount per 40ms
    localparam SCREEN_WIDTH = 640;    // Screen height
    localparam SPEED = 100000;         // 40ms at 25MHz clock

    // Internal Registers
    reg [17:0] ctr;                    // Counter for timing

    // Obstacle Movement Logic
    always @(posedge clk) begin
        if (reset) begin
            h_pos <= start_posx;                // Reset position to top
            ctr <= 0;                  // Reset counter
        end else begin
            ctr <= ctr + 1;
          if (ctr >= (SPEED)) begin
              ctr <= {10'b0, score} << 8; // Increase speed as score increases
              if ((h_pos + move_amt) >= SCREEN_WIDTH) begin
                  h_pos <= 0;
              end else begin
                  h_pos <= h_pos + move_amt;
              end 
            end
        end
    end
endmodule