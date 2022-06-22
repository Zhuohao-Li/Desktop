
clear; clc;
%% parameter setting
sr=256000.0; % Symbol rate
ml=4;               % ml:Number of modulation levels (BPSK:ml=1, QPSK:ml=2, 16QAM:ml=4)
br=sr .* ml;      % Bit rate
rate=2/3;         % coding rate
ebn0=0:12;       % Eb/N0
ber = zeros(1,length(ebn0));  %ber
g1=[1 0 1 1 0 1 1];  % g1  133
g2=[1 1 1 1 0 0 1];  % g2  171
data_length=1000;

%% start simulation
nloop=10000;  % Number of simulation loops
for cnt = 1:length(ebn0)
        tic;
        disp(ebn0(cnt));
        noe = 0;    % Number of error data
        nod = 0;    % Number of transmitted data
        for iii=1:nloop               
              %% data generation
                data=rand(1,data_length*8)>0.5;
                
              %%  data frame generation                
                data_frame=frame_gen(rate, ml, data);
                        
              %% channel coding
                trellis=poly2trellis(7,[133,171]);
                data2=convenc(data_frame,trellis);
                
              %% puncture
                data3=puncture(data2,rate); 
                
              %% interleave
                data4=interleave(data3,ml);
                
              %% modulation
                [ich1,qch1]=sixteenqammod(data4,1,length(data4)/ml,ml);
                
              %% ofdm_demodulation  
                [ich2,qch2]=ofdm_modulation(ich1,qch1);
                
              %% noise calculation                
                spow=sum(ich2.*ich2+qch2.*qch2)/(8*data_length/ml);  % sum: built in function
                attn=0.5*spow/ml*10.^(-ebn0(cnt)/10);
                attn=sqrt(attn);  % sqrt: built in function
                
              %% AWGN
                [ich3,qch3]=comb(ich2,qch2,attn);% add white gaussian noise
                
              %% ofdm_demodulation              
                [ich4,qch4]=ofdm_demodulation(ich3,qch3);
                
              %% demodulation  
                data5=sixteenqamdemod(ich4,qch4,1,length(ich4),ml);
                
              %% deinterleave  
                data6=deinterleave(data5,ml);
                
              %% depuncture  
                data7=depuncture(data6,rate); % 
                puncpat=~(data7==0.5);
              
              %% channel decoding  
                demodata_frame=vitdec(data6,trellis,30,'term','hard',puncpat);
                demodata=demodata_frame(1,17:16+data_length*8);
                
              %% ber                
                noe2=sum(abs(data-demodata));  % sum: built in function
                nod2=length(data);  % length: built in function
                noe=noe+noe2;
                nod=nod+nod2;               
        end % for iii=1:nloop
        ber(cnt) = noe/nod;
        disp(ber(cnt));
        toc;
end
%********************** Output result ***************************
%load('ebn0_theory.mat');
%load('ber0_theory.mat');
semilogy(ebn0,ber,'--b^');
xlabel('Eb/N0');
ylabel('BER');
title('16QAM Rate=2/3 System');
legend('16QAM Simulation');
grid on
%******************** end of file ***************************
