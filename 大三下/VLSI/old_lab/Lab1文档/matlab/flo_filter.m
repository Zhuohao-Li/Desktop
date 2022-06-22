function Hd = flo_filter
%FLO_FILTER Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 8.2 and the Signal Processing Toolbox 6.20.
% Generated on: 08-May-2014 13:48:40

% Equiripple Lowpass filter designed using the FIRPM function.

% All frequency values are in MHz.
Fs = 8;  % Sampling Frequency

N     = 31;   % Order
Fpass = 1.6;  % Passband Frequency
Fstop = 2.4;  % Stopband Frequency
Wpass = 1;    % Passband Weight
Wstop = 50;   % Stopband Weight
dens  = 20;   % Density Factor

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, [0 Fpass Fstop Fs/2]/(Fs/2), [1 1 0 0], [Wpass Wstop], ...
           {dens});
Hd = dfilt.dffir(b);

% [EOF]
