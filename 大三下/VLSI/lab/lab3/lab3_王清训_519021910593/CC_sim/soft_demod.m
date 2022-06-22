% =========================================================================
% Title       : A soft demodulator to generate LLRs for decoder
% File        : soft_demod.m
% -------------------------------------------------------------------------
% Description:
%   This soft demodulator generates Log-likelihood Ratio (LLR) 
%   for the coded bits based on the channel observation y and 
%   the noise power N0. The output LLR_D is the input of BCJR 
%   decoder as a priori LLR. More precisely, we have
%   LLR_D(i) = ln( Pr[c(i) = 1 | y] / Pr[c(i) = 0 | y] ), 
%   where c(i) is the ith coded bit.
% -------------------------------------------------------------------------
% Revisions   :
%   Date                 Author  
%   01-Apr-2022    Jiaxin Lyu
% -------------------------------------------------------------------------
%   Author: Jiaxin Lyu (e-mail: ljx981120@sjtu.edu.cn)
% =========================================================================

function LLR_D = soft_demod(TxRx, y, N0)
    y_real = real(y);
    y_imag = imag(y);

    %% --get the real and imaginary parts of the QAM constellation
    tmp = reshape(TxRx.Constellations_norm, TxRx.PAM_space, TxRx.PAM_space).'; % This array is the same as constellation in init.m
    constellation_real = real(tmp(:, 1)).'; % 1 x PAM_space, the real part PAM constellation
    constellation_imag = imag(tmp(1, :)); % 1 x PAM_space, the imaginary part PAM constellation
    N_symb = length(y);
    PAM_realsymb_array = repmat(constellation_real, N_symb, 1); % extend constellation_real vector to parallelize the computation
    PAM_imagsymb_array = repmat(constellation_imag, N_symb, 1); % extend constellation_imag vector to parallelize the computation

    %% --calculate the probability of all real and imaginary symbos
    realsymb_probs = exp( -(PAM_realsymb_array - repmat(y_real, 1, TxRx.PAM_space)).^2 ./ N0 ); % calculate the probability of real symbols by Gaussian distribution
    imagsymb_probs = exp( -(PAM_imagsymb_array - repmat(y_imag, 1, TxRx.PAM_space)).^2 ./ N0 ); % calculate the probability of imaginary symbols by Gaussian distribution

    %% --calculate the LLR data for the real and imaginary parts
    LLR_D_data_r = zeros(N_symb, TxRx.Modulation_order / 2);
    LLR_D_data_i = zeros(N_symb, TxRx.Modulation_order / 2);
    for ci = 1 : (TxRx.Modulation_order / 2)
        %--find the index of the symbols where the cth bit is 0/1
        zeros_ind = find(TxRx.PAM_bin_array(:, ci) == 0);
        ones_ind = find(TxRx.PAM_bin_array(:, ci)  == 1);

        %--calculate Pr[c(ci) = 0] and Pr[c(ci) = 1] for the real part
        zero_prob_real = sum(realsymb_probs(:, zeros_ind), 2);
        one_prob_real = sum(realsymb_probs(:, ones_ind), 2);
    
        %--calculate LLRs for the real part
        LLR_D_data_r(:, ci) = log(one_prob_real ./ zero_prob_real);
    
        %--calculate Pr[c(ci) = 0] and Pr[c(ci) = 1] for the imaginary part
        zero_prob_imag = sum(imagsymb_probs(:, zeros_ind), 2);
        one_prob_imag = sum(imagsymb_probs(:, ones_ind), 2);

        %--calculate LLRs for the imaginary part
        LLR_D_data_i(:, ci) = log(one_prob_imag ./ zero_prob_imag);
    end

    %% --combine the LLR data of the real and imaginary parts and reshape it
    LLR_D_data = [LLR_D_data_i, LLR_D_data_r];
    LLR_D = reshape(LLR_D_data.', N_symb * TxRx.Modulation_order, 1);
 return
