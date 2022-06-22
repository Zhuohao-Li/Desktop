% =========================================================================
%  Title       : CC_sim
% -------------------------------------------------------------------------
%   Description :
%   The platform with support for higher-order modulation,
%   convolutional codecs (CC-(2,1,7)), and Monte Carlo simulation 
%   for BER/WER of transmission, e.g., 4/16/64-QAM, 1/2, 3/4, 2/3-rate 
%   convolutional coding, and Viterbi/BCJR decoding.
%   This platform is written for the course: VLSI digital communication 
%   principles and design 
% -------------------------------------------------------------------------
% Revisions   :
%   Date                  Author           Description
%   06-May-2022    Jiaxin Lyu       Add CC encoding and decoding 
%   01-Apr-2022     Jiaxin Lyu       Specially for teaching
% -------------------------------------------------------------------------
%   Author: Jiaxin Lyu (e-mail: ljx981120@sjtu.edu.cn)
% =========================================================================
clear
clc
close all
format shortE
addpath(genpath(pwd));  % prepends all folders to the current matlabpath

RunID = randi(1000, 1, 1); % for randomized the scenario
rng(RunID);

%% -- simulation setup
TxRx.Sim.nr_of_packets = 1e4; % Number of packets, 1e4 for good results, 1e5 for accurate result

% --set the Eb/N0 (bit SNR) ranges
TxRx.Sim.EbN0dB_list = 0: 0.5 :5;

%% -- system configuration
TxRx.Modulation_order = 2; % Modulation scheme: QPSK (2), 16-QAM (4), 64-QAM (6)
TxRx.Modulation_space = 2^(TxRx.Modulation_order); % Modulation space: QPSK (4), 16-QAM (16), 64-QAM (64)
TxRx.Modulation_type = [num2str(TxRx.Modulation_space) '-QAM'];
TxRx.PAM_space = sqrt(TxRx.Modulation_space); % Modulation PAM space:  QPSK (2), 16-QAM (4), 64-QAM (8) 
TxRx.PAM_bin_array = de2bi(0:TxRx.PAM_space - 1, TxRx.Modulation_order / 2); % we use it for demodulation

%% -- code and decoder properties
TxRx.Code.K = 7; % Constraint Length
TxRx.Code.generators = [133 171]; % Generator Polynomial
TxRx.Code.Rate = 1/2; % code rates '1/2', '3/4', '2/3' for IEEE 802.11n
TxRx.Decoder.Algs = { 'myViterbi_c','Hard-Viterbi'}; % 'Hard-Viterbi', 'Soft-Viterbi', 'BCJR', 'myViterbi_c','myViterbi_mt'
% Viterbi decoding: maximum-likelihood (ML) sequence decoding for hard/soft-input hard-output
% BCJR: maximum a posteriori (MAP) belief propagation decoding for soft-input soft-output


%% -- simulation name
TxRx.Sim.name = ['The system is coded by CC-(2, 1, 7), where the code rate is ', num2str(TxRx.Code.Rate) ', modulated by ', TxRx.Modulation_type, ', and decoded by ', strjoin(TxRx.Decoder.Algs), ' algorithm'];

%% -- start simulation
TxRx.Sim.nr_of_pbits = 2160; % Nr. of information bits of a code word/packet
TxRx.Sim.nr_of_bits = TxRx.Sim.nr_of_pbits * TxRx.Sim.nr_of_packets; % Nr. of total information bits
TxRx.Sim.nr_of_symbols = TxRx.Sim.nr_of_pbits / (TxRx.Modulation_order * TxRx.Code.Rate); % Nr. of symbols per packet

fprintf('Simulation starts at %s: \n', datestr(now));
fprintf('Simulation introduction: %s \n', TxRx.Sim.name);
fprintf('Number of packet = %d, Number of bits per packet = %d, Total bits = %d \n', TxRx.Sim.nr_of_packets, TxRx.Sim.nr_of_pbits, TxRx.Sim.nr_of_bits);

