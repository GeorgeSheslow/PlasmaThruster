module serialGPIO(
    input clk,
    input RxD,
    output TxD,

    output reg fire,
	 output reg trigger_fire,
	 output reg trigger_test,
	 output reg trig_charge,
	 output reg cap_charge,
	 output reg charge_rst,
	 output reg [7:0] trigger_duration_us,
	 output reg [7:0] resistance,
	 output reg spi_write,
	 output reg select
);

wire RxD_data_ready;
wire [7:0] RxD_data;

reg[7:0] tx_msg = 0;
reg tx_ready = 0;

reg write_flag = 0;
reg [4:0] reg_number = 0;
reg [2:0] counter = 0;
reg [2:0] trig_counter = 0;
reg [7:0] resistance_trigger = 200;
reg [7:0] resistance_main_cap = 200;
reg [2:0] spi_counter = 0;
reg [2:0] op_counter = 0;

initial begin
   trigger_duration_us = 0;
	resistance = 0;
	select = 0;
	spi_write = 0;
end

always @(posedge clk) begin

	if(RxD_data_ready && counter==0) begin
			//Parameter Msg: [7] Operation | [6] (Write) | [5] (Read) | [4:0] value followed by value
			// Op Msgs:
			//    0 = Ping (Aliveness Check)
			// 	1 = Fire Thruster
			//		2 = Fire Trigger
			//    3 = Trigger Test
			//    4 = Trigger Charge
			//    5 = Main Cap Charge
			//    6 = Charge Reset
		if(write_flag == 0) begin
			reg_number = RxD_data[4:0];
			if(RxD_data[7]) begin
				if (reg_number == 0) begin
					tx_msg <= 8'hA0;
				end
				else if (reg_number == 1) begin
					fire <= 1;
					tx_msg <= 8'hA1;
				end
				else if(reg_number == 2) begin
					trigger_fire <= 1;
					tx_msg <= 8'hA2;
				end
				else if(reg_number == 3) begin
					trigger_test <= 1;
					tx_msg <= 8'hA3;
				end
				else if(reg_number == 4) begin
					trig_charge <= 1;
					tx_msg <= 8'hA4;
				end
				else if(reg_number == 5) begin
					cap_charge <= 1;
					tx_msg <= 8'hA5;
				end
				else if(reg_number == 6) begin
					charge_rst <= 1;
					tx_msg <= 8'hA6;
				end
				else begin
					tx_msg <= 8'hD1;
				end
				op_counter <= 1;
			end
			else if(RxD_data[6]) begin //write
				write_flag <= 1;
				tx_msg <= 8'hBB;
			end
			else if(RxD_data[5]) begin // read
				// return value
				if(reg_number == 1) // trigger_duration 
					tx_msg <= trigger_duration_us;
				else if (reg_number == 2)
					tx_msg <= resistance_trigger;
				else if (reg_number == 3)
					tx_msg <= resistance_main_cap;
				else
					tx_msg <= 0;
			end
		end  
		else begin // write the next byte of data to memory
			if(reg_number == 1) begin
				trigger_duration_us <= RxD_data;
				tx_msg <= 8'hC1;
			end
			else if(reg_number == 2) begin
				resistance_trigger <= RxD_data;
				resistance <= RxD_data;
				select <= 0;
				spi_write <= 1;
				tx_msg <= 8'hC2;
			end
			else if(reg_number == 3) begin
				resistance_main_cap <= RxD_data;
				resistance <= RxD_data;
				select <= 1;
				spi_write <= 1;
				tx_msg <= 8'hC3;
			end
			else
				tx_msg <= 8'hD2;
			write_flag <= 0;
		end
		tx_ready <= 1;
	end
	else begin
		// reset flags
		if(op_counter > 0)
			op_counter <= op_counter + 1;
		if(op_counter > 5) begin
			fire <= 0;
			trigger_fire <= 0;
			trigger_test <= 0;
			trig_charge <= 0;
			cap_charge <= 0;
			charge_rst <= 0;
			op_counter <= 0;
		end
		
		if(spi_write)
			spi_counter <= spi_counter + 1;
		if(spi_counter > 5) begin
			spi_write <= 0;
			spi_counter <= 0;
		end
		tx_ready <= 0;
	end
end

async_receiver RX(.clk(clk), .RxD(RxD), .RxD_data_ready(RxD_data_ready), .RxD_data(RxD_data));
async_transmitter TX(.clk(clk), .TxD(TxD), .TxD_start(tx_ready), .TxD_data(tx_msg));
endmodule