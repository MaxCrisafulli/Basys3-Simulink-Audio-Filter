add wave MCLK
add wave SCLK
add wave LRCK
add wave DB_OUT
add wave SDOUT
add wave -radix decimal i_dac_control/out_idx
config wave -signalnamewidth 1
run 120 us
wave zoom full
