module scroll_v_follower (
    output reg [9:0] y_pos, // Counter for scrolling down
    input wire [9:0] start_posy,
    input wire move, // scroll_v tells when to move
    input wire reset,
    input wire clk
);

    // Parameters
    localparam move_amt = 2;           // Move amount per 40ms
    localparam SCREEN_HEIGHT = 480;    // Screen height
  
    // Obstacle Movement Logic
    always @(posedge clk) begin
        if (reset) begin
            y_pos <= start_posy;        // Reset position to top
        end else begin
          if (move) begin
              if ((y_pos + move_amt) >= SCREEN_HEIGHT) begin
                  y_pos <= 0;
              end else begin
                  y_pos <= y_pos + move_amt;
              end    
          end
        end
    end

endmodule