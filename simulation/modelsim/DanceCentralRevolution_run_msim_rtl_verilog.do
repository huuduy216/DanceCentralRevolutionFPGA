transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Advanced\ Digital\ Circuit/DanceCentralRevolution {D:/Advanced Digital Circuit/DanceCentralRevolution/DanceCentralRevolution.v}
vlog -vlog01compat -work work +incdir+D:/Advanced\ Digital\ Circuit/DanceCentralRevolution {D:/Advanced Digital Circuit/DanceCentralRevolution/randomArrowGenerator.v}

