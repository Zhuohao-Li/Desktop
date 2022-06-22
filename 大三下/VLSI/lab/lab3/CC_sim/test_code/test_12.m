if (TxRx.Code.Rate == 1/2) % no puncturing
       info_bits_hat1 = vitdec(rx_bits, TxRx.Code.trellis, TxRx.Code.tblen, 'term', 'hard');
else % punturing is required
       info_bits_hat1 = vitdec(rx_bits, TxRx.Code.trellis, TxRx.Code.tblen, 'term', 'hard', TxRx.Code.Puncturing.Pattern);
end
info_bits_hat1 = logical(info_bits_hat1);
info_bits_hat3 = Hard_Viterbi_wqx(rx_bits,TxRx.Code.trellis.nextStates,TxRx.Code.trellis.outputs,2160,[1 0]);

error = sum(info_bits_hat1~=info_bits_hat3)



info_bits_hat2 = zeros(1,2160);
windows = ones(2160,64)*(-1);
windwos_copy = ones(2160,64)*(-1);
F = ones(1,64).*(-1);
F(1,1) = 0;
next = TxRx.Code.trellis.nextStates;
out = TxRx.Code.trellis.outputs;
for l = 1:2160
    transfer = ones(64,64).*(100000);
    input = ones(64,64).*(-1);
    for x = 1:64
        if(F(1,x)>=0)
            nextstate0 = next(x,1);
            nextstate1 = next(x,2);
            output0 = out(x,1);
            output1 = out(x,2);
            switch(output0)
                case(0)
                    transfer(x,nextstate0+1) = ~(rx_bits(l*2-1)==0) + ~(rx_bits(l*2)==0) + F(1,x); 
                    input(x,nextstate0+1) = 0;
                case(1)
                    transfer(x,nextstate0+1) = ~(rx_bits(l*2-1)==0)+ ~(rx_bits(l*2)==1)+ F(1,x);  
                    input(x,nextstate0+1) = 0;
                case(2)
                    transfer(x,nextstate0+1) = ~(rx_bits(l*2-1)==1)+ ~(rx_bits(l*2)==0)+ F(1,x); 
                    input(x,nextstate0+1) = 0;
                case(3)
                    transfer(x,nextstate0+1) = ~(rx_bits(l*2-1)==1)+ ~(rx_bits(l*2)==1)+ F(1,x); 
                    input(x,nextstate0+1) = 0;
                otherwise
                    transfer(x,nextstate0+1) = 100000; 
            end
            if(l<2155)
                switch(output1)
                    case(0)
                        transfer(x,nextstate1+1) = ~(rx_bits(l*2-1)==0)+ ~(rx_bits(l*2)==0)+ F(1,x); 
                        input(x,nextstate1+1) = 1;
                    case(1)
                        transfer(x,nextstate1+1) = ~(rx_bits(l*2-1)==0)+ ~(rx_bits(l*2)==1)+ F(1,x); 
                        input(x,nextstate1+1) = 1;
                    case(2)
                        transfer(x,nextstate1+1) = ~(rx_bits(l*2-1)==1)+ ~(rx_bits(l*2)==0)+ F(1,x); 
                        input(x,nextstate1+1) = 1;
                    case(3)
                        transfer(x,nextstate1+1) = ~(rx_bits(l*2-1)==1)+ ~(rx_bits(l*2)==1)+ F(1,x); 
                        input(x,nextstate1+1) = 1;
                    otherwise
                        transfer(x,nextstate1+1) =100000;               
                end
            end
        end
    end
    windows_copy = windows;
    for x = 1:64
        q = 10000000;
        b = -1;
        state = -1;
        y = find(transfer(:,x)~=100000);
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
        if(q<10000000)
            F(1,x)=q;
        end
    end
end
 info_bits_hat2(1,:) = windows(:,1)';
 info_bits_hat2 = info_bits_hat2';