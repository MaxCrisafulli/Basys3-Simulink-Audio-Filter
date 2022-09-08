add wave -decimal f_out;
add wave -radix decimal i_top_audio_filter/INDB_OUT
add wave -radix decimal i_top_audio_filter/DAC_IN
config wave -signalnamewidth 1
run 400000 us
wave zoom full