
function [iout,qout]=ofdmmap(idata,qdata,fftlen,nd)

%****************** variables *************************
% idata     : Input Ich data
% qdata     : Input Qch data
% iout      : Output Ich data
% qout      : Output Qch data
% fftlen    : Length of FFT (points)
% nd        : Number of OFDM symbols
% *****************************************************
iout=zeros(fftlen,nd);
qout=zeros(fftlen,nd);

iout(2:7,:)=idata(25:30,:);
iout(9:21,:)=idata(31:43,:);
iout(23:27,:)=idata(44:48,:);
iout(39:43,:)=idata(1:5,:);
iout(45:57,:)=idata(6:18,:);
iout(59:64,:)=idata(19:24,:);

qout(2:7,:)=qdata(25:30,:);
qout(9:21,:)=qdata(31:43,:);
qout(23:27,:)=qdata(44:48,:);
qout(39:43,:)=qdata(1:5,:);
qout(45:57,:)=qdata(6:18,:);
qout(59:64,:)=idata(19:24,:);

%******************** end of file ***************************
