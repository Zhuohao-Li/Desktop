if (TxRx.Code.Rate == 1/2) % no puncturing
       info_bits_hat1 = vitdec(rx_bits, TxRx.Code.trellis, TxRx.Code.tblen, 'term', 'hard');
else % punturing is required
       info_bits_hat1 = vitdec(rx_bits, TxRx.Code.trellis, TxRx.Code.tblen, 'term', 'hard', TxRx.Code.Puncturing.Pattern);
end
info_bits_hat1 = logical(info_bits_hat1);
puncturing_pattern = [1 1 1 0];
info_bits_hat3 = Hard_Viterbi_wqx(rx_bits,TxRx.Code.trellis.nextStates,TxRx.Code.trellis.outputs,2160,puncturing_pattern);
error = sum(info_bits_hat1~=info_bits_hat3)



count = 1;
info_bits_hat2 = zeros(1,2160);
windows = ones(2160,64)*(-1);
windwos_copy = ones(2160,64)*(-1);
F = ones(1,64).*(-1);
F(1,1) = 0;
next = TxRx.Code.trellis.nextStates;
out = TxRx.Code.trellis.outputs;
for l = 1:2160
    transfer = ones(64,64).*(2000);
    input = ones(64,64).*(-1);
    for x = 1:64
        if(F(1,x)>=0)
            nextstate0 = next(x,1);
            nextstate1 = next(x,2);
            output0 = out(x,1);
            output1 = out(x,2);
            switch(output0)
                case(0)
                    if(mod(l,3)==2)
                        transfer(x,nextstate0+1) = ~(rx_bits(l*2-fix(l/3)-fix(l/3)-1)==0) + F(1,x); 
                        input(x,nextstate0+1) = 0;
                    elseif(mod(l,3)==0)
                        transfer(x,nextstate0+1) = ~(rx_bits(l*2-fix(l/3)-fix(l/3))==0) + F(1,x); 
                        input(x,nextstate0+1) = 0;
                    else
                        transfer(x,nextstate0+1) = ~(rx_bits(l*2-1-fix(l/3)-fix(l/3))==0) +  ~(rx_bits(l*2-fix(l/3)-fix(l/3))==0) + F(1,x); 
                        input(x,nextstate0+1) = 0;
                    end
                case(1)
                    if(mod(l,3)==2)
                        transfer(x,nextstate0+1) = ~(rx_bits(l*2-fix(l/3)-fix(l/3)-1)==0) + F(1,x);  
                        input(x,nextstate0+1) = 0;
                    elseif(mod(l,3)==0)
                        transfer(x,nextstate0+1) = ~(rx_bits(l*2-fix(l/3)-fix(l/3))==1)+ F(1,x);  
                        input(x,nextstate0+1) = 0;
                    else
                        transfer(x,nextstate0+1) = ~(rx_bits(l*2-1-fix(l/3)-fix(l/3))==0)+ ~(rx_bits(l*2-fix(l/3)-fix(l/3))==1)+ F(1,x);  
                        input(x,nextstate0+1) = 0;
                    end
                case(2)
                    if(mod(l,3)==2)
                        transfer(x,nextstate0+1) = ~(rx_bits(l*2-fix(l/3)-fix(l/3)-1)==1)+ F(1,x); 
                        input(x,nextstate0+1) = 0;
                    elseif(mod(l,3)==0)
                        transfer(x,nextstate0+1) =  ~(rx_bits(l*2-fix(l/3)-fix(l/3))==0)+ F(1,x); 
                        input(x,nextstate0+1) = 0;
                    else
                        transfer(x,nextstate0+1) = ~(rx_bits(l*2-1-fix(l/3)-fix(l/3))==1)+ ~(rx_bits(l*2-fix(l/3)-fix(l/3))==0)+ F(1,x); 
                        input(x,nextstate0+1) = 0;
                    end
                case(3)
                    if(mod(l,3)==2)
                        transfer(x,nextstate0+1) = ~(rx_bits(l*2-fix(l/3)-fix(l/3)-1)==1)+ F(1,x); 
                        input(x,nextstate0+1) = 0;
                    elseif(mod(l,3)==0)
                        transfer(x,nextstate0+1) =  ~(rx_bits(l*2-fix(l/3)-fix(l/3))==1)+ F(1,x); 
                        input(x,nextstate0+1) = 0;
                    else
                        transfer(x,nextstate0+1) = ~(rx_bits(l*2-1-fix(l/3)-fix(l/3))==1)+ ~(rx_bits(l*2-fix(l/3)-fix(l/3))==1)+ F(1,x); 
                        input(x,nextstate0+1) = 0;
                    end
                otherwise
                    transfer(x,nextstate0+1) = -1; 
            end
            if(l<2155)
                switch(output1)
                    case(0)
                        if(mod(l,3)==2)
                            transfer(x,nextstate1+1) = ~(rx_bits(l*2-fix(l/3)-fix(l/3)-1)==0) + F(1,x); 
                            input(x,nextstate1+1) = 1;
                        elseif(mod(l,3)==0)
                            transfer(x,nextstate1+1) =  ~(rx_bits(l*2-fix(l/3)-fix(l/3))==0)+ F(1,x); 
                            input(x,nextstate1+1) = 1;
                        else
                            transfer(x,nextstate1+1) = ~(rx_bits(l*2-1-fix(l/3)-fix(l/3))==0)+ ~(rx_bits(l*2-fix(l/3)-fix(l/3))==0)+ F(1,x); 
                            input(x,nextstate1+1) = 1;
                        end
                    case(1)
                        if(mod(l,3)==2)
                            transfer(x,nextstate1+1) = ~(rx_bits(l*2-fix(l/3)-fix(l/3)-1)==0)+ F(1,x); 
                            input(x,nextstate1+1) = 1;  
                        elseif(mod(l,3)==0)
                            transfer(x,nextstate1+1) =  ~(rx_bits(l*2-fix(l/3)-fix(l/3))==1)+ F(1,x); 
                            input(x,nextstate1+1) = 1;
                        else
                            transfer(x,nextstate1+1) = ~(rx_bits(l*2-1-fix(l/3)-fix(l/3))==0)+ ~(rx_bits(l*2-fix(l/3)-fix(l/3))==1)+ F(1,x); 
                            input(x,nextstate1+1) = 1;
                        end
                    case(2)
                        if(mod(l,3)==2)
                            transfer(x,nextstate1+1) = ~(rx_bits(l*2-fix(l/3)-fix(l/3)-1)==1)+ F(1,x); 
                            input(x,nextstate1+1) = 1;
                        elseif(mod(l,3)==0)
                            transfer(x,nextstate1+1) =  ~(rx_bits(l*2-fix(l/3)-fix(l/3))==0)+ F(1,x); 
                            input(x,nextstate1+1) = 1;
                        else
                            transfer(x,nextstate1+1) = ~(rx_bits(l*2-1-fix(l/3)-fix(l/3))==1)+ ~(rx_bits(l*2-fix(l/3)-fix(l/3))==0)+ F(1,x); 
                            input(x,nextstate1+1) = 1;
                        end
                    case(3)
                        if(mod(l,3)==2)
                            transfer(x,nextstate1+1) = ~(rx_bits(l*2-fix(l/3)-fix(l/3)-1)==1) + F(1,x); 
                            input(x,nextstate1+1) = 1;
                        elseif(mod(l,3)==0)
                            transfer(x,nextstate1+1) =  ~(rx_bits(l*2-fix(l/3)-fix(l/3))==1)+ F(1,x); 
                            input(x,nextstate1+1) = 1;
                        else
                            transfer(x,nextstate1+1) = ~(rx_bits(l*2-1-fix(l/3)-fix(l/3))==1)+ ~(rx_bits(l*2-fix(l/3)-fix(l/3))==1)+ F(1,x); 
                            input(x,nextstate1+1) = 1;
                        end
                    otherwise
                        transfer(x,nextstate1+1) = -1; 
                end
            end
        end
    end
    windows_copy = windows;
    for x = 1:64
        q = 1000;
        b = -1;
        state = -1;
        y = find(transfer(:,x)~=2000);
        if(length(y)==1)
            q = transfer(y(1,1),x);
            b = input(y(1,1),x);
            state = y(1,1);
        elseif(length(y)==2)
            t1 = transfer(y(1,1),x);
            t2 = transfer(y(2,1),x);
            if(t1>t2) 
                q=t2;b=input(y(2,1),x);state = y(2,1);
            else
                q=t1;b=input(y(1,1),x);state = y(1,1);
            end
        end
        if(state>0)
            if(l==1)
                windows(l,x) = b;
            else
                windows(l,x) = b;
                windows(1:l-1,x) = windows_copy(1:l-1,state);                 
            end
        end
        if(q<1000)
            F(1,x)=q;
        end
    end
end
 info_bits_hat2(1,:) = windows(:,1)';
 info_bits_hat2 = info_bits_hat2';