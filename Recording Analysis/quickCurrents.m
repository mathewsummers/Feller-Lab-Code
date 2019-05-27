function quickCurrents(stimNum,stimDate,exc,showLess,varargin)

if nargin < 4 || isempty(showLess)
    showLess = 0;
end

if nargin < 3 || isempty(exc)
    exc = 0; %not excitation
end

if nargin < 2 || isempty(stimDate)
    quickLoad(stimNum,[],showLess);
else
    newDir = sprintf('%s%s','C:\Users\Mathew\Documents\MATLAB\Feller Lab\DSGC Recordings\',stimDate);
    oldDir = cd(newDir); %necessary to change directories to load stim info
    quickLoad(stimNum,stimDate,showLess)
end

Q = sum(d)*si*1e-6;
if exc
    [pCur,tCur] = min(d);
    if pCur < 0
        pCur = abs(pCur);
        disp('Flipping sign of peak currents');
    else
        disp('Sign of peak current has not been flipped.');
    end
else
    [pCur,tCur] = max(d);
end
outNames = {'d', 'Q','pCur','tCur'};
outVars = {d, Q, pCur, tCur};

fn1 = sprintf('stim%s.txt',stimNum);
fn2 = sprintf('stim%s',stimNum);
contFunc = 0;
if exist(fn1,'file')
    
    
    stimInfo = load('-ASCII',fn1);
    
    stimDirs = stimInfo(:,1);
    try %terrible fix
        stimSpds = stimInfo(:,2);
        stimTFs = stimInfo(:,3);
    catch
        stimSpds = zeros(1,length(stimDirs));
        stimTFs = zeros(1,length(stimDirs));
    end
    
    nTFs = numel(unique(stimTFs));
    nDirs = numel(unique(stimDirs));
    nSpds = numel(unique(stimSpds));
    contFunc = 1;
    
elseif exist(fn2,'file')
    load(fn2); %bad fix, revise later
    stimDirs = stimDirs';
    nDirs = numel(unique(stimDirs));
    nSpds = 1;
    nTFs = 1;
    contFunc = 1;
    
end

if contFunc %if a stim file exists, continue processing
    if nDirs > 1 && nSpds > 1
        error('Unsure which stim conditions to sort by.')
    elseif nDirs > 1 && nTFs == 1 %sort by dirs
        stimConds = stimDirs;
        outNames{end+1} = 'stimDirs';
        plotAxis = 'Directions (degrees)';
        plotTitle = 'Direction Tuning';
        velocPlot = 0;
        dirPlot = 1;
    elseif nSpds > 1 %sort by speeds
        stimConds = stimSpds * .65; %convert from pixels to microns
        outNames{end+1} = 'stimSpds';
        plotAxis = 'Speed (microns / sec)';
        plotTitle = 'Velocity Tuning';
        velocPlot = 1;
        dirPlot = 0;
    elseif nTFs > 1 %sort by TFs, e.g. PN gratings
        negSpds = stimDirs > 180; %assume prefDir is the one less than 180 degrees, bad assumption
        stimTFs(negSpds) = -stimTFs(negSpds);
        stimConds = stimTFs .* stimSpds * .73;%0.73 since all vClamp gratings done post SOS changes
        outNames{end+1} = 'stimSpds';
        plotAxis = 'Speed (microns / sec)';
        plotTitle = 'Velocity Tuning';
        velocPlot = 1;
        dirPlot = 0;
        
    end
    outVars{end+1} = stimConds;
    
    qSort = quickSort(Q,stimConds);
    pSort = quickSort(pCur,stimConds);
    tSort = quickSort(tCur,stimConds);
    
    [outNames{end+1:end+3}] = deal('qSort','pSort','tSort');
    [outVars{end+1:end+3}] = deal(qSort,pSort,tSort);
    
    %     figure; plot(unique(stimConds),ctSort);
    %     hold on; plot(unique(stimConds),mean(ctSort,2),'k','LineWidth',2)
    %     ylabel('Total Spikes'); xlabel(plotAxis); title(plotTitle)
    
    if velocPlot
        [~,qDSI] = velocityTuning(qSort,stimConds,showLess);
        outNames{end+1} = 'qDSI';
        outVars{end+1} = qDSI;
    end
    
    if dirPlot
        [hF,qPref,qDSI] = dirTuning(qSort,stimConds,showLess);
        hF.Children.XLabel.String = 'Total Charge Tuning';
        [hF,pPref,pDSI] = dirTuning(pSort,stimConds,showLess);
        hF.Children.XLabel.String = 'Peak Current Tuning';
        [outNames{end+1:end+4}] = deal('qPref','qDSI','pPref','pDSI');
        [outVars{end+1:end+4}] = deal(qPref,qDSI,pPref,pDSI);
    end
    
end

if nargin < 5
    
    for i = 1:length(outNames)
        assignin('base',outNames{i},outVars{i});
    end
    
else
    for i = 1:length(varargin)
        assignin('base',varargin{i},eval(varargin{i}));
    end
    
end

if nargin > 1 && ~isempty(stimDate)
    cd(oldDir)
end
