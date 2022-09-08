% VOICE BAND BANDPASS

fs = 48e3; %sampling frequency
flow = 0.4e3; Wlow = flow/(fs/2); %normalized flow
fhigh = 2.5e3; Whigh = fhigh/(fs/2); %normalized fhigh
n = 3; %filter order
PB_ripple = 1; %1db
SB_atten = 60; %60db attenuation

% Generate Elliptic IIR Filter Coefficients
[b,a] = ellip(n,PB_ripple,SB_atten,[Wlow Whigh], 'bandpass');


% VOICE BANDSTOP
%{
fs = 48e3; %sampling frequency
flow = 0.15e3; Wlow = flow/(fs/2); %normalized flow
fhigh = 4.5e3; Whigh = fhigh/(fs/2); %normalized fhigh
n = 3; %filter order
PB_ripple = 1; %1db
SB_atten = 50; %60db attenuation


% Generate Elliptic IIR Filter Coefficients
[b,a] = ellip(n,PB_ripple,SB_atten,[Wlow Whigh], 'STOP');
%}

fvtool(b,a)
clear flow fhigh n Wlow Whigh PB_ripple SB_atten fs;