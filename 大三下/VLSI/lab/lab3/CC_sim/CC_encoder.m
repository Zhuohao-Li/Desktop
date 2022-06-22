% =========================================================================
% Title       : Convolutional code encoder
% File        : CC_encoder.m
% -------------------------------------------------------------------------
% Description :
%   This file generates random bits, applies forward error-correction with
%   a CC encoder and puncturing (note: a trellis of CC is required).
% -------------------------------------------------------------------------
% Revisions   :
%   Date                 Author  
%   01-Apr-2022    Jiaxin Lyu
% -------------------------------------------------------------------------
%   Author: Jiaxin Lyu (e-mail: ljx981120@sjtu.edu.cn)
% =========================================================================

function [info_bits, coded_bits_punctured,coded_bits_punctured_my] = CC_encoder(TxRx)
    %% -- generate random bits and encoded by CC
    info_bits = randi([0 1], 1, TxRx.Sim.nr_of_pbits);                        % information bits 
    info_bits(TxRx.Sim.nr_of_pbits + 2 - TxRx.Code.K : end) = 0;    % set the tail of the info_bits to zero
    coded_bits = convenc(info_bits, TxRx.Code.trellis);                   % requires communication toolbox

    %% --Pleast implement the convenc function by yourself to replace the above sentence-- %%
      % implemented by Matlab/mex C library, see more in ./myEnc.c 
      coded_bits_my = myEnc(info_bits, TxRx.Code.trellis);

    %% -- puncturing
    coded_bits_punctured = coded_bits(TxRx.Code.Puncturing.Index);
    coded_bits_punctured_my = coded_bits_my(TxRx.Code.Puncturing.Index);
    info_bits = logical(info_bits).';
 return
