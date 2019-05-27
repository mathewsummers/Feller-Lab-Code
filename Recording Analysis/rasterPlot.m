function [hF] = rasterPlot(spTms,xBounds,sortIndx,coMap)
%Takes input of spTms cell array, and recording time in secs

if nargin < 4 || isempty(coMap)
    makeColorMap = true;
else
    makeColorMap = false;
end

if nargin < 3 || isempty(sortIndx)
    plotColors = false;
else
    plotColors = true;
end

if nargin < 2 || isempty(xBounds)
    xBounds = [0 max([spTms{:}])];
elseif numel(xBounds) == 1
    xBounds = [0 xBounds];
end

yMargin = .1; % 1 - (2 * yMargin) = length of ticks. formerly 0

nTrials = numel(spTms);
nSpikes = numel([spTms{:}]);
A = NaN(2,nSpikes); %spike time X
B = NaN(2,nSpikes); %raster draw height Y

a = 1; %spike iterator
for i=1:nTrials
    nTrSpikes = numel(spTms{i});
    A(:,a:(a + nTrSpikes - 1)) = repmat(spTms{i},2,1);
    B(1,a:(a + nTrSpikes - 1)) = nTrials - i + yMargin;
    B(2,a:(a + nTrSpikes - 1)) = nTrials - i + 1 - yMargin;
    a = a + nTrSpikes;
end

hF = figure;
hA = gca;
plot(A,B,'w','lineWidth',1.2)
set(hA,'Color',[1 1 1],'TickLength',[0 0]);
xlim(xBounds); ylim([-0.5 nTrials + 0.5]);
xlabel('Time (s)'); ylabel('Trial #');


if plotColors
    [q,~,r] = unique(sortIndx);
    if makeColorMap
        nStims = numel(q);
        coMap = hsv(nStims);
    end    
    b = nSpikes;
    c = zeros(1,nTrials);
    for j=1:nTrials
        nTrSpikes = numel(spTms{j});
        set(hA.Children(b:-1:(b - nTrSpikes + 1)),'Color',coMap(r(j),:))
        c(j) = b;
        b = b - nTrSpikes;
    end
    %legend(hA.Children(c(1:nStims:end)),num2str(q));
else
    set(hA.Children(:),'Color',[0 0 0]);
end

end

