function plotDirTraces(stimDF,stimDirs,ROI,Fs)

if nargin < 4 || isempty(Fs)
    Fs = 1.48;
end

dFSort = quickSort(stimDF(:,:,ROI),stimDirs);

[nFrames,nReps,nDirs] = size(dFSort);
nTrials = nReps*nDirs;
uDirs = unique(stimDirs);
plotDF = reshape(dFSort,nFrames,nTrials);

tFrames = 1:nFrames;
tSec = (tFrames - 1)/Fs;

mindF = min(dFSort(:));
maxdF = max(dFSort(:));

xStart = .05;
xEnd = .95;
xEach = (xEnd - xStart)/nDirs;

yStart = .05;
yEnd = .95;
yEach = (yEnd - yStart)/nReps;

yLabelWidth = 1 - yEnd;

hF = figure;
%co = hsv(nTrials);
for i = 1:nTrials
    xInt = floor((i-1)/nReps);%mod(i-1,nDirs);
    yInt = mod(i-1,nReps) + 1;%floor((i-1)/nDirs) + 1;
    %cInt = mod(i,2) + 1;
    pos = [(xStart + xInt*xEach) (yEnd - yInt*yEach) xEach yEach];
    hA = axes('Units','Normalized','Position',pos,'XTick',[],'YTick',[],...
        'YLim',[mindF maxdF],'XLim',[tSec(1) tSec(end)],'NextPlot','replacechildren');
    plot(tSec,plotDF(:,i),'k','LineWidth',1.5)
end

hF.Children(end).YTick = [0 .2];
%hF.Children(end).YLabel.String = 'deltaF/F';

for j = 1:nDirs
    txtPos = [(xStart + (j-1)*xEach) yEnd xEach yLabelWidth];
    txtStr = num2str(uDirs(j));
    txt = uicontrol(hF,'Style','text','Units','Normalized','Position',txtPos,...
        'String',txtStr,'FontSize',12);
end
%hA.YAxisLocation = 'right';
%hA.YTick = [0 (maxdF - mindF)/2 ];

end
