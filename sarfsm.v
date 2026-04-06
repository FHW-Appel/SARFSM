// This is a SAR FSM implementation in Verilog.

module sar_fsm (
    input wire clk,          // Clock signal
    input wire rst_n,        // Active low reset synchronous signal
    input wire compare,      // Comparator output signal
    output reg [3:0] sar_out
);

reg [3:0] active_bit; // One-hot selector for current SAR bit (MSB -> LSB)

always @(posedge clk) begin
    if (!rst_n) begin
        sar_out <= 4'b0000; // Reset the SAR output
        active_bit <= 4'b1000;
    end else begin
        if (compare) begin
                sar_out <= sar_out | active_bit; // Set currently selected bit
            end
        if (active_bit != 4'b0000) begin            
            active_bit <= active_bit >> 1; // Advance from MSB to LSB
        end
    end
end
endmodule