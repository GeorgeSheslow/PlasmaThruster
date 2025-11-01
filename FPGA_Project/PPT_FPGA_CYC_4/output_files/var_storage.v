module var_storage(
    input read,
    input write,
    output reg [7:0] GPout,  // general purpose outputs
    input [7:0] GPin  // general purpose inputs
);

always @(posedge read) if(GPin == 8'h01) GPout <= GPin;

endmodule