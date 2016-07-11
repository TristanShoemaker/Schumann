%% Combine miniseed processed files

directory = '/data/procdata/detchar/env/Schumann/summer2016/CPSD/VC2_NEB/';
save_to = '/data/procdata/detchar/env/Schumann/summer2016/CPSD/VC2_NEB/MERGE/';

files = dir(directory);

sorted = [files(:).datenum].';
[sorted, sorted] = sort(sorted);
sorted = {files(sorted).name}; % Cell array of names in order by datenum. 

% Collect the files we specifically want
%CPSD_list = {};
%CPSD_list={};
CPSD_list = {};
ind = 0;

for n = 1:length(sorted)
    file_name = sorted{n};
    %n
    if file_name(1) == '.'
        continue
    end
    
    if strcmp(file_name(1:4),'CPSD')
        file_name
        m = load(strcat(directory, file_name));
        for k=1:1:length(m.CPSD)
            if isempty(m.CPSD{k}) == 0
                ind=ind+1;
                CPSD_list{ind} = m.CPSD{k};
            end
        end
    end
end


save(strcat(save_to, 'CPSD_list.mat'), 'CPSD_list');


%%

CPSD_merge = [];

for q = 1:length(CPSD_list)
    CPSD = CPSD_list{q};
    CPSD_merge = cat(2,CPSD_merge,CPSD);
    %for p = 1:5
      %  CPSD_merge = [CPSD_merge CPSD{p}];
    %end
end
save(strcat(save_to, 'CPSD_merge.mat'),'CPSD_merge')
%%

%addpath([getenv('FRROOT') ,'/matlab'])
%run /users/swinkels/deploy/MatlabVirgoTools/trunk/startup.m

%format longg

%time_merge = [];
%T = 10; %seconds per PSD point

% Local time when the data collection starts
%strt = lt2gps( '24/07/2015 16:00:00', 'dd/mm/yyyy HH:MM:SS' );
%strt = lt2gps( '29/06/2016 08:00:00', 'dd/mm/yyyy HH:MM:SS' );
%sizez = size(CPSD_merge);
%time_merge = strt:1:strt + sizez(2);
%for n = 1:length(CPSD_merge)
   % time_merge(n) = strt + (n-1)*T;
%end


