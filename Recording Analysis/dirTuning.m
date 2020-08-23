function [hF, prefDir, DSI,vecLength,prefSpikes,nullSpikes] = dirTuning(ctSort,stimDirs,showLess,makeFig,rBounds)

if nargin<5 || isempty(rBounds)
    rFlag = false;
else
    rFlag = true;
end

if nargin<4 || isempty(makeFig)
    makeFig = 1;
end
if nargin<3 || isempty(showLess)
    showLess = 0;
end

ctMean = mean(ctSort,2);
ctSortPlot = [ctSort; ctSort(1,:)];
ctMeanPlot = [ctMean; ctMean(1,:)];

nReps = size(ctSort,2);

uDirs = unique(stimDirs); %potentially problematic way of doing things;
% if stimDirs is shifted in a non-uniform way (e.g. resets to 0 after passing 360)
% then ctSort will now be incorrectly indexed
uDirs = deg2rad(uDirs);

[x,y] = pol2cart(uDirs, ctMean / sum(ctMean));
prefDir = atan2d(sum(y),sum(x));
if prefDir < 0
    prefDir = prefDir + 360;
end
vecLength = sqrt(sum(x)^2 + sum(y)^2);

nDirs = length(uDirs);
incDirs = 360 / nDirs; %direction increments
prefIndx = round(prefDir / incDirs) + 1;
if prefIndx > nDirs
    prefIndx = 1;
end
nullIndx = prefIndx - (nDirs / 2);
if nullIndx < 1
    nullIndx = nullIndx + nDirs;
end
DSI = (ctMean(prefIndx) - ctMean(nullIndx) ) / (ctMean(prefIndx) + ctMean(nullIndx));

prefSpikes = ctMean(prefIndx);
nullSpikes = ctMean(nullIndx);

titleStr = sprintf('Pref Dir %3.1f DSI %4.2f Vec Length %4.2f',prefDir,DSI,vecLength);

uDirs = [uDirs; uDirs(1)];
uDirsPlot = repmat(uDirs,1,nReps);


if prefDir < 0
    prefDir = prefDir + 360;
end



%% Plot figure
if ~showLess
    if makeFig
        hF = figure;
    else
        hF = [];
    end
    
    %Set radial bounds
    pAx = polaraxes();
    
    plotChild = polarplot(uDirsPlot,ctSortPlot);
    set(plotChild(1:nReps),'LineWidth',1);
    
    hold on
    
    plotChild = polarplot(uDirs,ctMeanPlot,'k');
    set(plotChild(1),'LineWidth',2)
    
    %plotChild = compass(sum(x)*max(ctMean),sum(y)*max(ctMean),'k'); %think about this
    plotChild = polarplot(deg2rad([prefDir, prefDir]), [0 max(ctMean)*vecLength],'k');
    set(plotChild(1),'LineWidth',1.5)
    
    title(titleStr);
    if rFlag
        pAx.RLim = rBounds;
    end
    
else
    hF = [];
end
