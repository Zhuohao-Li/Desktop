function output=depuncture(input,r)

%****************** variables *************************
% r: coding ratio
% *****************************************************

n=length(input);

switch r
    case 1/2
        %output=ones(1,n)/2;
        output=input;
    case 3/4
        output=ones(1,n*3/2);
        output=output*2.0;
        output(1:6:n*3/2-5)=input(1:4:n-3);
        output(2:6:n*3/2-4)=input(2:4:n-2);
        output(3:6:n*3/2-3)=input(3:4:n-1);
        output(6:6:n*3/2)=input(4:4:n);
    case 2/3
        output=ones(1,n*4/3);
        output=output*2.0;
        output(1:4:n*4/3-3)=input(1:3:n-2);
        output(2:4:n*4/3-2)=input(2:3:n-1);
        output(3:4:n*4/3-1)=input(3:3:n);
end

end

%******************** end of file ***************************