onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /testbench/clk
add wave -noupdate -radix decimal /testbench/reset
add wave -noupdate -radix decimal /testbench/w
add wave -noupdate -radix decimal /testbench/h
add wave -noupdate -radix decimal /testbench/top/clk
add wave -noupdate -radix decimal /testbench/top/reset
add wave -noupdate -radix decimal /testbench/top/width
add wave -noupdate -radix decimal /testbench/top/height
add wave -noupdate -radix decimal /testbench/top/next_i
add wave -noupdate -radix decimal /testbench/top/next_j
add wave -noupdate -radix decimal /testbench/top/current_i
add wave -noupdate -radix decimal /testbench/top/current_j
add wave -noupdate -radix decimal /testbench/top/current_state
add wave -noupdate -radix decimal /testbench/top/next_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 215
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {105 ns}
