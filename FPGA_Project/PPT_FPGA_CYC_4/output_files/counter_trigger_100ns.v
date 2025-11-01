module igbt_trigger_module (
    input wire clk,         // 50 MHz clock
    input wire rst,         // Synchronous reset
    output reg trigger,      // Output pulse
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
	if(rst && !done) begin
		triggering <= 1;
	end
	
	if(!rst && done)
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