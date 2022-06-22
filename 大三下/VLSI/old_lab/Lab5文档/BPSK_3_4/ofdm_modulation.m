function [iout,qout]=ofdm_modulation(idatain,qdatain)

leth=length(idatain);
n=leth/48;
iout=zeros(80,n);
qout=zeros(80,n);

data=idatain+qdatain*j;

%% serial to parallel
tmp1=reshape(data,48,n);
tmp2=zeros(64,n);

%% ofdm mapping
tmp2(2:7,1:n)=tmp1(25:30,1:n);
tmp2(9:21,1:n)=tmp1(31:43,1:n);
tmp2(23:27,1:n)=tmp1(44:48,1:n);
tmp2(39:43,1:n)=tmp1(1:5,1:n);
tmp2(45:57,1:n)=tmp1(6:18,1:n);
tmp2(59:64,1:n)=tmp1(19:24,1:n);

%% ifft
tmp3=ifft(tmp2,64);
iout(17:80,1:n)=real(tmp3);
qout(17:80,1:n)=imag(tmp3);

%% add cp
iout(1:16,1:n)=iout(65:80,1:n);
qout(1:16,1:n)=qout(65:80,1:n);

%% parallel to serial
iout=reshape(iout,1,80*n);
qout=reshape(qout,1,80*n);

end