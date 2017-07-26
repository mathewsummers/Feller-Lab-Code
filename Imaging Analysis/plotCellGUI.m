function plotCellGUI(dF)

imPos = [.1 .15 .8 .75];
barPos = [imPos(1) 0 imPos(3) .05];
txtPos = [barPos(1) (imPos(1)+imPos(3)) barPos(3) barPos(4)];

Fs = 1.48; %unless otherwise stated
[nFrames,nROIs] = size(dF);
tFrames = 1:nFrames;
tSec = (tFrames - 1)/Fs;

mindF = min(dF(:));
maxdF = max(dF(:));

hF = figure; %axes(hF, %incompatible with Matlab 2015b
hA = axes('Units','normalized','Position',imPos,...
    'XLim',[tSec(1) tSec(end)],'YLim',[mindF maxdF],...
    'NextPlot','replacechildren');
ylabel('\DeltaF/F');
xlabel('Time (sec)');

    plot(tSec,dF(:,1),'k','LineWidth',1.5)

if nROIs>1
    slider = uicontrol(hF,'Style','slider','Min',1,'Max',nROIs,'Value',1,...
        'Units','Normalized','Position',barPos,'Callback',@plotCell);
    addlistener(slider,'Value','PreSet',@plotCell);
end
txt = uicontrol(hF,'Style','text','Units','Normalized','Position',txtPos,...
        'String','ROI # = 1','FontWeight','bold','FontSize',12);

    function plotCell(source,event)
        val = round(slider.Value);
        plot(tSec,dF(:,val),'k','LineWidth',1.5)
        txtStr = sprintf('ROI # = %i',val);
        set(txt,'String',txtStr);
    end
end