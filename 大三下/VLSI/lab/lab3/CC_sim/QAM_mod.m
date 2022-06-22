% =========================================================================
% Title       : modulation
% File        : QAM_mod.m
% -------------------------------------------------------------------------
% Description :
%   This file maps the coded bits (punctured) to a BPSK or QAM 
%   symbol vector.
% -------------------------------------------------------------------------
% Revisions   :
%   Date                 Author  
%   01-Apr-2022    Jiaxin Lyu
% -------------------------------------------------------------------------
%   Author: Jiaxin Lyu (e-mail: ljx981120@sjtu.edu.cn)
% =========================================================================

function symb_vector = QAM_mod(TxRx, coded_bits_punctured)
   %% -- modulation (prepare symbol vector)
   %--reshape the punctured bits to a TxRx.Modulation_order by TxRx.Sim.nr_of_symbols array, 
   data_bin_mod = reshape(coded_bits_punctured, TxRx.Modulation_order, TxRx.Sim.nr_of_symbols);
   %--transform the binary data_bin_mod to a decimal vector and map to QAM symbols
   QAM_index = bi2de(data_bin_mod.').';
   %--obtain the QAM symbol vector
   symb_vector = TxRx.Constellations_norm(QAM_index + 1).';
return
