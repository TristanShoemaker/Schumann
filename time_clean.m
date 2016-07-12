%%
%load('/data/procdata/detchar/env/Schumann/summer2016/600W/MAT_25-26/MERGE/P33_merge.mat')

%%
function [cleaned] = time_clean(data,tmin,tmax,p)
T = 0:1:length(data(1,:));
RMS = zeros(length(data(:,1)),1);

for i = 1:1251
    RMS(i) = bandRMS(sqrt(data(i,:)),T,tmin,tmax);
end

thresh= prctile(RMS,p);

% 
% figure
% H = histogram(RMS);
% hold on
% histogram(RMS(find((RMS > thresh_min) & (RMS < thresh_max))),'BinWidth',H.BinWidth)
% xlim([0 (H.BinWidth * 60)])
% xlabel('rms (nT/\surd{Hz})')
% ylabel('Counts')
cleaned = find(RMS < thresh);


