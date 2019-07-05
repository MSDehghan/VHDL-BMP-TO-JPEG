quit -sim
project compileall
vsim -gui -novopt work.testbench(sim)
do wave.do
run 72 us