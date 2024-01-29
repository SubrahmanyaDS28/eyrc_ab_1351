transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {t2a_uart_tx.vo}

vlog -vlog01compat -work work +incdir+D:/my_eYRC/ab#1351_Task2A/t2a_uart/uart_tx/simulation/modelsim {D:/my_eYRC/ab#1351_Task2A/t2a_uart/uart_tx/simulation/modelsim/tb.v}

vsim -t 1ps -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  tb

add wave *
view structure
view signals
run 848500 ns
