
% qpskmod.m
% Function to perform QPSK modulation

function [iout,qout]=bpskmod(paradata,~,~,~)

%****************** variables *************************
% paradata : input data (para-by-nd matrix)
% iout :output Ich data
% qout :output Qch data
% para   : Number of paralell channels
% nd : Number of data
% ml : Number of modulation levels
% (QPSK ->2  16QAM -> 4)
% *****************************************************

%m2=m1;

iout=paradata.*2-1;
qout=iout.*0;

%******************** end of file ***************************
