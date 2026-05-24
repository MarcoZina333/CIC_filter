#!/bin/bash
ghdl -a ./reg_sol.vhd
ghdl -a ./adder.vhd
ghdl -a ./zero_insertion.vhd
ghdl -a ./testbench.vhd

ghdl --elab-run testbench --vcd=./result.vcd --stop-time=200ns
read -p "Press enter to continue"
