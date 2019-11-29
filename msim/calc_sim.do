vsim -t ns -novopt -lib work work.tb_calc
view *
do calc_wave.do
run 100 ms
