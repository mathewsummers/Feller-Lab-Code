classdef imBars < imExp
    properties
        Stim
    end
    
    properties (Hidden = true)
        scaleBarFraction = 6;
        DirIndex = 1;
    end
    
    methods
        function obj = imBars(R,acqNum,acqMethod)
            obj@imExp(R,acqNum,acqMethod,'bars');
            
            newDir = sprintf('%s%s',obj.Retina.Directory, obj.Retina.Date);
            oldDir = cd(newDir);
            
            str = sprintf('stim%s.txt',acqNum);
            obj.Stim = load(str);
            
            cd(oldDir);
        end
        
        function hF = plotSortData(obj,dObj)
            %%% Load raw data if not already loaded %%%
            if isempty(dObj.RawData)
                dObj.loadRawData;
            end
            
            %%% Determine input data type, set scale bar accordingly %%%
            dRange = range(dObj.RawData(:));
            scaleBarSize = dRange / obj.scaleBarFraction;
            switch obj.Method
                case 'spikes'
                    LW = .5;
                    scaleBarEnd = round(scaleBarSize / 100) * 100;
                    scaleBar = [0 scaleBarEnd];
                case 'vclamp'
                    LW = .8;
                    scaleBarEnd = round(scaleBarSize / 100) * 100;
                    if sum(dObj.RawData > 0) %try to determine if primarily positive or negative signal
                        scaleBar = [0 scaleBarEnd];
                    else
                        scaleBar = [-scaleBarEnd 0];
                    end
                case 'ca'
                    LW = 1.5;
                    scaleBarEnd = round(scaleBarSize * 10) / 10;
                    scaleBar = [0 scaleBarEnd];
                otherwise
                    error('Unrecognized data type.');
            end
            
            %%% Sort data and determine stim parameters %%%
            stimConds = obj.Stim(:,obj.DirIndex); % make this generalizable in future
            uStims = unique(stimConds);
            
            dSort = imExp.sort(dObj.RawData,stimConds);
            [nPts,nReps,nDirs] = size(dSort);
            nTrials = nReps*nDirs;
            plotData = reshape(dSort,nPts,nTrials);
            
            tSec = ( 0:(nPts - 1) ) / dObj.Fs;
            
            %%% Set up figure parameters %%%
            mindF = min(dSort(:));
            maxdF = max(dSort(:));
            
            xStart = .05;
            xEnd = .95;
            xEach = (xEnd - xStart)/nDirs;
            
            yStart = .05;
            yEnd = .95;
            yEach = (yEnd - yStart)/nReps;
            
            yLabelWidth = 1 - yEnd;
            
            %%% Create figure %%%
            hF = figure;
            for i = 1:nTrials
                xInt = floor((i-1)/nReps);
                yInt = mod(i-1,nReps) + 1;
                pos = [(xStart + xInt*xEach) (yEnd - yInt*yEach) xEach yEach];
                hA = axes('Units','Normalized','Position',pos,'XTick',[],'YTick',[],...
                    'YLim',[mindF maxdF],'XLim',[tSec(1) tSec(end)],'NextPlot','replacechildren');
                plot(tSec,plotData(:,i),'k','LineWidth',LW)
            end
            
            hF.Children(end).YTick = scaleBar;
            
            for j = 1:nDirs
                txtPos = [(xStart + (j-1)*xEach) yEnd xEach yLabelWidth];
                txtStr = num2str(uStims(j));
                txt = uicontrol(hF,'Style','text','Units','Normalized','Position',txtPos,...
                    'String',txtStr,'FontSize',12);
            end
            
        end
        
        function [PD,DSI,vec,pY,nY,yMean] = calcDirTuning(obj,y)
            %%% Convert stim directions to degrees %%%
            x = obj.Stim(:,obj.DirIndex);
            uDirs = unique(x);
            uDirs = deg2rad(uDirs);
            
            %%% Find mean resp for each stim direction %%%
            ySort = imExp.sort(y,x);
            yMean = mean(ySort,2);
            
            %%% Find normalized vector %%%
            [a,b] = pol2cart(uDirs, yMean / sum(yMean));
            PD = atan2d(sum(b),sum(a));
            if PD < 0
                PD = PD + 360;
            end
            vec = sqrt(sum(a)^2 + sum(b)^2);
            
            %%% Find PD's nearest index %%%
            nDirs = numel(uDirs);
            incDirs = 360 / nDirs; %direction increments
            prefIndx = round(PD / incDirs) + 1;
            if prefIndx > nDirs
                prefIndx = 1;
            end
            
            %%% Find ND's nearest index %%%
            nullIndx = prefIndx - (nDirs / 2);
            if nullIndx < 1
                nullIndx = nullIndx + nDirs;
            end
            
            %%% Compute DSI %%%
            pY = yMean(prefIndx);
            nY = yMean(nullIndx);
            DSI = (pY - nY) / (pY + nY);
        end
        
    end
    
end