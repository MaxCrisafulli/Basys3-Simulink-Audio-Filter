np = 32;
A = round((2^23 -1)/2);
t = linspace(0,1-1/np,np);
sine_table_dec = round(A*sin(2*pi*t));
sine_table_bin = dec2bin(round(A*sin(2*pi*t)),6)
sine_table_hex = bin2hex(sine_table_bin);
stairs(t,sine_table_dec); grid on;