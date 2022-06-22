% =========================================================================
% Title       : Hard demodulation of Simulation for CC_sim.m
% File        : hard_demod.m
% -------------------------------------------------------------------------
% Description :
%   This file demodulates the data for 4/16/64-QAM
% -------------------------------------------------------------------------
% Revisions   :
%   Date                 Author            Description
%   01-Apr-2022    Jiaxin Lyu        file adapted from large sim-environment
% -------------------------------------------------------------------------
%   Author: Jiaxin Lyu (e-mail: ljx981120@sjtu.edu.cn)
% =========================================================================

function bit_hat = hard_demod(TxRx, y)
   % initialize the tx signal TxRx.const_power
    bit_hat = zeros(TxRx.Sim.nr_of_symbols * TxRx.Modulation_order, 1);
    switch (TxRx.Modulation_order)
        case 2 % 4-QAM / QPSK
             y_real = real(y);
             y_imag = imag(y);
             bit_hat(2 : 2 : end) = y_real > 0;
             bit_hat(1 : 2 : end - 1) = y_imag < 0;
        case 4 % 16-QAM
             y_real = real(y);
             y_imag = imag(y);
             bit_hat(4 : 4 : end) = y_real > 0;
             bit_hat(3 : 4 : end - 1) = abs(y_real) < (2 / TxRx.const_power); 
             bit_hat(2 : 4 : end - 2) = y_imag < 0;
             bit_hat(1 : 4 : end - 3) = abs(y_imag) < (2 / TxRx.const_power); 
        case 6 % 64-QAM
            y_real = real(y);
            y_imag = imag(y);
            bit_hat(6 : 6 : end) = y_real > 0;
            bit_hat(5 : 6 : end - 1) = abs(y_real) < (4 / TxRx.const_power); 
            bit_hat(4 : 6 : end - 2) = (abs(y_real) > (2 / TxRx.const_power)) & (abs(y_real) < (6 / TxRx.const_power));
            bit_hat(3 : 6 : end - 3) = y_imag < 0;
            bit_hat(2 : 6 : end - 4) = abs(y_imag) < 4 / TxRx.const_power; 
            bit_hat(1 : 6 : end - 5) = (abs(y_imag) > (2 / TxRx.const_power)) & (abs(y_imag) < (6 / TxRx.const_power));
        otherwise
            error('Modulation order for 11a mapping not supported.')
    end

    return
