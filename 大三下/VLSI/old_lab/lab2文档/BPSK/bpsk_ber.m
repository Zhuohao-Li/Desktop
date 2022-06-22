% qpsk_ber.m
% Simulation program to realize QPSK transmission system

%******************** Preparation part *************************************
clc; clear
sr=256000.0; % Symbol rate
ml=1;        % ml:Number of modulation levels (BPSK:ml=1, QPSK:ml=2, 16QAM:ml=4)
br=sr .* ml; % Bit rate
nd = 1000;   % Number of symbols that simulates in each loop
ebn0=0:8;      % Eb/N0
ber = zeros(1,length(ebn0)); %ber
IPOINT=8;    % Number of oversamples

%************************* Filter initialization ***************************

irfn=21;                  % Number of taps
alfs=0.5;                 % Rolloff factor
[xh] = hrollfcoef(irfn,IPOINT,sr,alfs,1);   %Transmitter Pulse Shape Filter coefficients
[xh2] = hrollfcoef(irfn,IPOINT,sr,alfs,0);  %Receiver Match Filter coefficients

%******************** START CALCULATION *************************************

nloop=100;  % Number of simulation loops


tic;
for cnt = 1:length(ebn0)
    disp(ebn0(cnt));
    noe = 0;    % Number of error data
    nod = 0;    % Number of transmitted data
    for iii=1:nloop
    
    %*************************** Data generation ********************************  

        data1=rand(1,nd*ml)>0.5;  % rand: built in function

    %*************************** BPSK Modulation ********************************  

        [ich,qch]=bpskmod(data1,1,nd,ml);
        
        %*************************** Up sample ********************************
        
        [ich1,qch1]= compoversamp(ich,qch,length(ich),IPOINT); 
         
        %*************************** Pulse shaping filter ********************************
        
        [ich2,qch2]= compconv(ich1,qch1,xh); 

    %**************************** Attenuation Calculation ***********************

        spow=sum(ich2.*ich2+qch2.*qch2)/nd;  % sum: built in function
        attn=0.5*spow*sr/br*10.^(-ebn0(cnt)/10);
        attn=sqrt(attn);  % sqrt: built in function

    %********************* Add White Gaussian Noise (AWGN) **********************

        [ich3,qch3]= comb(ich2,qch2,attn);% add white gaussian noise
        [ich4,qch4]= compconv(ich3,qch3,xh2);

       %*************************** Synchronization and Down sample ********************************
        
        syncpoint=irfn*IPOINT;
        ich5=ich4(syncpoint:IPOINT:length(ich4));
        qch5=qch4(syncpoint:IPOINT:length(qch4));

    %**************************** BPSK Demodulation *****************************

        [demodata]=bpskdemod(ich5,qch5,1,nd,ml);

    %************************** Bit Error Rate (BER) ****************************

        noe2=sum(abs(data1-demodata));  % sum: built in function
        nod2=length(data1);  % length: built in function
        noe=noe+noe2;
        nod=nod+nod2;

        %fprintf('%d\t%e\n',iii,noe2/nod2);  % fprintf: built in function
        
    end % for iii=1:nloop   
    ber(cnt) = noe/nod;
end
toc;
disp(['BER=  ',num2str(ber)]);
%********************** Output result ***************************
 load('ber_theory.mat');
 semilogy(ebn0,ber,'--g^',ebn0_theory,ber_theory,'--ro');
 xlabel('Eb/N0');
 ylabel('BER');
 title('BPSK System');
 legend('BPSK Simulation','BPSK Theory');
 grid on
%******************** end of file ***************************

