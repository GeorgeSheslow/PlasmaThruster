module FireController(
input wire clk,
input wire trig_fire,
input wire fire,
output reg charge_rst,
output reg trig_charge,
output reg main_cap_charge,
input trig_finished,
input main_cap_finished,
output reg trigger);

initial begin 
	charge_rst = 0;
	trig_charge  =0;
	main_cap_charge = 0;
	trigger = 0;
end

reg trig_fire_latch = 0;

always @(posedge clk) begin 
	if(trig_fire & !trig_fire_latch) begin 
		trig_charge <= 1;
		trig_fire_latch <= 1;
		
	end
	else
		charge_rst <= 0;
	if(!trig_fire)
		trig_fire_latch <= 0;
	
	if(trig_fire_latch & trig_finished) begin
		trigger <= 1;
	end
	else
		trigger <= 0;
end

endmodule