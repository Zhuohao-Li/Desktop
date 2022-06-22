% sixteenqam.m

%******************** Preparation part *************************************
clear;
sr=256000;  % Symbol rate
ml=6;            % ml:Number of modulation levels (BPSK:ml=1, QPSK:ml=2, 16QAM:ml=4,64QAM:ml=6)
br=sr .* ml;   % Bit rate
nd = 1000;   % Number of symbols that simulates in each loop
ebn0=6;       % Eb/N0
IPOINT=8;    % Number of oversamples

%************************* Filter initialization ***************************

irfn=21;                   % Number of taps
alfs=0.5;                  % Rolloff factor
[xh] = hrollfcoef(irfn,IPOINT,sr,alfs,1);   %Transmitter Pulse Shape Filter coefficients
[xh2] = hrollfcoef(irfn,IPOINT,sr,alfs,0);  %Receiver Match Filter coefficients

%******************** START CALCULATION *************************************

nloop=100;     % Number of simulation loops
noe = 0;       % Number of error data
nod = 0;       % Number of transmitted data

tic;
for iii=1:nloop
        
        %*************************** Data generation ********************************
        
        data1=rand(1,nd*ml)>0.5;  % rand: built in function
        
        %*************************** QPSK Modulation ********************************
        
        [ich,qch]=qam64mod(data1,1,nd,ml);
        
        %*************************** Up sample ********************************
        
        [ich1,qch1]= compoversamp(ich,qch,length(ich),IPOINT);
        
        %*************************** Pulse shaping filter ********************************
        
        [ich2,qch2]= compconv(ich1,qch1,xh);
        
        %**************************** Attenuation Calculation ***********************
        
        spow=sum(ich2.*ich2+qch2.*qch2)/nd;  % sum: built in function
        attn=0.5*spow*sr/br*10.^(-ebn0/10);
        attn=sqrt(attn);  % sqrt: built in function
              
        %********************* Add White Gaussian Noise (AWGN) **********************
        
        [ich3,qch3]= comb(ich2,qch2,attn);% add white gaussian noise
         
        %*************************** Match filter ********************************
        
        [ich4,qch4]= compconv(ich3,qch3,xh2);
        
        %*************************** Synchronization and Down sample ********************************
      
        syncpoint=irfn*IPOINT;
        ich5=ich4(syncpoint:IPOINT:length(ich4));
        qch5=qch4(syncpoint:IPOINT:length(qch4));
        
        %**************************** QPSK Demodulation *****************************
        
        [demodata]=qam64demod(ich5,qch5,1,nd,ml);
        
        %************************** Bit Error Rate (BER) ****************************
        
        noe2=sum(abs(data1-demodata));  % sum: built in function
        nod2=length(data1);  % length: built in function
        noe=noe+noe2;
        nod=nod+nod2;
                
end % for iii=1:nloop

%********************** Output result ***************************

ber=noe/nod;
disp(['frame=',num2str(nloop)]);
disp(['BER=',num2str(ber)]);
toc;
qam64_ber;
% fprintf('%d\t%d\t%d\t%e\n',ebn0,noe,nod,noe/nod);  % fprintf: built in function
% fid = fopen('BERqpsk.dat','a');
% fprintf(fid,'%d\t%e\t%f\t%f\t\n',ebn0,noe/nod,noe,nod);  % fprintf: built in function
% fclose(fid);

%******************** end of file ***************************

