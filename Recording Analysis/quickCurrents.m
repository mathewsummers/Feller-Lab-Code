function quickCurrents(stimNum)

quickLoad(stimNum);

Q = sum(d)*si*1e-6;
outNames = {'d', 'Q'};
outVars = {d, Q};

fn1 = sprintf('stim%s.txt',stimNum);
fn2 = sprintf('stim%s',stimNum);
contFunc = 0;
if exist(fn1,'file')
    
    
    stimInfo = load('-ASCII',fn1);
    
    stimDirs = stimInfo(:,1);
    try %terrible fix
    stimSpds = stimInfo(:,2);
    catch
        stimSpds = zeros(1,length(stimDirs));
    end
    
    nDirs = numel(unique(stimDirs));
    nSpds = numel(unique(stimSpds));
    contFunc = 1;
    
elseif exist(fn2,'file')
    load(fn2); %bad fix, revise later
    stimDirs = stimDirs';
    nDirs = numel(unique(stimDirs));
    nSpds = 1;
    contFunc = 1;
    
end

if contFunc
    if nDirs > 1 && nSpds > 1
        error('Unsure which stim conditions to sort by.')
    elseif nDirs > 1
        stimConds = stimDirs;
        outNames{end+1} = 'stimDirs';
        plotAxis = 'Directions (degrees)';
        plotTitle = 'Direction Tuning';
        velocPlot = 0;
        dirPlot = 1;
    elseif nSpds > 1
        stimConds = stimSpds * .65; %convert from pixels to microns
        outNames{end+1} = 'stimSpds';
        plotAxis = 'Speed (microns / sec)';
        plotTitle = 'Velocity Tuning';
        velocPlot = 1;
        dirPlot = 0;
    end
    outVars{end+1} = stimConds;
    
    qSort = quickSort(Q,stimConds);
    
    outNames{end+1} = 'qSort';
    outVars{end+1} = qSort;
    
    %     figure; plot(unique(stimConds),ctSort);
    %     hold on; plot(unique(stimConds),mean(ctSort,2),'k','LineWidth',2)
    %     ylabel('Total Spikes'); xlabel(plotAxis); title(plotTitle)
    
    if velocPlot
        [~,qDSI] = velocityTuning(qSort,stimConds);
        outNames{end+1} = 'qDSI';
        outVars{end+1} = qDSI;
    end
    
    if dirPlot
        [hF,prefDir,qDSI] = dirTuning(qSort,stimConds);
        [outNames{end+1:end+2}] = deal('prefDir','qDSI');
        [outVars{end+1:end+2}] = deal(prefDir,qDSI);
        hF.Children.XLabel.String = 'Total Charge Tuning';
    end
    
end

for i = 1:length(outNames)
    assignin('base',outNames{i},outVars{i});
end

