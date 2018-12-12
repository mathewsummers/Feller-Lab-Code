function [hF] = rasterPlot(spTms,nSecs,stimDirs)
%Takes input of spTms cell array, and recording time in secs

nTrials = numel(spTms);
nSpikes = numel([spTms{:}]);
A = NaN(2,nSpikes);
B = NaN(2,nSpikes);

a = 1;
for i=1:nTrials
    nTrSpikes = numel(spTms{i});
    A(:,a:(a + nTrSpikes - 1)) = repmat(spTms{i},2,1);
    B(1,a:(a + nTrSpikes - 1)) = nTrials - i;
    B(2,a:(a + nTrSpikes - 1)) = nTrials - i + 1;
    a = a + nTrSpikes;
end

hF = figure;
hA = gca;
plot(A,B,'w','lineWidth',1.5)
set(hA,'Color',[1 1 1],'TickLength',[0 0]);
xlim([0 nSecs]); ylim([-0.5 nTrials + 0.5]);
xlabel('Time (s)'); ylabel('Trial #');


if ~isempty(stimDirs)
    [q,~,r] = unique(stimDirs);
    nStims = numel(q);
    cO = hsv(nStims);
    b = nSpikes;
    c = zeros(1,nTrials);
    for j=1:nTrials
        nTrSpikes = numel(spTms{j});
        set(hA.Children(b:-1:(b - nTrSpikes + 1)),'Color',cO(r(j),:))
        c(j) = b;
        b = b - nTrSpikes;
    end
    %legend(hA.Children(c(1:nStims:end)),num2str(q));
else
    set(hA.Children(:),'Color',[0 0 0]);
end

end

