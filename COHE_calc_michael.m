
dataDir = '/home/jharms/DATA/Schumann';
plotLocation = 'plots';
params.fmin = 1; params.fmax = 30;

dataset = 3;
plotLocation = sprintf('%s/%d',plotLocation,dataset);

if ~exist(plotLocation)
   system(['mkdir -p ' plotLocation])
end

if dataset == 1
   filename = sprintf('%s/CPSD/VC1_600W/MERGE/CPSD_merge.mat',dataDir);
   load(filename)
   Pxy = CPSD_merge;
   clear CPSD_merge
   filename = sprintf('%s/VC1/MAT_25-26/MERGE/PSD_merge.mat',dataDir);
   load(filename)
   Pxx = PSD_merge;
   clear PSD_merge
   filename = sprintf('%s/600W/MAT_25-26/MERGE/PSD_merge.mat',dataDir);
   load(filename)
   Pyy = PSD_merge;
   clear PSD_merge
elseif dataset == 2
   filename = sprintf('%s/CPSD/VC2_NEB/MERGE/CPSD_merge.mat',dataDir);
   load(filename)
   Pxy = CPSD_merge;
   clear CPSD_merge
   filename = sprintf('%s/VC2/MAT_30/MERGE/PSD_merge.mat',dataDir);
   load(filename)
   Pxx = PSD_merge;
   clear PSD_merge
   filename = sprintf('%s/NEB/MAT_30/MERGE/PSD_merge.mat',dataDir);
   load(filename)
   Pyy = PSD_merge;
   clear PSD_merge
elseif dataset == 3
   filename = sprintf('%s/CPSD/WE-FIELD/MERGE/CPSD_merge.mat',dataDir);
   load(filename)
   Pxy = CPSD_merge;
   clear CPSD_merge
   filename = sprintf('%s/WE-FIELD-N/MAT/MERGE/PSD_merge.mat',dataDir);
   load(filename)
   Pxx = PSD_merge;
   clear PSD_merge
   filename = sprintf('%s/WE-FIELD-S/MAT/MERGE/PSD_merge.mat',dataDir);
   load(filename)
   Pyy = PSD_merge;
   clear PSD_merge
end

F = 0:0.1:125;

%%
fmin = 11;
fmax = 17;
pmin = 1;
pmax = 10;

%Pxyc = clean(abs(Pxy),fmin,fmax,p);
%Pxxc = clean(Pxx,fmin,fmax,p);
%Pyyc = clean(Pyy,fmin,fmax,p);

good1 = clean(sqrt(abs(Pxy)),fmin,fmax,pmin,pmax);
good2 = clean(sqrt(Pxx),fmin,fmax,pmin,pmax);
good3 = clean(sqrt(Pyy),fmin,fmax,pmin,pmax);

%time_good1 = time_clean(sqrt(Pxy),800,1600,98);

Pxyc = abs(Pxy(:,good1));
Pxxc = abs(Pxx(:,good1));
Pyyc = abs(Pyy(:,good1));

%%
cohe = abs(mean(Pxyc,2)).^2./(mean(Pxxc,2))./(mean(Pyyc,2));

figure;
plot(F,sqrt(cohe),'LineWidth',1)
legend('VC2 NEB','VC1 600W')
xlabel('Hz')
ylabel('Coherence')
hold on
grid on
xlim([1 30])
print('-dpdf',[plotLocation '/coh.pdf']);
print('-dpng',[plotLocation '/coh.png']);
print('-depsc2',[plotLocation '/coh.eps']);
close;

%%
figure;
colormap bone
subplot(2,1,1)
imagesc(0:48,F,log10(sqrt(abs(Pyy))))   
title('Before Cleaning')
xlabel('Hours')
ylabel('Hz')
axis xy
colorbar
ylim([0 30])
caxis([-4 -2]) %for VC1
%caxis([-2 2]) %for 600W
%caxis([-4 3]) %for VC1_600W

%caxis([-6 3]) %for VC2_NEB

