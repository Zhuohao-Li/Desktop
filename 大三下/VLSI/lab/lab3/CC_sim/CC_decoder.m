% =========================================================================
% Title       : Wrapper for CC Decoders
% File        : CC_decoder.m
% -------------------------------------------------------------------------
% Description :
%   This file performs (de-)puncturing and calls the chosen CC
%   decoders for the decision the information bits.
%   LLR_D is a priori LLR calculated by demodulator, info_bits_hat 
%   is the decision of info. bits
% -------------------------------------------------------------------------
% Revisions   :
%   Date                  Author  
%   02-Apr-2022     Jiaxin Lyu
% -------------------------------------------------------------------------
%   Author: Jiaxin Lyu (e-mail: ljx981120@sjtu.edu.cn)
% =========================================================================

function info_bits_hat = CC_decoder(TxRx, rx_bits, LLR_D, N0)
    %% -- channel decoding
    switch (TxRx.Decoder.Type)
        case 'BCJR' % -- log-MAP BCJR algorithm for CC decoding (fast Matlab/mex C-implementation)
            LLR_A = zeros(4320, 1);
            LLR_A(TxRx.Code.Puncturing.Index) = LLR_D;
            [~, info_bits_hat] = BCJR(LLR_A, TxRx.Code.trellis.numInputSymbols,TxRx.Code.trellis.numOutputSymbols, ...
                TxRx.Code.trellis.numStates,TxRx.Code.trellis.nextStates,TxRx.Code.trellis.outputs);
        case 'Hard-Viterbi'
            if (TxRx.Code.Rate == 1/2) % no puncturing
                info_bits_hat = vitdec(rx_bits, TxRx.Code.trellis, TxRx.Code.tblen, 'term', 'hard');
            else % punturing is required
                info_bits_hat = vitdec(rx_bits, TxRx.Code.trellis, TxRx.Code.tblen, 'term', 'hard', TxRx.Code.Puncturing.Pattern);
            end
            info_bits_hat = logical(info_bits_hat);
        case 'Soft-Viterbi'
            rx_data = (0.5 * N0) .* LLR_D;
            if (TxRx.Code.Rate == 1/2) % no puncturing
                info_bits_hat = vitdec(-rx_data, TxRx.Code.trellis, TxRx.Code.tblen, 'term', 'unquant');
            else % punturing is required
                info_bits_hat = vitdec(-rx_data, TxRx.Code.trellis, TxRx.Code.tblen, 'term', 'unquant', TxRx.Code.Puncturing.Pattern);
            end
            info_bits_hat = logical(info_bits_hat);
        case 'myViterbi'
            %% -- Please implement the Viterbi decoder by yourself-- %%  
            % implemented by Matlab/mex C library, see more in ./myDec.c 
            if (TxRx.Code.Rate == 1/2)
                info_bits_hat = myDec(rx_bits,TxRx.Code.trellis.nextStates,TxRx.Code.trellis.outputs,2160,[1 0]);
            elseif(TxRx.Code.Rate == 2/3)
                info_bits_hat = myDec(rx_bits,TxRx.Code.trellis.nextStates,TxRx.Code.trellis.outputs,2160,[1 1 0]);
            elseif(TxRx.Code.Rate == 3/4)
                info_bits_hat = myDec(rx_bits,TxRx.Code.trellis.nextStates,TxRx.Code.trellis.outputs,2160,[1 1 1 0]);    
            end
        otherwise
            error('No valid TxRx.Decoder.Type in CC_decoder.m')
    end
return
