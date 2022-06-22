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
    info_bits = randi([0 1], 1, TxRx.Sim.nr_of_pbits);                      % information bits 
    info_bits(TxRx.Sim.nr_of_pbits + 2 - TxRx.Code.K : end) = 0;    % set the tail of the info_bits to zero
    coded_bits = convenc(info_bits, TxRx.Code.trellis);                   % requires communication toolbox
    
    %% --Pleast implement the convenc function by yourself to replace the above sentence-- %%
    coded_bits_my = myConvenc(info_bits, TxRx.Code.trellis);
    %% -- puncturing
    coded_bits_punctured = coded_bits(TxRx.Code.Puncturing.Index);
    coded_bits_punctured_my = coded_bits_my(TxRx.Code.Puncturing.Index);
    info_bits = logical(info_bits).';
 return

 function [coded] = myConvenc(info,trenlis)
      coded = [];
      reg = 0;
      for x = 1:length(info)
          in = info(x);
          %根据状态转移矩阵课输出矩阵根据输入找到下一个状态和输出
          if(in == 1)
              out = trenlis.outputs(reg+1,2);
              reg = trenlis.nextStates(reg+1,2);
          else 
              out = trenlis.outputs(reg+1,1);
              reg = trenlis.nextStates(reg+1,1);
          end
          %将输出表中的0，1，2，3转化成二进制
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
      
 return
 
 