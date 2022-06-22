function output=puncture(input,r)

%****************** variables *************************
% r: coding ratio
% *****************************************************

n=length(input);

switch r
    case 1/2
        output=zeros(1,n);
        output=input;
    case 3/4
        output=zeros(1,n*2/3);
        output(1:4:n*2/3-3)=input(1:6:n-5);
        output(2:4:n*2/3-2)=input(2:6:n-4);
        output(3:4:n*2/3-1)=input(3:6:n-3);
        output(4:4:n*2/3)=input(6:6:n);
    case 2/3
        output=zeros(1,n*3/4);
        output(1:3:n*3/4-2)=input(1:4:n-3);
        output(2:3:n*3/4-1)=input(2:4:n-2);
        output(3:3:n*3/4)=input(3:4:n-1);
end

end

%******************** end of file ***************************