// This is a SAR FSM implementation in Verilog.

module sar_fsm (
    input wire clk,          // Clock signal
    input wire rst_n,        // Active low reset synchronous signal
    input wire compare,      // Comparator output signal
    output reg [3:0] sar_out
);

reg [1:0] stage_counter; // Counter to keep track of the current stage

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sar_out <= 4'b0000; // Reset the SAR output
        stage_counter <= 2'd0;
    end else begin
        case (stage_counter)
            2'b00: begin
                if (compare) begin
                    sar_out[3] <= 1'b1; // Set the MSB if compare is high
                end
                stage_counter <= 2'd1; // Move to the next stage
            end
            2'b01: begin
                if (compare) begin
                    sar_out[2] <= 1'b1; // Set the next bit if compare is high
                end
                stage_counter <= 2'd2; // Move to the next stage
            end
            2'b10: begin
                if (compare) begin
                    sar_out[1] <= 1'b1; // Set the next bit if compare is high
                end
                stage_counter <= 2'd3; // Move to the next stage
            end
            2'b11: begin
                if (compare) begin
                    sar_out[0] <= 1'b1; // Set the LSB if compare is high
                end
            end
        endcase
    end
end
endmodule