% -- initialization the constellation, the random seed
[TxRx, Result] = initial(TxRx, RunID);
encoder_error = 0;
for pack = 1 : TxRx.Sim.nr_of_packets
    %% -- transmitter: generates bits, maps to symbol vectors, and transmits symbol vectors over AWGN channel
    %% -- encoding
    [info_bits, tx_bits,tx_bits_my] = CC_encoder(TxRx); % tx_bits_my是自己写的函数的编码结果，tx_bits是自带函数编码结果
    encoder_error = encoder_error + sum(tx_bits~=tx_bits_my);%记录自己写的函数和自带函数编码不同的总位数
    %% -- modulation: 
    tx_signal = QAM_mod(TxRx, tx_bits);
    % -- generate complex-valued Gaussian noise with zero mean and unit variance
    noise = sqrt(0.5) .* (randn(TxRx.Sim.nr_of_symbols, 1) + 1i .* randn(TxRx.Sim.nr_of_symbols, 1));
    for k = 1 : length(TxRx.Sim.SNR_list) % begin SNR loop
        if (Result.ErrorCodeWords(:, k) > 200) % if there are enough error packets for this SNR, we don't need to simulation it
            continue
        end
        SNR = TxRx.Sim.SNR_list(k);                         % get SNR value (linear, not dB)
        N0 = 1 / SNR;                                               % get noise variance (power), note that we use the normalized tx_signal, so SNR = 1 / N0
        %% -- AWGN
        rx_signal = tx_signal + sqrt(N0) .* noise;      % get the received signal

        %% -- receiver: 
        %% -- demodulation
        if (ismember('BCJR', TxRx.Decoder.Algs) || ismember('Soft-Viterbi', TxRx.Decoder.Algs))     % we need soft-input for the Soft-Input Viterbi / BCJR decoder
            LLR_A = soft_demod(TxRx, rx_signal, N0);
            rx_bits = (LLR_A > 0);
        else                                                                                                                                          % we just need hard-input for the Viterbi decoder
            rx_bits = hard_demod(TxRx, rx_signal);
            LLR_A = 0;
        end
        %% -- decoding
        for d = 1 : length(TxRx.Decoder.Algs) % begin Algs' loop
            if (Result.ErrorCodeWords(d, k) > 200) % if there are enough error packets for this SNR and algorithm, we don't need to simulation it
                continue
            end
            TxRx.Decoder.Type = TxRx.Decoder.Algs{d}; % which decoder is chosen
            info_bits_hat = CC_decoder(TxRx, rx_bits, LLR_A, N0); % decoding
            %% --Counting error bits and code Words
            error_bits =  double(sum(info_bits_hat ~= info_bits)); % compare the decoded bits info_bits_hat with info_bits
            Result.ErrorBits(d, k) = Result.ErrorBits(d, k) + error_bits; % add the nr. of error bits
            Result.ErrorCodeWords(d, k) = Result.ErrorCodeWords(d, k) + (error_bits > 0); % if there is any error bit, nr. of error packets ++
            %--update the BER/WER results
            Result.BER(d, k) = Result.ErrorBits(d, k)  / (pack * TxRx.Sim.nr_of_pbits);
            Result.WER(d, k) = Result.ErrorCodeWords(d, k) / pack;
        end % end Algs' loop
    end % end SNR loop
    %% --show the BER results
    fprintf('%d/%d packets and %d bits passed;\n', pack, TxRx.Sim.nr_of_packets, pack * TxRx.Sim.nr_of_pbits);
    fprintf(['Configuration: modulated by ', num2str(TxRx.Modulation_space), '-', 'QAM, ','CC decoder is ', strjoin(TxRx.Decoder.Algs),' decoder', ', Current BER is:\n']);
    for d = 1 : length(TxRx.Decoder.Algs)
        fprintf([TxRx.Decoder.Algs{d}, ':\n']);
        disp(Result.BER(d, :));
    end
    if (Result.ErrorCodeWords > 200)
         
        break
    end
end % end packet loop
legend_label = [];
for d = 1 : length(TxRx.Decoder.Algs)
    figure(1);
    semilogy(0:0.5:5, Result.BER(d, :), 'LineStyle','-', 'Marker','o', 'Color', [d/length(TxRx.Decoder.Algs) 0 d/length(TxRx.Decoder.Algs)],'MarkerSize', 11, 'LineWidth', 2);
    hold on;
    %legend_label1 = [OFDM.mod_type, ' OFDM-prac'];
    legend_label = [legend_label,TxRx.Decoder.Algs(d)] ;
end
legend(legend_label);
xlabel('$E_b / N_0\, \mathrm{(dB)}$','interpreter','latex', 'FontSize', 11);
ylabel('BER');
title('IEEE 802.11a coding Simulation');
grid on

% -- simulation completed!
% -- Let us plot our results~~
