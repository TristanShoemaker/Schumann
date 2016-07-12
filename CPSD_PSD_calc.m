
directory1 = '/data/procdata/detchar/env/Schumann/summer2016/WE-FIELD-N/MAT/MERGE/';
directory2 = '/data/procdata/detchar/env/Schumann/summer2016/WE-FIELD-S/MAT/MERGE/';
save_dir_CPSD = '/data/procdata/detchar/env/Schumann/summer2016/CPSD/WE-FIELD/';
save_dir_PSD1 = '/data/procdata/detchar/env/Schumann/summer2016/WE-FIELD-N/MAT/';
save_dir_PSD2 = '/data/procdata/detchar/env/Schumann/summer2016/WE-FIELD-S/MAT/';

chunks = 4;

load(strcat(directory1,'dat33_list.mat'))
dat1 = dat33_list;
clear dat33_list
load(strcat(directory2,'dat33_list.mat'))
dat2 = dat33_list;
clear dat33_list
len = length(dat1);


%%

T = 10;
Fs = 250;
NFFT = T * Fs;
WINDOW = hanning(NFFT);
CPSD = cell(1,chunks);
PSD1 = cell(1,chunks);
PSD2 = cell(1,chunks);

for n = 1:len
    chunk1 = dat1{n};
    chunk2 = dat2{n};
    local_n = mod(n, chunks);
    if local_n == 0
        local_n = chunks;
    end
    
    for k = 1:360
        ini = 1 + (k - 1) * 10 * Fs;
        fin = ini + 10 * Fs;
        [CPSD{local_n}(:,k), F] = cpsd(chunk1(ini:fin - 1),chunk2(ini:fin - 1), WINDOW, [], NFFT, Fs);
        [PSD1{local_n}(:,k), F] = pwelch(chunk1(ini:fin - 1), WINDOW, [], NFFT, Fs);
        [PSD2{local_n}(:,k), F] = pwelch(chunk2(ini:fin - 1), WINDOW, [], NFFT, Fs);

    end
    display(['Calculated: ' int2str(n) '/' int2str(len)])
       
    if mod(n, chunks) == 0
        save(strcat(save_dir_CPSD,'CPSD_',int2str(n / chunks),'.mat'),'CPSD','F')
        PSD = PSD1;
        save(strcat(save_dir_PSD1,'PSD_',int2str(n / chunks),'.mat'),'PSD','F')
        PSD = PSD2;
        save(strcat(save_dir_PSD2,'PSD_',int2str(n / chunks),'.mat'),'PSD','F')

        PSD = cell(1,chunks);
        CPSD = cell(1,chunks);
        PSD1 = cell(1,chunks);
        PSD2 = cell(1,chunks);
        
        display(strcat('Saved', {' '}, int2str(n), '/', int2str(len)))
    end
end


























