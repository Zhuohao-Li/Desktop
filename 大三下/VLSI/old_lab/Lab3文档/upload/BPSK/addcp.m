
% addcp.m

function [iout,qout]= addcp(idata,qdata,fftlen,gilen,nd)

%****************** variables *************************
% idata    : Input Ich data
% qdata    : Input Qch data
% iout     : Output Ich data
% qout     : Output Qch data
% fftlen   : Length of FFT (points)
% gilen    : Length of guard interval (points)
% *****************************************************

iout=[idata(fftlen-gilen+1:fftlen,:); idata];
qout=[qdata(fftlen-gilen+1:fftlen,:); qdata];

%******************** end of file ***************************

