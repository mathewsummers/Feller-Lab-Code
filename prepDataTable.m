function dTable = prepDataTable(rec,age,sex,cellIndices,cellType,orientation)
% Semi-automatically prepares a data table for a given day of experiments,
% intended to be concatenated across sessions for a comprehensive list of
% performed recordings.

tVarNames = {'Date',    'AcquisitionNumber','RecordingType','Stim',         'CellNumber',   'CellID',   'CellType',     'Orientation',  'Age',      'Sex',          'Genotype',     'Drugs',        'Rig',          'Notes',    'Skeptical'};
tVarTypes = {'string',  'string',           'categorical',  'categorical',  'uint16',       'string',   'categorical',  'categorical',  'uint16',   'categorical',  'categorical',  'categorical',  'categorical',  'string',   'logical'};
nCols = numel(tVarNames);

%%% Determine number of files in directory, then initialize table
abfFiles = dir('*.abf');
tifFiles = dir('*.tif');
nExps = numel(abfFiles) + numel(tifFiles);
dTable = table('Size',[nExps nCols],'VariableTypes',tVarTypes,'VariableNames',tVarNames);

%%% Default values
dTable.Genotype(:) = 'Hoxd10';
dTable.Drugs(:) = 'none';
dTable.Rig(:) = 'SOS';

%%% Input values
dTable.RecordingType(:) = rec;
dTable.Age(:) = age;
dTable.Sex(:) = sex;

%%% Determine directory to set date
[~,dirName] = fileparts(pwd);
assert(~isnan(str2double(dirName(1:6))),'First 6 digits of DSGC directory should be yy/mm/dd');
dTable.Date(:) = dirName(1:6);

%%% Assign acquisition numbers (.tif files should be manually renamed)
for j = 1:nExps
    dTable.AcquisitionNumber(j) = sprintf('%03d',j-1);
end

%%% Assign cell IDs, types, and orientations based on input indices
nCells = numel(cellIndices);
cellIndices = [cellIndices (nExps+1)]; %append nExps on end to cover full range of experiments
for i = 1:nCells
    assignID = sprintf('%s%03d',dirName(1:6),i);
    expIndices = cellIndices(i):(cellIndices(i+1)-1);
    dTable.CellNumber(expIndices) = i;
    dTable.CellID(expIndices) = assignID;
    dTable.CellType(expIndices) = cellType{i};
    dTable.Orientation(expIndices) = orientation{i};
end

end