add wave LRCK
add wave ADC_OUT
add wave DB_OUT
add wave i_double_buffer/bufferA
add wave i_double_buffer/bufferB
config wave -signalnamewidth 1
run 150 us
wave zoom full
