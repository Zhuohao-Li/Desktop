function output=deinterleave(input,ml);

%****************** variables ************************* 
% *****************************************************

n=length(input);
block=48*ml;
loop=n/block;
output=zeros(1,n);

tmp1=zeros(1,block);
tmp2=zeros(1,block);

for ii=1:1:loop
    s=max(1,ml/2);
    tmp1(s*floor((0:block-1)/s)+mod((0:block-1)+floor(16*(0:block-1)/block),s)+1)=input(block*ii-block+1:block*ii);
    tmp2(16*(0:block-1)-(block-1)*floor(16*(0:block-1)/block)+1)=tmp1(1:block);
    output(block*ii-block+1:block*ii)=tmp2;
end

end

%******************** end of file ***************************