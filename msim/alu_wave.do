onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_alu/s_reset_i
add wave -noupdate /tb_alu/s_clk_i
add wave -noupdate -radix hexadecimal /tb_alu/s_op1_i
add wave -noupdate -radix hexadecimal /tb_alu/s_op2_i
add wave -noupdate /tb_alu/s_optype_i
add wave -noupdate /tb_alu/s_start_i
add wave -noupdate /tb_alu/s_finished_o
add wave -noupdate -radix hexadecimal /tb_alu/s_result_o
add wave -noupdate /tb_alu/s_sign_o
add wave -noupdate /tb_alu/s_overflow_o
add wave -noupdate /tb_alu/s_error_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {980 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ns} {2310 ns}
