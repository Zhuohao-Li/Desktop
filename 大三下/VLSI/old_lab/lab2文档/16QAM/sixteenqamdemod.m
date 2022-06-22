% 16qamdemod.m
% Function to perform QPSK demodulation

function [demodata]=sixteenqamdemod(idata,qdata,para,nd,ml)

%****************** variables *************************
% idata :input Ich data
% qdata :input Qch data
% demodata: demodulated data (para-by-nd matrix)
% para   : Number of paralell channels
% nd : Number of data
% ml : Number of modulation levels
% (QPSK ->2  16QAM -> 4)
% *****************************************************

demodata=zeros(para,ml*nd);%ת���ɶ�����
%���¾�Ϊ�߼���ֵ
%demodata((1:para),(1:ml:ml*nd))=(idata((1:para),(1:nd))>=0;
%demodata((1:para),(2:ml:ml*nd))=qdata((1:para),(1:nd))>=0;
%count1=zeros(para,1);
%count2=zeros(para,2);
count=1;
m2=ml/2-1;

for ii=1:nd
    count1=idata((1:para),ii);    %��ȡi·��ֵ
    count2=qdata((1:para),ii);    %��ȡq·��ֵ
    
    if((count1>2))
            demodata((1:para),count)=1;
            demodata((1:para),count+m2)=0;
    else
        if((count1>0)&&(count1<2))
            demodata((1:para),count)=1;
            demodata((1:para),count+m2)=1;
        else
            if((count1>-2)&&(count1<0))
            demodata((1:para),count)=0;
            demodata((1:para),count+m2)=1;
            else
                %if((count1>-4)&&(count1<-2))
                demodata((1:para),count)=0;
                demodata((1:para),count+m2)=0;
                %end
            end
        end
    end
         
    if((count2>2))
        demodata((1:para),count+m2+1)=1;
        demodata((1:para),count+ml-1)=0;
    else
        if((count2>0)&&(count2<2))
            demodata((1:para),count+m2+1)=1;
            demodata((1:para),count+ml-1)=1;
        else
            if((count2>-2)&&(count2<0))
              demodata((1:para),count+m2+1)=0;
              demodata((1:para),count+ml-1)=1;
            else
                %if((count2>-4)&&(count2<-2))
                  demodata((1:para),count+m2+1)=0;
                  demodata((1:para),count+ml-1)=0;
                %end
            end
        end
    end
    count=count+ml;%�������ȥ��mlλ
    
end
%******************** end of file ***************************
