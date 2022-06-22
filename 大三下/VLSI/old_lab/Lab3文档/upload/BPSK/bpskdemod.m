% bpskdemod.m
%
% Function to perform BPSK demodulation
%
%

function [demodata]=bpskdemod(idata,qdata,para,nd,ml)

%****************** variables *************************
% idata :input Ich data
% qdata :input Qch data
% demodata: demodulated data (para-by-nd matrix)
% para   : Number of paralell channels
% nd : Number of data
% ml : Number of modulation levels
% (BPSK -> 1 QPSK ->2  16-QAM -> 4  64-QAM ->6)
% *****************************************************

demodata=zeros(para,ml*nd);

isi=zeros(para,1);
qsi=zeros(para,1);
count=1;

for ii=1:nd
    for jj=1:para
        %i·�ź�
        if(idata(jj,ii)>=0)
            isi(jj,1)=1;
        else
            isi(jj,1)=0;
        end
    end
    demodata((1:para),count)=isi((1:para),1);
    
    count=count+ml;
end 
%demodata((1:para),(1:ml*nd))=idata((1:para),(1:ml*nd))>=0; 

%******************** end of file ***************************
