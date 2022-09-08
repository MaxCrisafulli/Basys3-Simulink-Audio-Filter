n = 50; %filter order
fs = 48e3; %sampling frequency
flow = 2e3; Wlow = (flow)/(fs/2); %normalized flow
fhigh = 2.5e3; Whigh = (fhigh)/(fs/2); %normalized fhigh

%generate Bandpass FIR Coefficients with above parameters
b = fir1(n,[Wlow Whigh],'DC-0');


fvtool(b)
clear n fs fhigh flow whigh wlow corrfact;