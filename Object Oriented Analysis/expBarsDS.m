classdef expBarsDS < expStim
    properties
        NumReps
        StimInfo
    end
    
    properties (Hidden = true)
        scaleBarFraction = 6;
        defaultIndex = 1; % 1st column is stim direction
    end
    
    methods
        function obj = expBarsDS(R,acqNum,acqMethod)
            obj@expStim(R,acqNum,acqMethod,'bars');
            
            %%% Call loadRawStim function upon construction %%%
            obj.loadRawStim;
        end
        
        function stim = loadRawStim(obj)
            %%% Move to appropriate directory %%%
            newDir = sprintf('%s%s',obj.Retina.Directory, obj.Retina.Date);
            oldDir = cd(newDir);
            
            %%% Load and save stim info %%%
            str = sprintf('stim%s.txt',obj.AcqNum);
            stim = load(str);
            obj.StimInfo = stim;
            
            %%% Move back to previous directory %%%
            cd(oldDir);
        end
        
        function [stimConds] = getStimConds(obj,dim)
            %%% Retrieves stim feature, assumes direction %%%
            if nargin < 2 || isempty(dim)
                dim = obj.defaultIndex;
            end
            stimConds = obj.StimInfo(:,dim);
        end
        
        function [PD,DSI,vec,pY,nY,yMean] = calcDS(obj,y)
            %%% Convert stim directions to degrees %%%
            x = obj.getStimConds;
            uDirs = unique(x);
            uDirs = deg2rad(uDirs);
            
            %%% Find mean resp for each stim direction %%%
            ySort = expStim.sort(y,x);
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
        
        function hF = plotDS(obj,dataObj)
            %%% Check that DS values have been calculated %%%
            if isempty(dataObj.PrefDir)
                fprintf('Calculating DS values based on default methods.\n');
                dataObj.calcDS;
            end
            
            %%% Retrieve stim and sort relevant data %%%
            x = obj.getStimConds;
            switch lower(dataObj.dsMethodUsed)
                case 'count'
                    ySort = expStim.sort(dataObj.SpikeCounts,x);
                    titleStr = 'Spike Count Tuning Plot';
            end
            [~,nReps] = size(ySort);
            
            %%% Make stims and data circular for plotting %%%
            xSort = deg2rad(unique(x));
            xSort = [xSort; xSort(1)];
            xSortPlot = repmat(xSort,1,nReps);
            ySortPlot = [ySort; ySort(1,:)];   
            ySortMean = mean(ySortPlot,2);
            xCompass = dataObj.VecLength * cosd(dataObj.PrefDir) * max(ySortMean);
            yCompass = dataObj.VecLength * sind(dataObj.PrefDir) * max(ySortMean);
            
            %%% Create figure %%%
            hF = figure;
            hL = polar(xSortPlot,ySortPlot);
            set(hL(1:nReps),'LineWidth',1);
            hold on
            
            hL = polar(xSort,ySortMean,'k');
            set(hL(1),'LineWidth',2)
            
            hL = compass(xCompass,yCompass,'k');
            set(hL(1),'LineWidth',1.5)
            
            xStr = sprintf('Pref Dir: %3.1f     DSI: %4.2f     Vec Length: %4.2f',...
                dataObj.PrefDir,dataObj.DSI,dataObj.VecLength);
            xlabel(xStr);
            title(titleStr);
        end
        
        function hF = plotSortData(obj,dataObj)
            %%% Load raw data if not already loaded %%%
            if isempty(dataObj.RawData)
                dataObj.loadRawData;
            end
            
            %%% Determine input data type, set scale bar accordingly %%%
            dRange = range(dataObj.RawData(:));
            scaleBarSize = dRange / obj.scaleBarFraction;
            switch obj.Method
                case 'spikes'
                    LW = .5;
                    scaleBarEnd = round(scaleBarSize / 100) * 100;
                    scaleBar = [0 scaleBarEnd];
                case 'vclamp'
                    LW = .8;
                    scaleBarEnd = round(scaleBarSize / 100) * 100;
                    if sum(dataObj.RawData > 0) %try to determine if primarily positive or negative signal
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
            stimConds = obj.getStimConds;
            uStims = unique(stimConds);
            
            dSort = expStim.sort(dataObj.RawData,stimConds);
            [nPts,nReps,nDirs] = size(dSort);
            nTrials = nReps*nDirs;
            plotData = reshape(dSort,nPts,nTrials);
            
            tSec = ( 0:(nPts - 1) ) / dataObj.Fs;
            
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
                    'YLim',[mindF maxdF],'XLim',[tSec(1) tSec(end)],...
                    'Box','on','NextPlot','replacechildren');
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
        
    end
    
end