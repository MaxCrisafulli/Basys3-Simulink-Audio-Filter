add wave nRst
add wave MCLK
add wave SCLK
add wave LRCK
add wave TB_STIM/TEST_WORD
add wave SDIN
add wave ADC_OUT
add wave -radix decimal i_adc_receiver/buf_idx
add wave i_double_buffer/bufferA
add wave i_double_buffer/bufferB
add wave DB_OUT

config wave -signalnamewidth 1
run 100 us
wave zoom full
