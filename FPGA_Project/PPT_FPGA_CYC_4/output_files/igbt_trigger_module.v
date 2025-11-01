module igbt_trigger (
    input wire clk,
    input wire enable,
    output reg trigger,
	 output reg done,
	 input wire [7:0] duration
);

reg triggering =0;

wire [15:0] ticks_duration = 50 * duration; // duration in us, clock 50MHz
reg [15:0] counter = 0;

initial begin
   trigger = 0;
	done    = 0;
end


 always @(posedge clk) begin
	if(enable && !done) begin
		triggering <= 1;
	end
	
	if(!enable && done)
		done <= 0;

	if(triggering && !done) begin
		 counter <= counter + 1;
		 trigger <= 1;
	end
	
	if (counter > ticks_duration) begin
		 counter    <= 0;
		 trigger    <= 0;
		 done       <= 1;
		 triggering <= 0;
	end 

 end
	 
endmodule