
% removecp.m

function [iout,qout]= removecp(idata,qdata,fftlen2,gilen)

%****************** variables *************************
% idata       : Input Ich data
% qdata       : Input Qch data
% iout        : Output Ich data
% qout        : Output Qch data
% fftlen2     : Length of FFT (points)
% gilen       : Length of guard interval (points)
% *****************************************************

iout=idata(gilen+1:fftlen2,:);
qout=qdata(gilen+1:fftlen2,:);

%******************** end of file ***************************