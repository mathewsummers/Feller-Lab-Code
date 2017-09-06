function hF = showTif(d,c)
if nargin < 2 || isempty(c)
   c = [min(min(min(d))) max(max(max(d)))];
end
imPos = [.05 .05 .9 .9];
barPos = [imPos(1) 0 imPos(3) .05];
hF = figure;
hA = axes('Units','normalized','Position',imPos);

[H,W,T] = size(d);

imagesc(d(:,:,1),c);
hA.XTick = [];
hA.YTick = [];
hA.NextPlot = 'replacechildren';

if T>1
    slider = uicontrol(hF,'Style','slider','Min',1,'Max',T,'Value',1,...
        'Units','Normalized','Position',barPos);
    addlistener(slider,'Value','PreSet',@plotFrame);
end

    function plotFrame(source,event)
        val = round(slider.Value);
        imagesc(d(:,:,val),c);
    end
end

