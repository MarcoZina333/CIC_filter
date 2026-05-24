#!/bin/bash
ghdl -a ./reg_sol.vhd
ghdl -a ./adder.vhd
ghdl -a ./clock_divider.vhd
ghdl -a ./testbench.vhd

ghdl --elab-run testbench --vcd=./result.vcd --stop-time=1000ns
read -p "Press enter to continue"
