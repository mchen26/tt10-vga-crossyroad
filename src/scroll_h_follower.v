module scroll_h_follower (
    output reg [9:0] h_pos, // Counter for scrolling down
    input wire reset,
    input wire [9:0] start_posx,
    input wire move,
    input wire clk
);

    // Parameters
    localparam move_amt = 2;           // Move amount per 40ms
    localparam SCREEN_WIDTH = 640;    // Screen height

    // Obstacle Movement Logic
    always @(posedge clk) begin
        if (reset) begin
            h_pos <= start_posx;                // Reset position to top
        end else begin
            if (move) begin
                if ((h_pos + move_amt) >= SCREEN_WIDTH) begin
                    h_pos <= 0;
                end else begin
                    h_pos <= h_pos + move_amt;
                end 
            end
        end
    end
endmodule