
% qpskdemod.m
%
% Function to perform QPSK demodulation
%
% programmed by H.Harada
%

function [demodata]=qpskdemod(idata,qdata,nd)

%****************** variables *************************
% idata :input Ich data
% qdata :input Qch data
% demodata: demodulated data (para-by-nd matrix)
% para   : Number of paralell channels
% nd : Number of data
% ml : Number of modulation levels
% (QPSK ->2  16QAM -> 4)
% *****************************************************

demodata=zeros(1,2*nd);

for i=1:1:nd
    demodata(1,i*2-1)=idata(1,i)>0;
    demodata(1,i*2)=qdata(1,i)>0;
end

%******************** end of file ***************************
