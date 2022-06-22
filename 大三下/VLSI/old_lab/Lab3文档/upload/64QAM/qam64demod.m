% qam64demod.m
% Function to perform 64-QAM demodulation

function [demodata]=qam64demod(idata,qdata,para,nd,ml)

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

bitcount=ml/2; % =3
count=1;

for ii=1:nd
    for jj=1:para
    %*********************************************************************
        if(idata(jj,ii)<-6)
            demodata(jj,count:count+bitcount-1)=[0,0,0];
        elseif((idata(jj,ii)>=-6)&&(idata(jj,ii)<-4))
            demodata(jj,count:count+bitcount-1)=[0,0,1];
        elseif((idata(jj,ii)>=-4)&&(idata(jj,ii)<-2))
            demodata(jj,count:count+bitcount-1)=[0,1,1];
        elseif((idata(jj,ii)>=-2)&&(idata(jj,ii)<0))
            demodata(jj,count:count+bitcount-1)=[0,1,0];
        elseif((idata(jj,ii)>=0)&&(idata(jj,ii)<2))
            demodata(jj,count:count+bitcount-1)=[1,1,0];
        elseif((idata(jj,ii)>=2)&&(idata(jj,ii)<4))
            demodata(jj,count:count+bitcount-1)=[1,1,1];
        elseif((idata(jj,ii)>=4)&&(idata(jj,ii)<6))
            demodata(jj,count:count+bitcount-1)=[1,0,1];
        else
            demodata(jj,count:count+bitcount-1)=[1,0,0];
        end
        
        if(qdata(jj,ii)<-6)
            demodata(jj,count+bitcount:count+ml-1)=[0,0,0];
        elseif((qdata(jj,ii)>=-6)&&(qdata(jj,ii)<-4))
            demodata(jj,count+bitcount:count+ml-1)=[0,0,1];
        elseif((qdata(jj,ii)>=-4)&&(qdata(jj,ii)<-2))
            demodata(jj,count+bitcount:count+ml-1)=[0,1,1];
        elseif((qdata(jj,ii)>=-2)&&(qdata(jj,ii)<0))
            demodata(jj,count+bitcount:count+ml-1)=[0,1,0];
        elseif((qdata(jj,ii)>=0)&&(qdata(jj,ii)<2))
            demodata(jj,count+bitcount:count+ml-1)=[1,1,0];
        elseif((qdata(jj,ii)>=2)&&(qdata(jj,ii)<4))
            demodata(jj,count+bitcount:count+ml-1)=[1,1,1];
        elseif((qdata(jj,ii)>=4)&&(qdata(jj,ii)<6))
            demodata(jj,count+bitcount:count+ml-1)=[1,0,1];
        else
            demodata(jj,count+bitcount:count+ml-1)=[1,0,0];
        end
    end
    count=count+ml;
end
%******************** end of file ***************************
