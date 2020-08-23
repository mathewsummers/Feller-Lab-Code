function dTableLoad = loadDataTables(varargin)
% Function to quickly load data table indexing file and then sort through
% for experiments matching specified input parameters.

% Load full data table, and categories supported for saving those data
% tables (saveDataTable uses same .mat file)
dTableLoad = searchDataTables(true);
load('dTable Supported Categories.mat');

% Assemble list of non-constrained categories.
expGenotype = unique(dTableLoad.Genotype);
expDates = unique(dTableLoad.Date);
expCellIDs = unique(dTableLoad.CellID);
expSex =  unique(dTableLoad.Sex);
expDrugs = unique(dTableLoad.Drugs);

% For each input argument, go through supported categories and other
% parameters checking to see if any categorizations match the input
% parameters. Then select for those data table entries which match the
% loadExps input.
for i = 1:nargin
    % Search for fields matching supported data categories
    if any(varargin{i} == supportedCellTypes)
        dTableLoad = dTableLoad(dTableLoad.CellType == varargin{i},:);
        fprintf('%i recordings matching cell type %s\n',size(dTableLoad,1),varargin{i});
        
    elseif any(varargin{i} == supportedRecTypes)
        dTableLoad = dTableLoad(dTableLoad.RecordingType == varargin{i},:);
        fprintf('%i recordings matching recording type %s\n',size(dTableLoad,1),varargin{i});
        
    elseif any(varargin{i} == supportedStimTypes)
        dTableLoad = dTableLoad(dTableLoad.Stim == varargin{i},:);
        fprintf('%i recordings matching stim type %s\n',size(dTableLoad,1),varargin{i});
        
    elseif any(varargin{i} == supportedOrientations)
        dTableLoad = dTableLoad(dTableLoad.Orientation == varargin{i},:);
        fprintf('%i recordings matching %s orientation\n',size(dTableLoad,1),varargin{i});
        
    elseif any(varargin{i} == supportedRig)
        dTableLoad = dTableLoad(dTableLoad.Rig == varargin{i},:);
        fprintf('%i recordings matching rig %s\n',size(dTableLoad,1),varargin{i});
    
    % Check other parameters not specified by 'dTable Supported Categories'
    elseif any(varargin{i} == expGenotype)
        dTableLoad = dTableLoad(dTableLoad.Genotype == varargin{i},:);
        fprintf('%i recordings matching genotype %s\n',size(dTableLoad,1),varargin{i});
        
    elseif any(varargin{i} == expDates)
        dTableLoad = dTableLoad(dTableLoad.Date == varargin{i},:);
        fprintf('%i recordings matching date %s\n',size(dTableLoad,1),varargin{i});
    
    elseif any(varargin{i} == expCellIDs)
        dTableLoad = dTableLoad(dTableLoad.CellID == varargin{i},:);
        fprintf('%i recordings matching cell ID %s\n',size(dTableLoad,1),varargin{i});
        
    elseif any(varargin{i} == expSex)
        dTableLoad = dTableLoad(dTableLoad.Sex == varargin{i},:);
        fprintf('%i recordings matching sex %s\n',size(dTableLoad,1),varargin{i});
        
    elseif any(varargin{i} == expDrugs)
        dTableLoad = dTableLoad(dTableLoad.Drugs == varargin{i},:);
        fprintf('%i recordings matching drugs %s\n',size(dTableLoad,1),varargin{i});
        
    else
        fprintf('%s is not a recognized data category.\n',varargin{i});
    end

    if isempty(dTableLoad)
        fprintf('No indexed recordings match the specified inputs.')        
        return
    end
end

end