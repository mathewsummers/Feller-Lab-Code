function dsPlotData(d,stimDirs,ctSort,color,traceSet,degOffset,si)
if nargin<7 || isempty(si)
    si = 1e-4; %si in seconds, 1/Fs
end
if nargin<6 || isempty(degOffset)
    degOffset = 0;
end
if nargin<5 || isempty(traceSet)
    traceSet = 1;
end
if nargin<4 || isempty(color)
    color = [0 0 0];
end

pH = 7;
pW = 7;
pSpace = 1;
rIndx = pH - pSpace;
cIndx = pW - pSpace;
fig1 = sub2ind([pH pW],[(pSpace+1) cIndx (pSpace+1) cIndx],[(pSpace+1) (pSpace+1) rIndx rIndx]);

%%
traceIndx = (8*(traceSet - 1) + 1):(8*traceSet);
%assumes 8 dirs, careful here. not an issue for original data being used
%with dsPlotData in NeuroRetreat prep
[uDirs,dIndx] = unique(stimDirs(traceIndx));
uDirs = deg2rad(uDirs);
dIndx = dIndx + (8*(traceSet-1)); %adjust for stimDirs always being a 1:8 set
dShift = -1 * round(degOffset / (360/8)); %again assuming 8 dirs
dIndx = circshift(dIndx,dShift);


ctMean = mean(ctSort,2);
ctNormSum = ctMean / sum(ctMean);
ctNormMax = ctMean / max(ctMean);
ctPlot = [ctNormMax; ctNormMax(1)];

[x,y] = pol2cart(uDirs, ctNormSum);
prefDir = atan2(sum(y),sum(x));
if prefDir < 0
    prefDir = prefDir + 2*pi;
end
dirList = [uDirs; 2*pi];
[dist1,indx1] = min(abs(prefDir - dirList));
dirList(indx1) = [];
[dist2,indx2] = min(abs(prefDir - dirList));
if indx1 == indx2
    indx2 = indx2 + 1;
end

uDirsPlot = [uDirs; uDirs(1)];
radOffset = deg2rad(degOffset);
uDirsPlot = bsxfun(@minus,uDirsPlot,radOffset);

figure;
subplot(pH,pW,fig1)
plotChild = polar(uDirsPlot,ctPlot);
set(plotChild(1),'LineWidth',2,'Color',color);
hold on
%(ctPlot(indx2) - ctPlot(1))/2;
% plotR = (dist1*ctPlot(indx1) + dist2*ctPlot(indx2)) / (dist1 + dist2);
[x1, y1] = pol2cart(uDirsPlot([indx1 indx2]),ctPlot([indx1 indx2]));

x2 = (dist1*x1(2) + dist2*x1(1))/(dist1 + dist2);
y2 = (dist1*y1(2) + dist2*y1(1))/(dist1 + dist2);
%plotChild = compass(x2,y2); %%%Draws lines to edge of tuning circle

%plotChild = polar([0 prefDir],[0 plotR]);

[x3,y3] = pol2cart(uDirs-radOffset, ctNormSum);
plotChild = compass(sum(x3),sum(y3)); %%%Draws line proportional to vec sum
set(plotChild(1),'LineWidth',1.5,'Color',color)
% 
% scaleFactor = sqrt(sum(x)^2 + sum(y)^2);
% plot([0 sum(x)]/scaleFactor,[0 sum(y)]/scaleFactor,'LineWidth',2,'Color',color);
%%
%degrees: 0 45 90 135 180 225 270 315
halfW = mean([1 pW]);
plotSpot = [pH*halfW; pW; halfW; 1; pH*(halfW - 1) + 1; pH*(pW - 1) + 1; pH*(pW - 1) + halfW; pH*pW];

yMin = min(min(d(:,dIndx)));
yMax = max(max(d(:,dIndx)));
[nPts,nTrials] = size(d);
tFinal = nPts*si;

t = linspace(0,tFinal,nPts);
for i=1:length(dIndx)
    hF = subplot(pH,pW,plotSpot(i));
    plot(t,d(:,dIndx(i)),'k');%'Color',color);
    axis tight
    ylim([yMin yMax]);
    hF.YTick = [];
    hF.XTick = [];
end

end


