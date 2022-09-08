add wave MCLK
add wave SCLK
add wave LRCK
add wave i_adc_receiver/LRCK_curr
add wave i_adc_receiver/LRCK_prev
add wave i_adc_receiver/SCLK_curr
add wave i_adc_receiver/SCLK_prev
add wave ADIN_SDOUT
add wave -radix binary ADC_OUT
add wave -radix decimal i_adc_receiver/buf_idx

config wave -signalnamewidth 1
run 120 us
wave zoom full
