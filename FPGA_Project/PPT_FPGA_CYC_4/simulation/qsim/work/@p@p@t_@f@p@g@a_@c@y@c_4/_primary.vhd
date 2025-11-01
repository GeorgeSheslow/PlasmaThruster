library verilog;
use verilog.vl_types.all;
entity PPT_FPGA_CYC_4 is
    port(
        LED1            : out    vl_logic;
        CLK             : in     vl_logic;
        B1              : in     vl_logic;
        LED2            : out    vl_logic
    );
end PPT_FPGA_CYC_4;
