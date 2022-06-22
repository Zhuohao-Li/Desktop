
% qpskmod.m
%
% Function to perform QPSK modulation
%
% Programmed by H.Harada
%

function [iout,qout]=qpskmod(paradata,nd)

%****************** variables *************************
% paradata : input data (para-by-nd matrix)
% iout :output Ich data
% qout :output Qch data
% para   : Number of paralell channels
% nd : Number of data
% ml : Number of modulation levels
% (QPSK ->2  16QAM -> 4)
% *****************************************************

iout=zeros(1,nd);
qout=zeros(1,nd);

for i=1:1:nd
    iout(1,i)=2*paradata(1,i*2-1)-1;
    qout(1,i)=2*paradata(1,i*2)-1;
end

%******************** end of file ***************************
