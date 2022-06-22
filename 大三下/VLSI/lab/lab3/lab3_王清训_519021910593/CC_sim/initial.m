% =========================================================================
% Title       : Initialization of Simulation for IEEE 802.11a
% File        : initial.m
% -------------------------------------------------------------------------
% Description :
%   This file initializes random seeds, prepares constellation symbols
%   with the (Gray) mapping, generates the result memory, including
%   BER and WER array
% -------------------------------------------------------------------------
% Revisions   :
%   Date                 Author            Description
%   01-Apr-2022    Jiaxin Lyu        file adapted from large sim-environment
% -------------------------------------------------------------------------
%   Author: Jiaxin Lyu (e-mail: ljx981120@sjtu.edu.cn)
% =========================================================================

function [TxRx, Result] = initial(TxRx, RunID)

    % -- initialization of random seeds
    rng(RunID);

    % -- construct IEEE 802.11a-compliant mapping/constellation points
    % -- Gray mapping verision
    switch (TxRx.Modulation_order)
        case 2 % 4-QAM / QPSK
            TxRx.Constellations = [-1 + 1i, -1 - 1i, ...
                                   +1 + 1i, +1 - 1i];
        case 4 % 16-QAM
            TxRx.Constellations = [-3 + 3i, -3 + 1i, -3 - 3i, -3 - 1i, ...
                                   -1 + 3i, -1 + 1i, -1 - 3i, -1 - 1i, ...
                                   +3 + 3i, +3 + 1i, +3 - 3i, +3 - 1i, ...
                                   +1 + 3i, +1 + 1i, +1 - 3i, +1 - 1i];
        case 6 % 64-QAM
            TxRx.Constellations = [-7 + 7i, -7 + 5i, -7 + 1i, -7 + 3i, -7 - 7i, -7 - 5i, -7 - 1i, -7 - 3i, ...
                                   -5 + 7i, -5 + 5i, -5 + 1i, -5 + 3i, -5 - 7i, -5 - 5i, -5 - 1i, -5 - 3i, ...
                                   -1 + 7i, -1 + 5i, -1 + 1i, -1 + 3i, -1 - 7i, -1 - 5i, -1 - 1i, -1 - 3i, ...
                                   -3 + 7i, -3 + 5i, -3 + 1i, -3 + 3i, -3 - 7i, -3 - 5i, -3 - 1i, -3 - 3i, ...
                                   +7 + 7i, +7 + 5i, +7 + 1i, +7 + 3i, +7 - 7i, +7 - 5i, +7 - 1i, +7 - 3i, ...
                                   +5 + 7i, +5 + 5i, +5 + 1i, +5 + 3i, +5 - 7i, +5 - 5i, +5 - 1i, +5 - 3i, ...
                                   +1 + 7i, +1 + 5i, +1 + 1i, +1 + 3i, +1 - 7i, +1 - 5i, +1 - 1i, +1 - 3i, ...
                                   +3 + 7i, +3 + 5i, +3 + 1i, +3 + 3i, +3 - 7i, +3 - 5i, +3 - 1i, +3 - 3i];
        otherwise
            error('Modulation order for 11a mapping not supported.')
    end

    % -- normalize power such that E[|s|^2] = 1
    const_squared_power = sum(abs(TxRx.Constellations).^2) / length(TxRx.Constellations); % the average squared power of the constellation
    TxRx.const_power = sqrt(const_squared_power);
    TxRx.Constellations_norm = TxRx.Constellations ./ TxRx.const_power; % the normalized power constellation

    
    TxRx.Sim.SNR_dB_list = TxRx.Sim.EbN0dB_list + 10 * log10(TxRx.Modulation_order * TxRx.Code.Rate);
    TxRx.Sim.SNR_list = 10.^(TxRx.Sim.SNR_dB_list ./ 10);

    
    TxRx.Code.trellis = poly2trellis(TxRx.Code.K, TxRx.Code.generators); % requires communication toolbox
    codedBits = 2 * TxRx.Sim.nr_of_pbits; 
     % -- puncturing according to IEEE 802.11n
    switch (TxRx.Code.Rate)% total code rate (after puncturing)
        case 1/2% -- no puncturing
            TxRx.Code.Puncturing.Period = 1;
            TxRx.Code.Puncturing.Pattern = 1;
            TxRx.Code.tblen = 60; % a rate 1/2 code has a TracebackDepth of 5(k-1) in general.
            TxRx.Code.Puncturing.Index = true(1, codedBits);
        case 3/4
            TxRx.Code.Puncturing.Period = 18;
            TxRx.Code.tblen = 60; % a rate 3/4 code has a TracebackDepth of 10(k-1) in general.
            % puncturing pattern is [1 2 3 6 7 8 9 12 13 14 15 18];
            TxRx.Code.Puncturing.Pattern = logical([1 1 1 0 0 1 1 1 1 0 0 1 1 1 1 0 0 1]);
        case 2/3
            TxRx.Code.Puncturing.Period = 12;
            TxRx.Code.tblen = 45; % a rate 2/3 code has a TracebackDepth of 7.5(k-1) in general.
            % puncturing pattern is [1 2 3 5 6 7 9 10 11]; 
            TxRx.Code.Puncturing.Pattern = logical([1 1 1 0 1 1 1 0 1 1 1 0]);
        otherwise
            error('Rate not supported in IEEE 802.11n')
    end
    
    if (TxRx.Code.Rate ~= 1/2) % we need puncturing!
        % set 0 at the location of the punctured bits
        TxRx.Code.Puncturing.Index = repmat(TxRx.Code.Puncturing.Pattern, 1, codedBits / TxRx.Code.Puncturing.Period);
    end


    % -- prepare Result structure
    Result.ErrorBits = zeros(length(TxRx.Decoder.Algs), length(TxRx.Sim.SNR_list)); % nr. of error bits
    Result.ErrorCodeWords = zeros(length(TxRx.Decoder.Algs), length(TxRx.Sim.SNR_list)); % nr. of error code words
    Result.BER = zeros(length(TxRx.Decoder.Algs), length(TxRx.Sim.SNR_list)); % Bit error rate
    Result.WER = zeros(length(TxRx.Decoder.Algs), length(TxRx.Sim.SNR_list)); % Word error rate


    return