subplot(2,1,2)
imagesc(0:48,F,log10(sqrt(abs(Pyyc))))
title('After Cleaning')
ylabel('Hz')
axis xy
colorbar
ylim([0 30])
caxis([-4 -2]) %for VC1
%caxis([-2 2]) %for 600W
%caxis([-4 3]) %for VC1_600W
%caxis([-6 3]) %for VC2_NEB
print('-dpdf',[plotLocation '/cohtf.pdf']);
print('-dpng',[plotLocation '/cohtf.png']);
print('-depsc2',[plotLocation '/cohtf.eps']);
close;

%%

figure;
semilogy(F,sqrt(mean(Pxxc,2)))
hold on
grid on
semilogy(F,sqrt(mean(Pyyc,2)))
semilogy(F,sqrt(mean(abs(Pxyc),2)))
% loglog(F,sqrt(mean(Pxx,2)))
% loglog(F,sqrt(mean(Pyy,2)))
% loglog(F,sqrt(mean(abs(Pxy),2)))

xlabel('Hz')
ylabel('nT/\surd{Hz}')
legend('good1','good2','good3','respective')
%legend('Villa Cristina Cleaned','600m West Cleaned',...
%    'Cross Spectrum Cleaned','Villa Cristina','600m W','Cross Spectrum')

xlim([1 30])
ylim([1e-4 1e-2])

print('-dpdf',[plotLocation '/crosspower.pdf']);
print('-dpng',[plotLocation '/crosspower.png']);
print('-depsc2',[plotLocation '/crosspower.eps']);
close;

[numf,numt] = size(Pxyc);
data.tt = 1:numt;
data.ff = F;

num = 25;
% Number of averages to perform for coherence analysis
numSpectra = floor(length(data.tt)/num);
indexes = 1:numSpectra:length(data.tt);
indexes = indexes(1:num);

data.tt = data.tt(indexes(1:end-1));
data.coherence = NaN*ones(length(data.ff),length(data.tt));

% Calculate coherence
for i = 1:length(data.tt)
   index = indexes(i):indexes(i+1);
   cohe = abs(mean(Pxyc(:,index),2)).^2./(mean(Pxxc(:,index),2))./(mean(Pyyc(:,index),2));
   data.coherence(:,i) = cohe;
end

% Binning parameters
nb = 100;
range_binning = linspace(0,1,nb);

% Determine coherence to keep
which_coherence = find(~isnan(data.coherence(1,:)));

if isempty(which_coherence)
   return;
end

