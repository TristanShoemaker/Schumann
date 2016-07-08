%%
%load('/data/procdata/detchar/env/Schumann/summer2016/600W/MAT_25-26/MERGE/P33_merge.mat')

%%
function [cleaned] = clean(data,fmin,fmax,pmin,pmax)
F = 0:0.1:125;
RMS = zeros(length(data),1);

for i = 1:length(data)
    RMS(i) = bandRMS(sqrt(data(:,i)),F,fmin,fmax);
end

thresh_min = prctile(RMS,pmin);
thresh_max = prctile(RMS,pmax);

% figure
% H = histogram(RMS);
% hold on
% histogram(RMS(find((RMS > thresh_min) & (RMS < thresh_max))),'BinWidth',H.BinWidth)
% xlim([0 (H.BinWidth * 60)])
% xlabel('rms (nT/\surd{Hz})')
% ylabel('Counts')
cleaned = find((RMS > thresh_min) & (RMS < thresh_max));


