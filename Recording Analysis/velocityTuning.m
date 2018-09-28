function [hF, DSI] = velocityTuning(ctSort,stimSpds,showLess,makeFig)
if nargin<4 || isempty(makeFig)
    makeFig = 1;
end
if nargin<3 || isempty(showLess)
    showLess = 0;
end
a = unique(stimSpds);
b = numel(a) / 2;

%check if inputs are all same sign
if range(sign(ctSort)) == 0
    ctSort = abs(ctSort);
end

totMax = max(ctSort(:));
axMax = ceil(totMax / 10) * 10;
%totMin = min(ctSort(:));

negSpeeds = mean(flip(ctSort(1:b,:)),2);
posSpeeds = mean(ctSort(b+1:end,:),2);
DSI = (posSpeeds - negSpeeds) ./ (posSpeeds + negSpeeds);

if ~showLess
    if makeFig
        hF = figure;
    else
        hF = [];
    end
    
    subplot(2,4,2:3)
    plot(a(b+1:end),DSI,'ko-','markerfacecolor','k','markersize',6,'lineWidth',1);
    xLine = refline(0,0);
    set(xLine,{'Color','LineStyle'},{[0 0 0],'--'});
    title('Selectivity across Speeds')
    xlabel('Speed (microns / s)')
    ylabel('DSI');
    ylim([-1 1])
    
    subplot(2,4,5:6)
    plot(abs(a(1:b)),ctSort(1:b,:),'ro-','lineWidth',1)
    title('Null')
    ylim([0 axMax])
    ylabel('Spike Count')
    
    subplot(2,4,7:8)
    plot(a(b+1:end),ctSort(b+1:end,:),'bo-','lineWidth',1)
    title('Pref')
    ylim([0 axMax])
    xlabel('Speed (microns / s)')
else
    hF = [];
end