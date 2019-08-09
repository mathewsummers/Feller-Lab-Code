function getDataTable(searchDate)
% Function to load the Data Table from a given experimental session, if it
% exists

dsgcDir = 'C:\Users\Mathew\Documents\MATLAB\Feller Lab\DSGC Recordings\';
searchDirName = sprintf('%s*',searchDate); %find directories that match input date

oldDir = cd(dsgcDir);
newDir = dir(searchDirName);
cd(newDir.name);

if isempty(newDir)
    cd(oldDir);
    error('Unable to find specified experiment folder.');
end

fn = sprintf('data table %s.mat',newDir.name(1:6));
if exist(fn,'file')
    dVar = load(fn);
    assignin('caller','dTable',dVar.dTable)
else
    cd(oldDir);
    error('Specified experiment folder does not contain a saved data table.');
end

cd(oldDir);

end