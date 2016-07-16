
plotLocation = 'plots';
dataLocation = 'data';
params.fmin = 1; params.fmax = 30;

if ~exist(plotLocation)
   system(['mkdir -p ' plotLocation])
end
if ~exist(dataLocation)
   system(['mkdir -p ' dataLocation])
end


% Save coherence mat file
set1 = load(sprintf('%s/coh%d.mat',dataLocation,1));
set2 = load(sprintf('%s/coh%d.mat',dataLocation,2));
set3 = load(sprintf('%s/coh%d.mat',dataLocation,3));

% Coherence plot
figure;
set(gcf, 'PaperSize',[10 6]);
set(gcf, 'PaperPosition', [0 0 10 6]);
semilogy(set1.data.ff,set1.data.coherence_variation_norm_50per,'LineWidth',1);
hold all
semilogy(set2.data.ff,set2.data.coherence_variation_norm_50per,'LineWidth',1);
semilogy(set3.data.ff,set3.data.coherence_variation_norm_50per,'LineWidth',1);
hold off
grid;
xlabel('Frequency [Hz]');
ylabel('Coherence');
grid
set(gca,'Layer','top')
leg1 = legend('VC1_600W','VC2_NEB','WE-FIELD')
set(leg1,'Location','SouthEast');
axis([params.fmin params.fmax 0 1])

print('-dpdf',[plotLocation '/cohperccombine.pdf']);
print('-dpng',[plotLocation '/cohperccombine.png']);
print('-depsc2',[plotLocation '/cohperccombine.eps']);

close;

