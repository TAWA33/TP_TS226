clear; clc; close all;

%% Données recopiées depuis le tableau
EbN0dB = -2:0.5:10;
nSNR = numel(EbN0dB);

noms = {'(2,3)_8','(5,7)_8','(13,15)_8','(133,171)_8'};

TEB = nan(4,nSNR);

% (2,3)_8
TEB(1,:) = [2.04e-1 1.93e-1 1.63e-1 1.48e-1 1.26e-1 ...
            1.15e-1 9.49e-2 7.94e-2 6.63e-2 4.68e-2 ...
            3.77e-2 2.99e-2 2.07e-2 1.37e-2 9.15e-3 ...
            6.04e-3 3.49e-3 2.22e-3 1.10e-3 5.60e-4 ...
            2.63e-4 1.09e-4 4.26e-5 1.60e-5 4.26e-6];

% (5,7)_8
TEB(2,1:22) = [2.96e-1 2.95e-1 2.55e-1 2.48e-1 1.93e-1 ...
               1.69e-1 1.25e-1 9.42e-2 6.31e-2 6.28e-2 ...
               3.13e-2 2.05e-2 9.88e-3 5.81e-3 3.56e-3 ...
               1.53e-3 6.79e-4 2.86e-4 9.72e-5 3.56e-5 ...
               1.02e-5 2.72e-6];

% (13,15)_8
TEB(3,1:22) = [4.18e-1 3.52e-1 3.22e-1 2.54e-1 2.54e-1 ...
               2.10e-1 2.04e-1 1.18e-1 1.21e-1 6.58e-2 ...
               4.96e-2 2.48e-2 1.36e-2 7.50e-3 3.28e-3 ...
               1.57e-3 7.39e-4 3.14e-4 1.06e-4 3.79e-5 ...
               1.01e-5 2.93e-6];

% (133,171)_8
TEB(4,1:19) = [4.33e-1 4.41e-1 4.63e-1 3.78e-1 3.84e-1 ...
               3.11e-1 2.47e-1 1.75e-1 1.04e-1 8.35e-2 ...
               2.50e-2 1.57e-2 6.10e-3 1.76e-3 5.78e-4 ...
               1.87e-4 4.56e-5 1.12e-5 1.47e-6];

%% Courbe non codée BPSK
Pb_u = qfunc(sqrt(2*10.^(EbN0dB/10)));

figure(1); clf;
set(gcf, 'Units', 'pixels', 'Position', [100 100 1000 700], ...
         'Color', 'white', 'PaperPositionMode', 'auto');

% Courbe non codée BPSK
Pb_u = qfunc(sqrt(2*10.^(EbN0dB/10)));

semilogy(EbN0dB, Pb_u, 'k--', 'LineWidth', 2, ...
    'DisplayName', 'BPSK non codé');
hold on;

for i = 1:4
    semilogy(EbN0dB, TEB(i,:), 'o-', 'LineWidth', 2, ...
        'DisplayName', noms{i});
end

grid on;
set(gca, 'FontSize', 16, 'LineWidth', 1.2, 'Box', 'on');
xlim([min(EbN0dB) max(EbN0dB)]);
ylim([1e-6 1]);

xlabel('E_b/N_0 (dB)', 'FontSize', 18, 'Interpreter', 'tex');
ylabel('TEB',           'FontSize', 18, 'Interpreter', 'tex');
title('Convolutive code Comparison', 'FontSize', 20, 'Interpreter', 'tex');

lgd = legend('Location', 'southwest');
set(lgd, 'FontSize', 14, 'Interpreter', 'tex', 'Box', 'on');

%% Export PNG robuste
exportgraphics(gcf, 'comparison_conv_codes.png', ...
    'Resolution', 300, ...
    'BackgroundColor', 'white', ...
    'Padding', 'figure');

%% Seuil non codé à Pb = 1e-5
EbN0_non_code_1e5 = 10*log10(qfuncinv(1e-5)^2/2);

%% Calcul du seuil codé à TEB = 1e-5 et du gain
EbN0_code_1e5 = nan(1,4);
gain_codage   = nan(1,4);

for i = 1:4
    idx = find(TEB(i,:) < 1e-5, 1, 'first');

    if isempty(idx) || idx == 1
        EbN0_code_1e5(i) = NaN;
    else
        x1 = EbN0dB(idx-1);
        x2 = EbN0dB(idx);
        y1 = log10(TEB(i,idx-1));
        y2 = log10(TEB(i,idx));

        EbN0_code_1e5(i) = interp1([y1 y2], [x1 x2], -5);
    end

    gain_codage(i) = EbN0_non_code_1e5 - EbN0_code_1e5(i);
end

%% Affichage tableau
R      = [0.4995 0.4990 0.4985 0.4971];
m      = [1 2 3 6];
etats  = [2 4 8 64];
dmin   = [3 5 6 10];

fprintf('\nSeuil non codé à Pb=1e-5 : %.3f dB\n\n', EbN0_non_code_1e5);
fprintf('| %-13s | %-8s | %-3s | %-5s | %-4s | %-12s | %-10s |\n', ...
    'Code','Rendement','m','Etats','dmin','EbN0@1e-5','Gain');
fprintf('|---------------|----------|-----|-------|------|--------------|------------|\n');

for i = 1:4
    fprintf('| %-13s | %-8.4f | %-3d | %-5d | %-4d | %-12.3f | %-10.3f |\n', ...
        noms{i}, R(i), m(i), etats(i), dmin(i), ...
        EbN0_code_1e5(i), gain_codage(i));
end