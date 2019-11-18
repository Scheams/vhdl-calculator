vsim -t ns -novopt -lib work work.tb_io_ctrl
view *
do wave.do
run 100 ms
