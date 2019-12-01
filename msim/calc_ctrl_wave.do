onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_calc_ctrl/s_reset_i
add wave -noupdate /tb_calc_ctrl/s_clk_i
add wave -noupdate /tb_calc_ctrl/s_swsync_i
add wave -noupdate -expand /tb_calc_ctrl/s_pbsync_i
add wave -noupdate /tb_calc_ctrl/s_finished_i
add wave -noupdate -radix hexadecimal /tb_calc_ctrl/s_result_i
add wave -noupdate /tb_calc_ctrl/s_sign_i
add wave -noupdate /tb_calc_ctrl/s_overflow_i
add wave -noupdate /tb_calc_ctrl/s_error_i
add wave -noupdate -radix hexadecimal /tb_calc_ctrl/s_op1_o
add wave -noupdate -radix hexadecimal /tb_calc_ctrl/s_op2_o
add wave -noupdate /tb_calc_ctrl/s_optype_o
add wave -noupdate /tb_calc_ctrl/u_sim/s_optype
add wave -noupdate /tb_calc_ctrl/s_start_o
add wave -noupdate /tb_calc_ctrl/s_dig0_o
add wave -noupdate /tb_calc_ctrl/s_dig1_o
add wave -noupdate /tb_calc_ctrl/s_dig2_o
add wave -noupdate /tb_calc_ctrl/s_dig3_o
add wave -noupdate /tb_calc_ctrl/u_sim/s_dig0
add wave -noupdate /tb_calc_ctrl/u_sim/s_dig1
add wave -noupdate /tb_calc_ctrl/u_sim/s_dig2
add wave -noupdate /tb_calc_ctrl/u_sim/s_dig3
add wave -noupdate -radix hexadecimal /tb_calc_ctrl/s_led_o
add wave -noupdate /tb_calc_ctrl/u_sim/s_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {589 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 176
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ns} {2205 ns}
