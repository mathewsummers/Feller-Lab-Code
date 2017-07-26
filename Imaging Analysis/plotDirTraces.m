function plotDirTraces(dFSort,stimDirs,Fs)

if nargin < 3 || isempty(Fs)
    Fs = 1.48;
end

[nFrames,nReps,nDirs] = size(dFSort);

if nargin < 2 || isempty(stimDirs)
    uDirs = 0:(360/nDirs):(360-360/nDirs);
else
    uDirs = unique(stimDirs);
    assert(numel(uDirs) == nDirs,'Input number of stim conditions does not match sorted dF inputs');
end

nTrials = nReps*nDirs;
plotDF = reshape(dFSort,nFrames,nTrials);

% % [nFrames,nTrials,nReps] = size(dFSort); %Implementation if not sorted
% prior to input
% % uDirs = unique(uDirs);
% % nuDirs = numel(uDirs);
% % nReps = nTrials / nuDirs;

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
