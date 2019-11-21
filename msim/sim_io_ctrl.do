vsim -t ns -novopt -lib work work.tb_io_ctrl
view *
do wave_io_ctrl.do
run 10 ms
