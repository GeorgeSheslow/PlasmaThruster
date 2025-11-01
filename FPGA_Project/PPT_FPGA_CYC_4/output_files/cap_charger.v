module CapacitorCharger (
	input wire clk,
	input wire rst,
	input wire enable,
	input wire done,
	input wire fault,
	output wire on,
	output wire finished
);

reg enable_latch = 0;
reg done_latch = 0;
reg fault_latch = 0;

assign on = !done_latch & enable_latch & !fault_latch;
assign finished = done_latch & !fault_latch;

always @(posedge clk) begin 
	if(rst) begin
		enable_latch <= 0;
		done_latch <= 0;
		fault_latch <= 0;
	end
	if(enable)
		enable_latch <= 1;
	if(done)
		done_latch <= 1;
	if(fault)
		fault_latch <= 1;
end

endmodule