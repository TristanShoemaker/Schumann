files = dir('/data/procdata/detchar/env/Schumann/summer2016/VCdata1/PSD*.mat');
for i = 1:length(files)
    origName = files(i).name;
    newName = strrep(origName,'PSD_23-27','')
    movefile(origName,newName)
end
        