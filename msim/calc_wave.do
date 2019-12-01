onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_calc/s_reset_i
add wave -noupdate /tb_calc/s_clk_i
add wave -noupdate /tb_calc/s_sw_i
add wave -noupdate /tb_calc/s_pb_i
add wave -noupdate /tb_calc/s_ss_o
add wave -noupdate /tb_calc/s_ss_sel_o
add wave -noupdate /tb_calc/s_led_o
add wave -noupdate -expand /tb_calc/u_dut/u_io_ctrl/pbsync_o
add wave -noupdate /tb_calc/u_dut/u_calc_ctrl/s_state
add wave -noupdate -radix hexadecimal /tb_calc/u_dut/s_result
add wave -noupdate -radix hexadecimal /tb_calc/s_sw_op
add wave -noupdate -radix hexadecimal /tb_calc/u_dut/u_calc_ctrl/s_op1_o
add wave -noupdate -radix hexadecimal /tb_calc/u_dut/u_calc_ctrl/s_op2_o
add wave -noupdate /tb_calc/u_dut/u_calc_ctrl/s_dig3
add wave -noupdate /tb_calc/u_dut/u_calc_ctrl/s_dig2
add wave -noupdate /tb_calc/u_dut/u_calc_ctrl/s_dig1
add wave -noupdate /tb_calc/u_dut/u_calc_ctrl/s_dig0
add wave -noupdate /tb_calc/u_dut/u_calc_ctrl/s_optype
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {38835616 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 209
configure wave -valuecolwidth 119
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {126 ms}
