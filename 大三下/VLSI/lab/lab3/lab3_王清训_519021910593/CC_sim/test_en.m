total = 0;
for t =1:900
    info_bits = randi([0 1], 1, 2160);                      % information bits 
    info_bits(2160 + 2 - 7 : end) = 0;    % set the tail of the info_bits to zero
    coded_bits1 = convenc(info_bits, TxRx.Code.trellis);                   % requires communication toolbo
    coded = [];
    reg = 0;
    for x = 1:length(info_bits)
      in = info_bits(x);
      if(in == 1)
          out = TxRx.Code.trellis.outputs(reg+1,2);
          reg = TxRx.Code.trellis.nextStates(reg+1,2);
      else 
          out = TxRx.Code.trellis.outputs(reg+1,1);
          reg = TxRx.Code.trellis.nextStates(reg+1,1);
      end
      if(out == 0)
          coded = [coded,[0 0]];
      elseif(out == 1)
          coded = [coded,[0 1]];
      elseif(out == 2)
          coded = [coded,[1 0]];
      else
          coded = [coded,[1 1]];
      end
    end
end
    total = total + sum(coded~=coded_bits1)