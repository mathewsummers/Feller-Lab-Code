function [dTableFull,searchResults] = searchDataTables(compileTables,printFolders)
% Function to search through DSGC Recording folders and find those which
% have a 'data table' organizational array. Optional flags to print which
% folders contain these arrays, and to compile these into a single table.

if nargin < 2 || isempty(printFolders)
    printFolders = false;
end

if nargin < 1 || isempty(compileTables)
    compileTables = false;
    dTableFull = [];
end

dsgcDir = 'C:\Users\Mathew\Documents\MATLAB\Feller Lab\DSGC Recordings';
oldDir = cd(dsgcDir);

searchDir = fullfile(dsgcDir,'**','data table*');
searchResults = dir(searchDir);

if printFolders
    fprintf('Found data tables in:\n')
    for i = 1:numel(searchResults)
        [~,fn,~] = fileparts(searchResults(i).folder);
        fprintf('\t%s\n',fn);
    end
end

if compileTables
    dTableFull = [];
    for j = 1:numel(searchResults)
        cd(searchResults(j).folder);
        load(searchResults(j).name);
        dTableFull = [dTableFull; dTable]; %might become an issue
        cd(dsgcDir);
    end
end

cd(oldDir);
end