
% qam16mod.m
 
function [iout,qout]=qam16mod(paradata,para,nd,ml)
 
%****************** variables *************************
% paradata : input data (para-by-nd matrix)
% iout :output Ich data
% qout :output Qch data
% para   : Number of paralell channels
% nd : Number of data
% ml : Number of modulation levels
% (BPSK -> 1 QPSK ->2  16-QAM -> 4  64-QAM ->6)
% *****************************************************

m2=ml./2; %2
count=1; 

iout=zeros(para,nd);  
qout=zeros(para,nd);

isi=zeros(para,1);
qsi=zeros(para,1);

for ii=1:nd
    for jj=1:para
        if((paradata(jj,count)==0)&&(paradata(jj,count+m2-1)==0))
            isi(jj,1)=-3;
        elseif((paradata(jj,count)==0)&&(paradata(jj,count+m2-1)==1))
            isi(jj,1)=-1;
        elseif((paradata(jj,count)==1)&&(paradata(jj,count+m2-1)==1))
            isi(jj,1)=1;
        else
            isi(jj,1)=3;
        end
        
        if((paradata(jj,count+m2)==0)&&(paradata(jj,count+ml-1)==0))
            qsi(jj,1)=-3;
        elseif((paradata(jj,count+m2)==0)&&(paradata(jj,count+ml-1)==1))
            qsi(jj,1)=-1;
        elseif((paradata(jj,count+m2)==1)&&(paradata(jj,count+ml-1)==1))
            qsi(jj,1)=1;
        else
            qsi(jj,1)=3;
        end
    end
    
    iout((1:para),ii)=isi((1:para),1);
    qout((1:para),ii)=qsi((1:para),1);
    count=count+ml;
end
 
%******************** end of file ***************************


