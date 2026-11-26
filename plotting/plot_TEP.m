load('resultats_q24.mat');

figure(2); % Utilise la figure 2 ou en crée une nouvelle
clf;
hold on;

numCodes = size(TEP_all, 1);
hTEP = gobjects(1, numCodes);

% Tracé de chaque courbe de TEP
for iCode = 1:numCodes
    hTEP(iCode) = semilogy(EbN0dB, TEP_all(iCode,:), 'LineWidth', 2, ...
        'DisplayName', codes(iCode).nom);
end

% Mise en forme du graphique
ylim([1e-5 1]); % Ajustez la borne min si vos TEP descendent plus bas
xlim([min(EbN0dB) max(EbN0dB)]);
grid on;
set(gca, 'FontSize', 20);

title('TEP - Comparaison NSC vs RSC', 'FontSize', 22);
xlabel('$\frac{E_b}{N_0}$ en dB', 'Interpreter', 'latex', 'FontSize', 18);
ylabel('TEP', 'Interpreter', 'latex', 'FontSize', 18);
legend('Interpreter', 'latex', 'FontSize', 18, 'Location', 'southwest');

% Exportation en haute résolution pour le rapport LaTeX
exportgraphics(gcf, 'comparison_TEP_codes_2_5.png', ...
    'BackgroundColor', 'white', 'Resolution', 300, 'Padding', 'figure');