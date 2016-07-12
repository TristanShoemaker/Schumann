%% Combine miniseed processed files

directory = '/data/procdata/detchar/env/Schumann/summer2016/WE-FIELD-N/MA/';
save_to = '/data/procdata/detchar/env/Schumann/summer2016/WE-FIELD-N/MAT/MERGE/';

files = dir(directory);

sorted = [files(:).datenum].';
[sorted, sorted] = sort(sorted);
sorted = {files(sorted).name}; % Cell array of names in order by datenum. 

% Collect the files we specifically want
times_list = {};
ind = 0;

for n = 1:length(sorted)
    file_name = sorted{n};
    %n
    if file_name(1) == '.'
        continue
    end
    
    if strcmp(file_name(1:5),'times')
        file_name
        m = load(strcat(directory, file_name));
        for k=1:1:length(m.t_list)
            if isempty(m.t_list{k}) == 0
                ind=ind+1;
                times_list{ind} = m.t_list{k};
            end
        end
    end
end


save(strcat(save_to, 'times_list.mat'), 'times_list');


%%
%load(strcat(save_to, 'times_list.mat'))
times_merge = datetime(2016,07,08,10,00,01):seconds(10):datetime(2016,07,09,14,00,00);


save(strcat(save_to, 'times_merge.mat'),'times_merge')

%%
%run /users/swinkels/deploy/MatlabVirgoTools/trunk/startup.m

%format longg

%times_merge = [];
%T = 10; %seconds per PSD point

% Local times when the data collection starts
%strt = lt2gps( '24/07/2015 16:00:00', 'dd/mm/yyyy HH:MM:SS' );
%strt = lt2gps( '29/06/2016 08:00:00', 'dd/mm/yyyy HH:MM:SS' );
%sizez = size(times_merge);
%times_merge = strt:1:strt + sizez(2);
%for n = 1:length(times_merge)
   % times_merge(n) = strt + (n-1)*T;
%end

%save('/data/procdata/detchar/env/Schumann/summer2016/NEB/MAT_30/MERGE/times_merge.mat','times_merge')
