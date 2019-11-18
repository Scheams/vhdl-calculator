onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_io_ctrl/s_reset_i
add wave -noupdate /tb_io_ctrl/s_clk_i
add wave -noupdate -radix unsigned /tb_io_ctrl/u_sim/s_clock_counter
add wave -noupdate /tb_io_ctrl/u_sim/s_clock_enable
add wave -noupdate /tb_io_ctrl/s_pb_i
add wave -noupdate /tb_io_ctrl/s_pbsync_o
add wave -noupdate /tb_io_ctrl/s_sw_i
add wave -noupdate /tb_io_ctrl/s_swsync_o
add wave -noupdate /tb_io_ctrl/s_led_i
add wave -noupdate /tb_io_ctrl/s_led_o
add wave -noupdate /tb_io_ctrl/s_ss_sel_o
add wave -noupdate /tb_io_ctrl/s_ss_o
add wave -noupdate /tb_io_ctrl/s_dig0_i
add wave -noupdate /tb_io_ctrl/s_dig1_i
add wave -noupdate /tb_io_ctrl/s_dig2_i
add wave -noupdate /tb_io_ctrl/s_dig3_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1626517 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 224
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
WaveRestoreZoom {72895826 ns} {76468831 ns}
