clear;
clc;

figure;
axis([0 9 1.0e-5, 1.0e0]);
load('BPSK_1_2.mat');
semilogy (ebn0,ber,'-ob');
hold on;

load('BPSK_2_3.mat');
semilogy (ebn0,ber,'-*b');
hold on;

load('BPSK_3_4.mat');
semilogy(ebn0,ber,'-^b');
hold on;

load('QPSK_1_2.mat');
semilogy (ebn0,ber,'-or');
hold on;

load('QPSK_2_3.mat');
semilogy (ebn0,ber,'-*r');
hold on;

load('QPSK_3_4.mat');
semilogy (ebn0,ber,'-^r');
hold on;

load('16QAM_1_2.mat');
semilogy (ebn0,ber,'-og');
hold on;

load('16QAM_2_3.mat');
semilogy (ebn0,ber,'-^g');
hold on;

load('16QAM_3_4.mat');
semilogy (ebn0,ber,'-*g');
hold on;

legend ('BPSK_1_2', 'BPSK_2_3','BPSK_3_4','QPSK_1_2','QPSK_2_3','QPSK_3_4','16QAM_1_2','16QAM_2_3','16QAM_3_4',3);
title('802.11a Simulation');
grid on;
