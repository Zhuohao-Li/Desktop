function [iout,qout]=ofdm_demodulation(idatain,qdatain)

leth=length(idatain);
n=leth/80;

iout=zeros(48,n);
qout=zeros(48,n);
data=idatain+qdatain*j;

%% serial to parallel
data=reshape(data,80,n);

%% remove cp
data=data(17:80,1:n);

%% fft
tmp1=fft(data,64);

%% ofdm_demapping
tmp2(25:30,1:n)=tmp1(2:7,1:n);
tmp2(31:43,1:n)=tmp1(9:21,1:n);
tmp2(44:48,1:n)=tmp1(23:27,1:n);
tmp2(1:5,1:n)=tmp1(39:43,1:n);
tmp2(6:18,1:n)=tmp1(45:57,1:n);
tmp2(19:24,1:n)=tmp1(59:64,1:n);

iout=real(tmp2);
qout=imag(tmp2);

%% parallel to serial
iout=reshape(iout,1,48*n);
qout=reshape(qout,1,48*n);

end