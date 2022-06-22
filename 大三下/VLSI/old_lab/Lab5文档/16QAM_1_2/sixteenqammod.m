
% sixteenqamdemod.m
% Function to perform QPSK modulation
 
function [iout,qout]=sixteenqammod(paradata,para,nd,ml)
 
%****************** variables *************************
% paradata : input data (para-by-nd matrix)
% iout :output Ich data
% qout :output Qch data
% para   : Number of paralell channels
% nd : Number of data
% ml : Number of modulation levels
% (QPSK ->2  16QAM -> 4)
% *****************************************************
 
m2=ml/2;
 
%paradata2=paradata.*2-1;
count=0;
iout=zeros(para,nd);
qout=zeros(para,nd);

for jj=1:nd
 
    ich = zeros(para,1);
    qch = zeros(para,1);
    
    for ii = 1 : m2 
        ich = ich+ 2.^( m2 - ii ) .* paradata((1:para),ii+count);  
        qch = qch+ 2.^( m2 - ii ) .* paradata((1:para),m2+ii+count);
    end
    
    switch ich
        case 0
            isi=-3;
        case 1
            isi=-1;
        case 2
            isi=3;
        case 3
            isi=1;
        otherwise 
            break;
    end
            
    switch qch
        case 0
           qsi=-3;
        case 1
           qsi=-1;
        case 2
           qsi=3;
        case 3
           qsi=1;
        otherwise 
            break;
    end
    
    iout((1:para),jj)=isi;
    qout((1:para),jj)=qsi;
 
    count=count+ml;
end
 
%******************** end of file ***************************


