%% Combine miniseed processed files

directory = '/data/procdata/detchar/env/Schumann/summer2016/NE-FIELD/MAT/';

files = dir(directory);

sorted = [files(:).datenum].';
[sorted, sorted] = sort(sorted);
sorted = {files(sorted).name}; % Cell array of names in order by datenum. 

% Collect the files we specifically want
dat33_list = {};
ind = 0;

for n = 1:length(sorted)
    file_name = sorted{n};
    %n
    if file_name(1) == '.'
        continue
    end
    
    if strcmp(file_name(1:5),'dat33')
        file_name
        m = load(strcat(directory, file_name));
        for k=1:1:length(m.dat33_list)
            if isempty(m.dat33_list{k}) == 0
                ind=ind+1;
                dat33_list{ind} = m.dat33_list{k};
            end
        end
    end
end

save_to = '/data/procdata/detchar/env/Schumann/summer2016/NEB/MAT_30/MERGE/';
save(strcat(save_to, 'dat33_list.mat'), 'dat33_list');


%%
load('/data/procdata/detchar/env/Schumann/summer2016/600W/MAT_25-26/MERGE/dat33_list.mat')
dat33_merge = [];

for q = 1:length(dat33_list)
    dat33 = dat33_list{q};
    dat33_merge = cat(1,dat33_merge,dat33);
end

save('/data/procdata/detchar/env/Schumann/summer2016/600W/MAT_25-26/MERGE/dat33_merge.mat','dat33_merge')
%%

%run /users/swinkels/deploy/MatlabVirgoTools/trunk/startup.m

%format longg

%time_merge = [];
%T = 10; %seconds per PSD point

% Local time when the data collection starts
%strt = lt2gps( '24/07/2015 16:00:00', 'dd/mm/yyyy HH:MM:SS' );
%strt = lt2gps( '29/06/2016 08:00:00', 'dd/mm/yyyy HH:MM:SS' );
%sizez = size(dat33_merge);
%time_merge = strt:1:strt + sizez(2);
%for n = 1:length(dat33_merge)
   % time_merge(n) = strt + (n-1)*T;
%end

%save('/data/procdata/detchar/env/Schumann/summer2016/NEB/MAT_30/MERGE/dat33_merge.mat','dat33_merge')
