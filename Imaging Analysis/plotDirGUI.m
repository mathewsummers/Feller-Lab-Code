function plotDirGUI(dF,onSort,offSort,stimDirs)

[nFrames,nROIs] = size(dF);
[onDirs,onReps,onROIs] = size(onSort);
[offDirs,offReps,offROIs] = size(offSort);
assert(onROIs == offROIs,'Input matrices do not share the same number of ROIs');
assert(nROIs == onROIs,'Input matrices do not share the same number of ROIs');

imPos = [.1 .15 .6 .75];
barPos = [imPos(1) 0 imPos(3) .05];
txtPos = [barPos(1) (imPos(2)+imPos(4)) barPos(3) barPos(4)];
ppPos = [(.03 + imPos(1) + imPos(3)) imPos(2) (.94 - imPos(1) - imPos(3)) imPos(4)];
rgPos = [ppPos(1) .025 ppPos(3) .175];
rbPos1 = [.2 .25 .4 .5];
rbPos2 = [(rbPos1(1) + rbPos1(3)) rbPos1(2) rbPos1(3) rbPos1(4)];

r1Str = '   ON';
r2Str = '   OFF';

Fs = 1.48; %unless otherwise stated

tFrames = 1:nFrames;
tSec = (tFrames - 1)/Fs;

mindF = min(dF(:));
maxdF = max(dF(:));

hF = figure('Position',[50 100 1000 500]); %axes(hF, %incompatible with Matlab 2015b
hA = axes('Units','normalized','Position',imPos,...
    'XLim',[tSec(1) tSec(end)],'YLim',[mindF maxdF],...
    'NextPlot','replacechildren');
hB = axes('Units','normalized','Position',ppPos);
ylabel('\DeltaF/F');
xlabel('Time (sec)');

plot(hA,tSec,dF(:,1),'k','LineWidth',1.5)
dirTuning(onSort(:,:,1),stimDirs,[],0);
useOff = 0;

if nROIs>1
    slider = uicontrol(hF,'Style','slider','Min',1,'Max',nROIs,'Value',1,...
        'Units','Normalized','Position',barPos,'Callback',@plotCell);
    addlistener(slider,'Value','PreSet',@plotCell);
end
txt = uicontrol(hF,'Style','text','Units','Normalized','Position',txtPos,...
    'String','ROI # = 1','FontWeight','bold','FontSize',12);

rg = uibuttongroup('Units','Normalized','Position',rgPos,'SelectionChangedFcn',@choosePolarity);

r1 = uicontrol(rg,'style','radiobutton','units','normalized','position',rbPos1,...
    'String',r1Str,'FontSize',12);
r2 = uicontrol(rg,'style','radiobutton','units','normalized','position',rbPos2,...
    'String',r2Str,'FontSize',12);

    function plotCell(source,event)
        val = round(slider.Value);
        plot(hA,tSec,dF(:,val),'k','LineWidth',1.5)
        txtStr = sprintf('ROI # = %i',val);
        set(txt,'String',txtStr);
        plotDS
    end

    function plotDS
        val = round(slider.Value);
        reset(hB)
        if useOff
            dirTuning(offSort(:,:,val),stimDirs,[],0);
        else
            dirTuning(onSort(:,:,val),stimDirs,[],0);
        end
    end

    function choosePolarity(source,callback)
        if strcmp(callback.NewValue.String,r2Str)
            useOff = 1;
        else
            useOff = 0;
        end
        plotDS
    end
end