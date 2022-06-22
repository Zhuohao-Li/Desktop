
% bpskmod.m

function [iout,qout]=bpskmod(paradata,para,nd,ml)

%****************** variables *************************
% paradata : input data (para-by-nd matrix)
% iout :output Ich data
% qout :output Qch data
% para   : Number of paralell channels
% nd : Number of data
% ml : Number of modulation levels
% (BPSK -> 1 QPSK ->2  16-QAM -> 4  64-QAM ->6)
% *****************************************************

iout=paradata.*2-1;
qout=iout.*0;

%******************** end of file ***************************
