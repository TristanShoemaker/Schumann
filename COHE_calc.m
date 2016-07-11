load('/data/procdata/detchar/env/Schumann/summer2016/CPSD/VC2_NEB/MERGE/CPSD_merge.mat')
Pxy = CPSD_merge;
clear CPSD_merge
load('/data/procdata/detchar/env/Schumann/summer2016/VC2/MAT_30/MERGE/PSD_merge.mat')
Pxx = PSD_merge;
clear PSD_merge
load('/data/procdata/detchar/env/Schumann/summer2016/NEB/MAT_30/MERGE/PSD_merge.mat')
Pyy = PSD_merge;
clear PSD_merge

F = 0:0.1:125;
T = 1:1:8640;
%%
fmin = 11;
fmax = 17;
gipmin = 1;
pmax = 10;

%good1 = clean(sqrt(abs(Pxy)),fmin,fmax,pmin,pmax);
%good2 = clean(sqrt(Pxx),fmin,fmax,pmin,pmax);
%good3 = clean(sqrt(Pyy),fmin,fmax,pmin,pmax);

time_good1 = time_clean(sqrt(Pxx),800,1600,98);
%time_good2 = time_clean(sqrt(Pxx),800,1600,95);
%time_good3 = time_clean(sqrt(Pyy),800,1600,95);

Pxyc = abs(Pxy(time_good1,good1));
Pxxc = abs(Pxx(time_good1,good1));
Pyyc = abs(Pyy(time_good1,good1));
% Pxyc = abs(Pxy(:,good1));
% Pxxc = abs(Pxx(:,good1));
% Pyyc = abs(Pyy(:,good1));
%%
cohe = abs(mean(Pxyc,2)).^2./(mean(Pxxc,2))./(mean(Pyyc,2));

figure(4)
semilogx(F(time_good1),sqrt(cohe),'LineWidth',1)
legend('not time cleaned','time cleaned')
xlabel('Hz')
ylabel('Coherence')
hold on
grid on
xlim([3 60])

%%
figure (5)
colormap bone
subplot(2,1,1)
imagesc(T,F,log10(sqrt(abs(Pxx))))   
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
imagesc(T(good1),F(time_good1),log10(sqrt(abs(Pxxc))))
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
%loglog(F,sqrt(mean(Pxxc,2)))
%hold on

%loglog(F,sqrt(mean(Pyyc,2)))
loglog(F(time_good1),sqrt(mean(abs(Pxyc),2)))
% loglog(F,sqrt(mean(Pxx,2)))
% loglog(F,sqrt(mean(Pyy,2)))
% loglog(F,sqrt(mean(abs(Pxy),2)))
grid on
hold on
xlabel('Hz')
ylabel('nT/\surd{Hz}')
legend('not time cleaned','time cleaned')
%legend('Villa Cristina Cleaned','600m West Cleaned',...
%    'Cross Spectrum Cleaned','Villa Cristina','600m W','Cross Spectrum')

xlim([5 150])
ylim([1e-4 1e-2])






