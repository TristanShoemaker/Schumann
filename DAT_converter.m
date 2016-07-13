%% This script computes Pxx and Pxy for all channels, across multiple files
% And saves the raw data
% One script to rule them all

tic
%% Input variables

% Channels:
% 1 - empty
% 2 - empty
% 3 - mag
% 4 - seis (z?)
% 5 - seis (y?)
% 6 - seis (x?)

% List of file name dates
dates = {};

%%

% Sensor calibration
calib_sensor_B = 10/2^(24)/0.8; % MFS-06 magnetometer, V/pT
calib_sensor_S = 10/2^(24)/753; % Trillium seismometer, V/(m/s)
%calib_sensor_A = 10/9.81; % accelerometer, V/(m/s/s),  10 V/g

% Length of files, run time in seconds
len = 3600; % s

% Psd parameters
T = 10; % s, averaging

chunks = 4; % save every few iterations

%% Collect the files we are interested in

% Where we want to save our data
save_to = '/data/procdata/detchar/env/Schumann/summer2016/VC1/MAT_25-26/';

% Directory information
top_directory = '/data/procdata/detchar/env/Schumann/summer2016/VC1/';
sub_folder = {'25/','26/'};
files_mat = {};
files = {};

% Pull files info from the directories
for n = 1:length(sub_folder)
    file_n = dir(strcat(top_directory, sub_folder{n}));
    [file_n.sub]=deal(sub_folder{n});
    files_mat = vertcat(files_mat, file_n);
end

%%

for n = 1:length(files_mat)
    day = files_mat{n};
    for m = 1:length(day)
        files = vertcat(files, day(m));
    end
end

% Collect the files we specifically want
file_list = {};
for n = 1:length(files)
    file_name = files{n}.name;
    if file_name(1) == 'X'
        file_list{end+1} = files{n};
    end
end

nfiles = length(file_list);

%%

% Raw data
dat44_list = cell(1, chunks);
dat55_list = cell(1, chunks);
dat66_list = cell(1, chunks);
dat33_list = cell(1, chunks);
t_list = cell(1, chunks);

%% Grab our Psd for each file

for n = 1:length(file_list)
    
    % Picks a file
    a_file = file_list{n}.name;
    sub_folder = file_list{n}.sub;
    
    % Creates a matlab readable format
    [ X, I ] = rdmseed(strcat(top_directory,sub_folder, a_file));
    Fs = X.SampleRate; % Hz
    
    % Raw data
    dat44 = cat(1,X(I(4).XBlockIndex).d); %seis z
    dat55 = cat(1,X(I(5).XBlockIndex).d); %seis y
    dat66 = cat(1,X(I(6).XBlockIndex).d); %seis x
    dat33 = cat(1,X(I(3).XBlockIndex).d); %magnetometer
    t = cat(1,X(I(1).XBlockIndex).t);
    
    % Gets the times in order
    date = {};
    first = datevec(t(1));
    last = datevec(t(end));
    for j = 1:6
        date{end+1} = int2str(first(j));
    end
    for j = 1:6
        date{end+1} = int2str(last(j));
    end
    
    % Convert from counts to volts then to pT (B) or m/s/s (A) or m/s (S)
    dat44 = (dat44.*(calib_sensor_S));
    dat55 = (dat55.*(calib_sensor_S));
    dat66 = (dat66.*(calib_sensor_S));
    dat33 = (dat33.*(calib_sensor_B));
    

    local_n = mod(n, chunks);
    if local_n == 0
        local_n = chunks;
    end
    
    % Add to raw data
    dat44_list{local_n} = dat44;
    dat55_list{local_n} = dat55;
    dat66_list{local_n} = dat66;
    dat33_list{local_n} = dat33;
    t_list{local_n} = t;
    
    % date
    dates{local_n} = date;
    
    %%
    
    % Periodic save
    if mod(n, chunks) == 0 % Every five iterations
        save(strcat(save_to, 'constants.mat'), 'dates', 'calib_sensor_B', 'calib_sensor_S');

        save(strcat(save_to, 'dat44_', int2str(n/chunks), '.mat'), 'dat44_list');
        save(strcat(save_to, 'dat55_', int2str(n/chunks), '.mat'), 'dat55_list');
        save(strcat(save_to, 'dat66_', int2str(n/chunks), '.mat'), 'dat66_list');
        save(strcat(save_to, 'dat33_', int2str(n/chunks), '.mat'), 'dat33_list');
        save(strcat(save_to, 'times_', int2str(n/chunks), '.mat'), 't_list');

        % Raw data
        dat44_list = cell(1, chunks);
        dat55_list = cell(1, chunks);
        dat66_list = cell(1, chunks);
        dat33_list = cell(1, chunks);
        t_list = cell(1, chunks);
        
        display(strcat('Saved', {' '}, int2str(n), '/', int2str(length(file_list))))
    end

    % Progress indication
    display(strcat('Processed', {' '}, int2str(n), '/', int2str(length(file_list))))

end

if mod(n, chunks) ~= 0 % Final save if n ~= 5k (k is an integer)
    save(strcat(save_to, 'constants.mat'), 'F', 'dates', 'T', 'FSb', 'calib_sensor_B', 'calib_sensor_S');

    save(strcat(save_to, 'dat44_final.mat'), 'dat44_list');
    save(strcat(save_to, 'dat55_final.mat'), 'dat55_list');
    save(strcat(save_to, 'dat66_final.mat'), 'dat66_list');
    save(strcat(save_to, 'dat33_final.mat'), 'dat33_list');
    save(strcat(save_to, 'times_final.mat'), 't_list');
    
    display(strcat('Saved', {' '}, int2str(n), '/', int2str(length(file_list))))
end


toc