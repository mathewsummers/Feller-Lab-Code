function plotCellTraces(dF,thresh,color)
if nargin < 3 || isempty(color)
    color = [ 0.4660    0.6740    0.1880];
end
if nargin < 2 || isempty(thresh)
    thresh = .5;
end

Fs = 1.48;
[nFrames,nROIs] = size(dF);
tFrames = 1:nFrames;
tSec = (tFrames - 1)/Fs;

indxCells = find(any(abs(dF) > thresh));
nCells = numel(indxCells);


L = floor(sqrt(nCells));
W = ceil(nCells / L);

mindF = min(dF(:));
maxdF = max(dF(:));

xStart = .05;
xEnd = .95;
xEach = (xEnd - xStart)/W;

yStart = .05;
yEnd = .95;
yEach = (yEnd - yStart)/L;

hF = figure;
%co = hsv(nCells);
for i = 1:nCells
    xInt = mod(i-1,W);
    yInt = floor((i-1)/W) + 1;
    %cInt = mod(i,7) + 1;
    pos = [(xStart + xInt*xEach) (yEnd - yInt*yEach) xEach yEach];
    hA = axes('Units','Normalized','Position',pos,'XTick',[],'YTick',[],...
        'YLim',[mindF maxdF],'XLim',[tSec(1) tSec(end)],'NextPlot','replacechildren');
    plot(tSec,dF(:,indxCells(i)),'LineWidth',1.5,'Color',color)
end

end
