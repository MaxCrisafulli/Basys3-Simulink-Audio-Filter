clc; clear;

%n = 55;
fs = 48e3;
flow = 0.3e3; Wlow = (flow/(fs/2));
fhigh = 3e3; Whigh = (fhigh/(fs/2));
%b = fir1(n,[Wlow Whigh],'bandpass');
%clear n fs flow fhigh Wlow Whigh;

n = 3;
PB_ripple = 1; %db
SB_atten = 50; %db


[b,a] = ellip(n,PB_ripple,SB_atten,[Wlow Whigh],'bandpass');


fvtool(b,a);