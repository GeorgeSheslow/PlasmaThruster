library verilog;
use verilog.vl_types.all;
entity PPT_FPGA_CYC_4_vlg_sample_tst is
    port(
        B1              : in     vl_logic;
        CLK             : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end PPT_FPGA_CYC_4_vlg_sample_tst;
