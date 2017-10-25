function quickData(stimNum,stimDate,showLess,varargin)

if nargin<3 || isempty(showLess)
    showLess = 0;
end

if nargin<2 || isempty(stimDate)
    quickLoad(stimNum);
else
    %     if strcmp(stimDate(3),'0') %account for clampex's peculiar naming conventions
    %         stimDate = [stimDate(1:2) stimDate(4:end)];
    %     else
    %         stimDate = stimDate;
    %     end
    newDir = sprintf('%s%s','C:\Users\Mathew\Documents\MATLAB\Feller Lab\DSGC Recordings\',stimDate);
    oldDir = cd(newDir);
    if showLess
        quickLoad(stimNum,stimDate,1)
    else
        quickLoad(stimNum,stimDate)
    end
end

quickSpikes(d,si);

outNames = {'d', 'spCts', 'spTms'};
outVars = {d, spCts, spTms};

fn1 = sprintf('stim%s.txt',stimNum);
fn2 = sprintf('stim%s',stimNum);
contFunc = 0; %flag to continue function later (messy implementation rn)

if exist(fn1,'file')
    
    
    stimInfo = load('-ASCII',fn1);
    
    stimDirs = stimInfo(:,1);
    
    [~,nSettings] = size(stimInfo); %might need to check if some stim files have 2 cols but not 3
    if nSettings >= 3
        stimSpds = stimInfo(:,2);
        tempFreq = stimInfo(:,3);
    else
        stimSpds = zeros(1,length(stimDirs));
        tempFreq = zeros(1,length(stimDirs));
    end
    
    nDirs = numel(unique(stimDirs));
    nSpds = numel(unique(stimSpds));
    nTF = numel(unique(tempFreq));
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
    elseif nTF > 1
        negSpds = stimDirs > 180; %assume prefDir is the one less than 180 degrees, bad assumption
        tempFreq(negSpds) = -tempFreq(negSpds);
        stimConds = tempFreq .* stimSpds;
        outNames{end+1} = 'stimSpds';
        plotAxis = 'Speed (microns / sec)';
        plotTitle = 'Velocity Tuning';
        velocPlot = 1;
        dirPlot = 0;
    end
    outVars{end+1} = stimConds;
    
    ctSort = quickSort(spCts,stimConds);
    tmSort = quickSort(spTms,stimConds);
    
    [outNames{end+1:end+2}] = deal('ctSort','tmSort');
    [outVars{end+1:end+2}] = deal(ctSort,tmSort);
    
    %     figure; plot(unique(stimConds),ctSort);
    %     hold on; plot(unique(stimConds),mean(ctSort,2),'k','LineWidth',2)
    %     ylabel('Total Spikes'); xlabel(plotAxis); title(plotTitle)
    
    if velocPlot
        if ~showLess
            [~,spikeDSI] = velocityTuning(ctSort,stimConds);
        else
            [~,spikeDSI] = velocityTuning(ctSort,stimConds,1);
        end
        outNames{end+1} = 'spikeDSI';
        outVars{end+1} = spikeDSI;
    end
    
    if dirPlot
        if ~showLess
            [hF,prefDir,spikeDSI,vecLength,prefSpikes,nullSpikes] = dirTuning(ctSort,stimConds);
        else
            [hF,prefDir,spikeDSI,vecLength,prefSpikes,nullSpikes] = dirTuning(ctSort,stimConds,1);
        end
        [outNames{end+1:end+2}] = deal('prefDir','spikeDSI');
        [outVars{end+1:end+2}] = deal(prefDir,spikeDSI);
        hF.Children.XLabel.String = 'Total Spike Count Tuning';
    end
    
end

if exist('stimConds','var');%clean up after giving lab meeting
    nSecs = (length(d) / 1e4);
    [~,nReps] = size(tmSort);
    plotConds = repmat(unique(stimConds),1,nReps);
    if ~showLess
        hF = rasterPlot(tmSort',nSecs,plotConds');
        
        a = ctSort'; %bad fix
        a = a(:);
        a = cumsum(a);
        a = a(end) - a;
        uConds = round(unique(stimConds));
        nConds = numel(uConds);
        for k = 1:nConds
            set(hF.Children(1).Children(a(1+(k-1)*nReps)),'DisplayName',num2str(uConds(k)));
        end
        legend(hF.Children(1).Children(a(1:nReps:end)),'Location','BestOutside');
    end
    [nPts,nTrials] = size(d);
    tEnd = nPts / 1e4;
    maxFreq = zeros(1,nTrials);
    firstSpike = zeros(1,nTrials);
    
    L = floor(sqrt(nTrials));
    W = ceil(nTrials / L);
    if ~showLess
        hF= figure;
        subplot(L,W,1);
        
        for n=1:nTrials
            subplot(L,W,n);
            maxFreq(n) = testFreq(spTms{n},tEnd);
            if ~isempty(spTms{n})
                firstSpike(n) = spTms{n}(1);
            else
                firstSpike(n) = NaN;
            end
        end
        
        set(hF.Children,'YLim',[0 ceil(max(maxFreq*.1))*10],'XLim',[0 tEnd]);
    else
        
        for n=1:nTrials
            maxFreq(n) = testFreq(spTms{n},tEnd,1);
            if ~isempty(spTms{n})
                firstSpike(n) = spTms{n}(1);
            else
                firstSpike(n) = NaN;
            end
        end
    end
    hzSort = quickSort(maxFreq,stimConds);
    fsSort = quickSort(firstSpike,stimConds); %first spike sort
    
    [outNames{end+1:end+4}] = deal('maxFreq','hzSort','firstSpike','fsSort');
    [outVars{end+1:end+4}] = deal(maxFreq,hzSort,firstSpike,fsSort);
    
    if velocPlot
        [hF,hzDSI] = velocityTuning(hzSort,stimConds);
        outNames{end+1} = 'hzDSI';
        outVars{end+1} = hzDSI;
        hF.Children(2).YLabel.String = 'Peak Firing (Hz)';
        if ~showLess
            figure;
            plotStims = unique(stimConds);
            indx1 = numel(find(plotStims < 0));
            plotStims = abs(plotStims);
            a = plot(plotStims(1:indx1),fsSort(1:indx1,:),'.r','MarkerSize',16);
            hold on
            b = plot(plotStims(indx1 + 1:end),fsSort(indx1+1:end,:),'.b','MarkerSize',16);
            xlabel(plotAxis); ylabel('Time (sec)'); title('Latency of First Spike')
            legend([a(1) b(1)],'Null','Pref','Location','SouthEast');
            ylim([(min(firstSpike) - .15),(max(firstSpike + .15))])
            grid on
        end
    end
    
    if dirPlot
        if ~showLess
            [hF,~,hzDSI,~,~] = dirTuning(hzSort,stimConds);
        else
            [hF,~,hzDSI,~,~] = dirTuning(hzSort,stimConds,1);
        end
        [outNames{end+1}] = deal('hzDSI');
        [outVars{end+1}] = deal(hzDSI);
        hF.Children.XLabel.String = 'Peak Firing (Hz) Tuning';
        if ~showLess
            figure;
            plot(stimConds,firstSpike,'.','MarkerSize',16);
            xlabel(plotAxis); ylabel('Time (sec)'); title('Latency of First Spike')
            ylim([(min(firstSpike) - .15),(max(firstSpike + .15))])
            grid on
        end
    end
    
    
    
    
end

if nargin>1 && ~isempty(stimDate)
    cd(oldDir)
end

if nargin < 4
    
    for i = 1:length(outNames)
        assignin('base',outNames{i},outVars{i});
    end
    
else
    for i = 1:length(varargin)
        assignin('base',varargin{i},eval(varargin{i}));
    end
    
end

end