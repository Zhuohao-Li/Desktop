
function [iout,qout]=ofdmdemap(idata,qdata)

%****************** variables *************************
% idata     : Input Ich data
% qdata     : Input Qch data
% iout      : Output Ich data
% qout      : Output Qch data
% fftlen    : Length of FFT (points)
% nd        : Number of OFDM symbols
% *****************************************************

iout(1:5,:)=idata(39:43,:);
iout(6:18,:)=idata(45:57,:);
iout(19:24,:)=idata(59:64,:);
iout(25:30,:)=idata(2:7,:);
iout(31:43,:)=idata(9:21,:);
iout(44:48,:)=idata(23:27,:);

qout(1:5,:)=qdata(39:43,:);
qout(6:18,:)=qdata(45:57,:);
qout(19:24,:)=qdata(59:64,:);
qout(25:30,:)=qdata(2:7,:);
qout(31:43,:)=qdata(9:21,:);
qout(44:48,:)=qdata(23:27,:);

%******************** end of file ***************************