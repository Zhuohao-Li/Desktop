legend_label = [];
for d = 1 : length(TxRx.Decoder.Algs)
    figure(1);
    semilogy(0:0.5:9, Result.BER(d, :), 'LineStyle','-', 'Marker','o', 'Color', [d/length(TxRx.Decoder.Algs) 0 d/length(TxRx.Decoder.Algs)],'MarkerSize', d*4, 'LineWidth', 2);
    hold on;
    %legend_label1 = [OFDM.mod_type, ' OFDM-prac'];
    legend_label = [legend_label,TxRx.Decoder.Algs(d)] ;
end
semilogy(0:0.5:9, ber0, 'LineStyle','-', 'Marker','o', 'Color', [0 1 0],'MarkerSize', 11, 'LineWidth', 2);
legend([legend_label,'theoretical']);
xlabel('$E_b / N_0\, \mathrm{(dB)}$','interpreter','latex', 'FontSize', 11);
ylabel('BER');
title('IEEE 802.11a coding Simulation');
grid on