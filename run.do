vlib work
vlog -f src_files.txt +cover +covercells -sv
vsim -voptargs=+acc work.FIFO_top -cover -classdebug -uvmcontrol=all
add wave -position insertpoint sim:/FIFO_top/dut/* \
sim:/FIFO_top/dut/mem
coverage save -onexit FIFO.ucdb
run -all