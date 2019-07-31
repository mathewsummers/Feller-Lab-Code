function saveDataTable(dTable,localTrue)
% Function to check that the semi-automatically prepared dTable matches the
% expected specifications before saving to the local directory. This is
% meant to ensure standardization of data tables between experimental
% sessions to allow for concatenation.

if nargin < 2 || isempty(localTrue)
    % Assume input dataTable is for a single experiment session, and thus
    % check that dates are identical before saving with exp date as part of
    % file name.
    localTrue = true;
end

%%% Establish supported categories to test
supportedStimTypes = categorical(["iv curve","flash","c steps pos","c steps neg",...
    "ds bars slow","ds bars fast","adj bars spds","short bars spds",...
    "wide grates spds","z stack"]);
supportedRecTypes = categorical(["c clamp","c attach","v clamp exc","v clamp inh","image"]);
supportedCellTypes = categorical(["ON","ONOFF","UNKNOWN"]);
supportedOrientations = categorical(["vl","vr","dl","dr","unoriented"]);

%%% Check that no new stim types are being introduced (e.g. due to typos)
uStimType = unique(dTable.Stim);
approvedStimType = any((uStimType == supportedStimTypes)');
if any(~approvedStimType)
    error('%s is an unrecognized stim type. \n',...
        uStimType(~approvedStimType));
end

%%% Check that no new recording types are being introduced
uRecordingType = unique(dTable.RecordingType);
approvedRecordingType = any((uRecordingType == supportedRecTypes)');
if any(~approvedRecordingType)
    error('%s is an unrecognized recording type. \n',...
        uRecordingType(~approvedRecordingType));
end

%%% Check that no new stim types are being introduced
uCellType = unique(dTable.CellType);
approvedCellType = any((uCellType == supportedCellTypes)');
if any(~approvedCellType)
    error('%s is an unrecognized cell type. \n',...
        uCellType(~approvedCellType));
end

%%% Check that no new orientations are being introduced
uOrientation = unique(dTable.Orientation);
approvedOrientation = any((uOrientation == supportedOrientations)');
if any(~approvedOrientation)
    error('%s is an unrecognized orientation. \n',...
        uOrientation(~approvedOrientation));
end

%%% Check that for a given Cell Number, there is only one associated
%%% CellID, CellType, Orientation
[uCellNumbers,~,uCellIndx] = unique(dTable.CellNumber);
for i = 1:numel(uCellNumbers)
    nCellIDs = unique(dTable.CellID(uCellIndx == i));
    if numel(nCellIDs) > 1
        error(['More than one global Cell ID is associated '...
            'with a given local Cell Number.']);
    end
    nCellTypes = unique(dTable.CellType(uCellIndx == i));
    if numel(nCellTypes) > 1
        error(['More than one Cell Type is associated with a given'...
            ' Cell ID.']);
    end
    nOrientations = unique(dTable.Orientation(uCellIndx == i));
    if numel(nOrientations) > 1
        error(['More than one Orientation is associated with a given'...
            ' Cell ID.']);
    end
end

%%% Save variable after successfully passing checks
if localTrue
    if numel(unique(dTable.Date)) > 1
        error(['More than one date present. If intentionally passing a'...
            'data table with more than one date, set the input flag' ...
            'localTrue to be false.']);
    else
        % One last check if being saved to correct directory - a failed
        % check will not throw an exception, but a warning.
        [~,dirName] = fileparts(pwd);
        if ~strcmpi(dTable.Date(1),dirName(1:6))
            warning(['Current directory and data table dates do not'...
                ' appear to match. Proceeding to save anyways.'])
        end
        
        fn = sprintf('data table %s.mat',dTable.Date(1));
        checkOverwrite(fn,dTable); %checks for overwrite, then saves.
       
    end
else
    fn = 'data table.mat';
    checkOverwrite(fn,dTable); %checks for overwrite, then saves.
end

end

function checkOverwrite(fn,dTable)
% Subroutine to check if the given filename already exists, then save.
% Prompts a dialogue box requesting permission to overwrite if given
% filename is already present - otherwise errors out.

if exist(fn,'file')
   warnStr = sprintf('A file by the name of ''%s'' already exists. Overwrite?',fn);
   resp = questdlg(warnStr,'Overwrite?','Yes','No','No');
   if strcmpi(resp,'Yes')
       fprintf('Overwriting %s with new data table.\n',fn);
       delete(fn)
       save(fn,'dTable');
   else
       error('%s already exists: new data table was not saved.',fn)
   end
else %if no other file of that name, save normally
    save(fn,'dTable');
end

end