% Calculate bin histogram of coherences
data.coherence_variation = hist(data.coherence(:,which_coherence)',range_binning)';
np = sum(data.coherence_variation(1,:),2);

% Convert to percentiles
data.coherence_variation_norm = data.coherence_variation * 100 / np;

% Initialize arrays
data.coherence_variation_norm_1per = [];
data.coherence_variation_norm_10per = [];
data.coherence_variation_norm_50per = [];
data.coherence_variation_norm_90per = [];
data.coherence_variation_norm_99per = [];

for i = 1:length(data.ff)
   data.coherence_variation_norm_1per(i) = calculate_percentiles(data.coherence_variation_norm(i,:),range_binning,1);
   data.coherence_variation_norm_10per(i) = calculate_percentiles(data.coherence_variation_norm(i,:),range_binning,10);
   data.coherence_variation_norm_50per(i) = calculate_percentiles(data.coherence_variation_norm(i,:),range_binning,50);
   data.coherence_variation_norm_90per(i) = calculate_percentiles(data.coherence_variation_norm(i,:),range_binning,90);
   data.coherence_variation_norm_99per(i) = calculate_percentiles(data.coherence_variation_norm(i,:),range_binning,99);
end

% Save coherence mat file
save(sprintf('coh%d.mat',dataset),'data','-v7.3');

% Coherence plot
figure;
set(gcf, 'PaperSize',[10 6]);
set(gcf, 'PaperPosition', [0 0 10 6]);
semilogy(data.ff,data.coherence_variation_norm_10per,'LineWidth',1);
hold all
semilogy(data.ff,data.coherence_variation_norm_50per,'LineWidth',1);
semilogy(data.ff,data.coherence_variation_norm_90per,'LineWidth',1);
semilogy(data.ff,mean(data.coherence(:,which_coherence),2),'LineWidth',1);
hold off
grid;
xlabel('Frequency [Hz]');
ylabel('Coherence');
grid
set(gca,'Layer','top')
leg1 = legend('10','50','90','Mean')
set(leg1,'Location','SouthEast');
axis([params.fmin params.fmax 0 1])

print('-dpdf',[plotLocation '/cohperc.pdf']);
print('-dpng',[plotLocation '/cohperc.png']);
print('-depsc2',[plotLocation '/cohperc.eps']);

close;

[X,Y] = meshgrid(data.ff,range_binning);

% Coherence variation plot
figure;
set(gcf, 'PaperSize',[10 8])
set(gcf, 'PaperPosition', [0 0 10 8])
clf

data.coherence_variation_norm(data.coherence_variation_norm==0) = NaN;
hC = pcolor(X,Y,data.coherence_variation_norm');
set(hC, 'EdgeColor', 'none');

%caxis([0 1])
%set(gcf,'Renderer','zbuffer');

%shading interp
set(gca,'xscale','lin','XLim',[params.fmin params.fmax])
set(gca,'yscale','lin','YLim',[range_binning(1) range_binning(end)])
set(gca,'clim',[0 10])
xlabel('Frequency [Hz]')
ylabel('Coherence')
%grid
%set(gca,'Layer','top')

colormap(jet);

hold on
semilogx(data.ff,data.coherence_variation_norm_10per,'w',data.ff,data.coherence_variation_norm_90per,'w',data.ff,data.coherence_variation_norm_50per,'w','LineWidth',3)
hold off

print('-dpdf',[plotLocation '/cohvar.pdf']);
print('-dpng',[plotLocation '/cohvar.png']);
print('-depsc2',[plotLocation '/cohvar.eps']);

close;

tt = 86400 * (data.tt - data.tt(1)) / (60*60);
tt = data.tt - data.tt(1);
[X,Y] = meshgrid(data.ff,tt);

tt = tt(1:2:end);
dt = tt(2)-tt(1);
tt = (0:length(tt)-1)*dt;
%[X,Y] = meshgrid(data.ff,tt);

fun = @(block_struct) mean(block_struct.data(:));
%X = blockproc(X,[5 5],fun);
%Y = blockproc(Y,[5 5],fun);
coh = blockproc(data.coherence,[1 2],fun);

% Time-frequency coherence plot
figure;
set(gcf, 'PaperSize',[10 8])
set(gcf, 'PaperPosition', [0 0 10 8])
clf

%hC = pcolor(X,Y,coh');
hC = pcolor(X,Y,data.coherence');
set(gcf,'Renderer','zbuffer');
colormap(jet)
%shading interp

t = colorbar('peer',gca);

set(get(t,'ylabel'),'String','Coherence');
set(gca,'xscale','lin','XLim',[params.fmin params.fmax])
set(hC,'LineStyle','none');
set(hC,'EdgeColor','none');
%grid
set(gca,'clim',[0 1])
xlabel('Frequency [Hz]')
ylabel('Time [Hours]');

print('-dpdf',[plotLocation '/cohtf.pdf']);
print('-dpng',[plotLocation '/cohtf.png']);
print('-depsc2',[plotLocation '/cohtf.eps']);

close;

% Time-frequency coherence plot
figure;
set(gcf, 'PaperSize',[10 8])
set(gcf, 'PaperPosition', [0 0 10 8])
clf

%hC = pcolor(X,Y,coh');
hC = pcolor(X,Y,log10(1-data.coherence'));
set(gcf,'Renderer','zbuffer');
colormap(jet)
%shading interp

t = colorbar('peer',gca);

set(get(t,'ylabel'),'String','log10(1-Coherence)');
set(gca,'xscale','lin','XLim',[params.fmin params.fmax])
set(hC,'LineStyle','none');
set(hC,'EdgeColor','none');
%grid
set(gca,'clim',[-3 0])
xlabel('Frequency [Hz]')
ylabel('Time [Hours]');

print('-dpdf',[plotLocation '/oneminuscohtf.pdf']);
print('-dpng',[plotLocation '/oneminuscohtf.png']);
print('-depsc2',[plotLocation '/oneminuscohtf.eps']);

close;
