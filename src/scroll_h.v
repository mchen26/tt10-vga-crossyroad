module scroll_h (
    output reg [9:0] h_pos, // Counter for scrolling down
    output reg move_followers, //Tells other obstacles when to move
    input wire reset,
    input wire [6:0] score,
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
            h_pos <= 10'b0;                // Reset position to top
            ctr <= 0;                  // Reset counter
            move_followers <= 0;
        end else begin
            ctr <= ctr + 1;
            if (ctr >= (SPEED)) begin
                move_followers <= 1;
                ctr <= {11'b0, score} << 8; // Increase speed as score increases
                if ((h_pos + move_amt) >= SCREEN_WIDTH) begin
                    h_pos <= 0;
                end else begin
                    h_pos <= h_pos + move_amt;
                end 
            end else
                move_followers <= 0;
        end
    end
endmodule