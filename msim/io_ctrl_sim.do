vsim -t ns -novopt -lib work work.tb_io_ctrl
view *
do io_ctrl_wave.do
run 10 ms
