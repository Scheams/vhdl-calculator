vsim -t ns -novopt -lib work work.tb_alu
view *
do alu_wave.do
run 1 ms
