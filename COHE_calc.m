load('/data/procdata/detchar/env/Schumann/summer2016/CPSD/WE-FIELD/MERGE/CPSD_merge.mat')
Pxy = CPSD_merge;
clear CPSD_merge
load('/data/procdata/detchar/env/Schumann/summer2016/WE-FIELD-N/MAT/MERGE/PSD_merge.mat')
Pxx = PSD_merge;
clear PSD_merge
load('/data/procdata/detchar/env/Schumann/summer2016/WE-FIELD-S/MAT/MERGE/PSD_merge.mat')
Pyy = PSD_merge;
clear PSD_merge
load('/data/procdata/detchar/env/Schumann/summer2016/WE-FIELD-N/MAT/MERGE/times_merge.mat')
T = datenum(times_merge);
clear times_merge


F = 0:0.1:125;
%%
fmin = 11;
fmax = 17;
pmin = 1;
pmax = 10;

good = clean(sqrt(abs(Pxy)),fmin,fmax,pmin,pmax);
%good2 = clean(sqrt(Pxx),fmin,fmax,pmin,pmax);
%good3 = clean(sqrt(Pyy),fmin,fmax,pmin,pmax);

freq_good = time_clean(sqrt(Pxy),800,1600,98);
%time_good2 = time_clean(sqrt(Pxx),800,1600,95);
%time_good3 = time_clean(sqrt(Pyy),800,1600,95);

Pxyc = abs(Pxy(freq_good,good));
Pxxc = abs(Pxx(freq_good,good));
Pyyc = abs(Pyy(freq_good,good));
Tc = T(good);
Fc = F(freq_good);
% Pxyc = abs(Pxy(:,good1));
% Pxxc = abs(Pxx(:,good1));
% Pyyc = abs(Pyy(:,good1));
%%
cohe = abs(mean(Pxyc,2)).^2./(mean(Pxxc,2))./(mean(Pyyc,2));

figure('units','normalized','outerposition',[1 0 1 1])
semilogx(Fc,sqrt(cohe),'LineWidth',1)
%legend('')
%title('Coherence between Villa Cristina And North End Building')
xlabel('Hz')
ylabel('Coherence')
set(gca,'fontsize',15)
%hold on
grid on
xlim([10 50])

%%
figure('units','normalized','outerposition',[1 0 1 1])
colormap bone
subplot(2,1,1)
imagesc(T,F,log10(sqrt(abs(Pxy))))
set(gca,'XTick',T(1:720:end))
datetick('x','keepticks','keeplimits')
set(gca,'fontsize',15)
%title('Villa Cristina Before Data Selection')
xlabel('Hours on March 30 2016')
ylabel('Hz')
axis xy
colorbar
ylim([0 50])
caxis([-4 -2]) 

subplot(2,1,2)
imagesc(Tc,Fc,log10(sqrt(abs(Pxyc))))
set(gca,'XTick',-1)
set(gca,'fontsize',15)
%title('Cross Power Spectrum After Data Selection')
xlabel('Selected Time')
ylabel('Hz')
axis xy
colorbar
ylim([0 50])
caxis([-4 -2])

%%

figure('units','normalized','outerposition',[1 0 1 1])

loglog(Fc,sqrt(mean(Pxxc,2)))
grid on
hold on
loglog(Fc,sqrt(mean(Pyyc,2)))
loglog(Fc,sqrt(mean(abs(Pxyc),2)))
% loglog(F,sqrt(mean(Pxx,2)))
% loglog(F,sqrt(mean(Pyy,2)))
% loglog(F,sqrt(mean(abs(Pxy),2)))
set(gca,'fontsize',15)
title('Power Spectrums')
xlabel('Hz')
ylabel('nT/\surd{Hz}')
%legend('not time cleaned','time cleaned')
legend('WE-FIELD-N','WE-FIELD-S',...
   'Cross Spectrum Cleaned')

xlim([5 50])
ylim([2e-4 6e-3])






