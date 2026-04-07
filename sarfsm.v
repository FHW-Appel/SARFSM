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


`ifdef FORMAL

    reg f_past_valid = 0;

    initial assume (rst_n == 0);
    always @(posedge clk) begin
        
        f_past_valid <= 1;

        if (f_past_valid) begin
            
            // Cover 0101 at the output
            _c_0101_: cover(sar_out == 4'b0101);

            // Cover 1010 at the output
            _c_1010_: cover(sar_out == 4'b1010);

            // cover reset behavior
            _c_reset_: cover($past(rst_n) == 0 && sar_out == 4'b0000);

            // After reset, ivalues should be zero
            if ($past(rst_n) == 0) begin
                _a_prove_reset_: assert(sar_out == 4'b0000);
            end else begin
                // Check behavior based on compare signal
                if ($past(compare)) begin
                    _a_prove_set_bit_: assert(sar_out == ($past(sar_out) | $past(active_bit)));
                end else begin
                    _a_prove_no_set_bit_: assert(sar_out == $past(sar_out));
                end
            end
        end

    end
`endif

endmodule