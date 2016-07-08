% load('/data/procdata/detchar/env/Schumann/summer2016/CPSD/VC2_NEB/MERGE/CPSD_merge.mat')
% Pxy = CPSD_merge;
% clear CPSD_merge
% load('/data/procdata/detchar/env/Schumann/summer2016/VC2/MAT_30/MERGE/PSD_merge.mat')
% Pxx = PSD_merge;
% clear PSD_merge
% load('/data/procdata/detchar/env/Schumann/summer2016/NEB/MAT_30/MERGE/PSD_merge.mat')
% Pyy = PSD_merge;
% clear PSD_merge

load('/data/procdata/detchar/env/Schumann/summer2016/CPSD/VC1_600W/MERGE/CPSD_merge.mat')
Pxy = CPSD_merge;
clear CPSD_merge
load('/data/procdata/detchar/env/Schumann/summer2016/VC1/MAT_25-26/MERGE/PSD_merge.mat')
Pxx = PSD_merge;
clear PSD_merge
load('/data/procdata/detchar/env/Schumann/summer2016/600W/MAT_25-26/MERGE/PSD_merge.mat')
Pyy = PSD_merge;
clear PSD_merge

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

figure(4)
semilogx(F,sqrt(cohe),'LineWidth',1)
legend('VC2 NEB','VC1 600W')
xlabel('Hz')
ylabel('Coherence')
hold on
grid on
xlim([3 60])

%%
figure (5)
colormap bone
subplot(2,1,1)
imagesc(0:48,F,log10(sqrt(abs(Pyy))))   
title('Before Cleaning')
xlabel('Hours')
ylabel('Hz')
axis xy
colorbar
ylim([0 50])
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
ylim([0 50])
caxis([-4 -2]) %for VC1
%caxis([-2 2]) %for 600W
%caxis([-4 3]) %for VC1_600W
%caxis([-6 3]) %for VC2_NEB

%%

figure(6)
loglog(F,sqrt(mean(Pxxc,2)))
hold on
grid on
loglog(F,sqrt(mean(Pyyc,2)))
loglog(F,sqrt(mean(abs(Pxyc),2)))
% loglog(F,sqrt(mean(Pxx,2)))
% loglog(F,sqrt(mean(Pyy,2)))
% loglog(F,sqrt(mean(abs(Pxy),2)))

xlabel('Hz')
ylabel('nT/\surd{Hz}')
legend('good1','good2','good3','respective')
%legend('Villa Cristina Cleaned','600m West Cleaned',...
%    'Cross Spectrum Cleaned','Villa Cristina','600m W','Cross Spectrum')

xlim([1 2e2])
ylim([1e-4 1e-2])






