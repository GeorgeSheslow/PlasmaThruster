onerror {quit -f}
vlib work
vlog -work work PPT_FPGA_CYC_4.vo
vlog -work work PPT_FPGA_CYC_4.vt
vsim -novopt -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.PPT_FPGA_CYC_4_vlg_vec_tst
vcd file -direction PPT_FPGA_CYC_4.msim.vcd
vcd add -internal PPT_FPGA_CYC_4_vlg_vec_tst/*
vcd add -internal PPT_FPGA_CYC_4_vlg_vec_tst/i1/*
add wave /*
run -all
