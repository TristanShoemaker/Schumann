%% Combine miniseed processed files

directory = '/data/procdata/detchar/env/Schumann/summer2016/2400N/MAT/';
save_to = '/data/procdata/detchar/env/Schumann/summer2016/2400N/MAT/MERGE/';

files = dir(directory);

sorted = [files(:).datenum].';
[sorted, sorted] = sort(sorted);
sorted = {files(sorted).name}; % Cell array of names in order by datenum. 

% Collect the files we specifically want
%PSD_list = {};
%PSD_list={};
PSD_list = {};
ind = 0;

for n = 1:length(sorted)
    file_name = sorted{n};
    %n
    if file_name(1) == '.'
        continue
    end
    
    if strcmp(file_name(1:3),'PSD')
        file_name
        m = load(strcat(directory, file_name));
        for k=1:1:length(m.PSD)
            if isempty(m.PSD{k}) == 0
                ind=ind+1;
                PSD_list{ind} = m.PSD{k};
            end
        end
    end
end


save(strcat(save_to, 'PSD_list.mat'), 'PSD_list');


%%

PSD_merge = [];

for q = 1:length(PSD_list)
    PSD = PSD_list{q};
    PSD_merge = cat(2,PSD_merge,PSD);
    %for p = 1:5
      %  PSD_merge = [PSD_merge PSD{p}];
    %end
end
save(strcat(save_to, 'PSD_merge.mat'),'PSD_merge')
%%

%addpath([getenv('FRROOT') ,'/matlab'])
%run /users/swinkels/deploy/MatlabVirgoTools/trunk/startup.m

%format longg

%time_merge = [];
%T = 10; %seconds per PSD point

% Local time when the data collection starts
%strt = lt2gps( '24/07/2015 16:00:00', 'dd/mm/yyyy HH:MM:SS' );
%strt = lt2gps( '29/06/2016 08:00:00', 'dd/mm/yyyy HH:MM:SS' );
%sizez = size(PSD_merge);
%time_merge = strt:1:strt + sizez(2);
%for n = 1:length(PSD_merge)
   % time_merge(n) = strt + (n-1)*T;
%end


