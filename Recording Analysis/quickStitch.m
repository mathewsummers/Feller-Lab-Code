function quickStitch(varargin)
%Load and 'stitch' together several files, assumes of same type, e.g. all
%ve

dExps = cell(1,nargin);
spCtsExps = cell(1,nargin);
spTmsExps = cell(1,nargin);
stimExps = cell(1,nargin);

outNames = {'d';'spCts';'spTms';'stimConds';'ctSort';'tmSort'};

velocPlot = 0;
dirPlot = 0;

for i=1:nargin
    quickLoad(varargin{i},[],1);
    quickSpikes(d,si);
    fn = sprintf('stim%s.txt',varargin{i});
    stimInfo = load('-ASCII',fn);
    stimDirs = stimInfo(:,1);
    stimSpds = stimInfo(:,2);
    nDirs = numel(unique(stimDirs));
    nSpds = numel(unique(stimSpds));
    
    if (nDirs > 1 && nSpds > 1) || (nDirs > 1 && velocPlot) || (nSpds > 1 && dirPlot)
        error('Unsure which stim conditions to sort by; might be different between files.')
    elseif nDirs > 1
        stimConds = stimDirs;
        nConds = nDirs;
        dirPlot = 1;
    elseif nSpds > 1
        stimConds = stimSpds * .65;%convert from pixels to microns
        nConds = nSpds;
        velocPlot = 1;
    end
    
    nTrials = numel(spCts);
    nReps = floor(nTrials / nConds);
    tIndx = nConds*nReps;
    dExps{i} = d(:,1:tIndx);
    spCtsExps{i} = spCts(1:tIndx)';
    spTmsExps{i} = {spTms{1:tIndx}};
    stimExps{i} = stimConds(1:tIndx)';
end

d = [dExps{:}];
spCts = [spCtsExps{:}]';
spTms = [spTmsExps{:}];
stimConds = [stimExps{:}]';

ctSort = quickSort(spCts,stimConds);
tmSort = quickSort(spTms,stimConds);

outVars = {d, spCts, spTms, stimConds, ctSort, tmSort};

if velocPlot
    [~,prefIndx] = velocityTuning(ctSort,stimConds);
    outNames{end+1} = 'prefIndx';
    outVars{end+1} = prefIndx;
end

if dirPlot
    [~,prefDir,DSI] = dirTuning(ctSort,stimConds);
    [outNames{end+1:end+2}] = deal('prefDir','DSI');
    [outVars{end+1:end+2}] = deal(prefDir,DSI);
end


for j = 1:length(outNames)
    assignin('caller',outNames{j},outVars{j});
end

end
