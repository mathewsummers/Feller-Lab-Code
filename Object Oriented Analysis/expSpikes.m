classdef expSpikes < expData
    properties
        PrefDir
        DSI
        VecLength
        PrefSpikes % mean pref direction spikes
        NullSpikes % mean null direction spikes
        DirSpikes % mean spike counts sorted by direction
        SpikeTimes
        SpikeCounts
    end
    properties (Hidden = true)
        supportedDSMethods = {'count'}
        dsMethodDefault = 'count';
        dsMethodUsed % dsMethod used for currently saved DS values
    end
    
    methods
        function obj = expSpikes(nObj,stimObj)
            %%% Call expData constructor %%%
            obj@expData(nObj,stimObj);
            
            %%% Load, vectorize, then filter data %%%
            [d, si] = obj.loadRawData;
            [nPts,nTrls] = size(d);
            dVector = reshape(d,numel(d),1);
            dFilter = filterData(dVector,si); %has a pvpmod dependency, should replace in future
            
            %%% Call getSpikeTimesDefault - should replace in future %%%
            spTmsRaw = getSpikeTimesDefault(dFilter,si); %looks for 7 standard deviations
            
            %%% Redistribute spike times and counts to original bins %%%
            secTrial = nPts * si * 1e-6; %convert to seconds
            spTms = cell(nTrls,1);
            spCts = NaN(nTrls,1);
            
            for i = 1:nTrls
                spIndx = spTmsRaw > (i-1)*secTrial & spTmsRaw < i*secTrial;
                spikes = spTmsRaw(spIndx) - (i-1)*secTrial;
                spTms{i} = spikes;
                spCts(i) = numel(spikes);
            end
            
            obj.SpikeTimes = spTms;
            obj.SpikeCounts = spCts;
        end
        
        function obj = calcDS(obj,dsMethod)
            %%% Use input or default calculation method %%%
            if nargin < 2 || isempty(dsMethod)
                dsMethod = obj.dsMethodDefault;
            elseif ~any(strcmpi(dsMethod,obj.supportedDSMethods))
                error('Unrecognized DS calculation method.');
            end
            
            %%% Call calcDS from expBars object, save used method %%%
            switch lower(dsMethod)
                case 'count'
                    [obj.PrefDir,obj.DSI,obj.VecLength,obj.PrefSpikes,...
                        obj.NullSpikes,obj.DirSpikes] = calcDS(obj.Stim,...
                        obj.SpikeCounts);
                    obj.dsMethodUsed = dsMethod;
            end
        end
        
        function hF = plotSortData(obj)
            %%% Call plotSortData from expBars object %%%
            hF = plotSortData(obj.Stim,obj);
        end
        
        function hF = plotDS(obj)
            %%% Call plotDS from expBars object %%%
            hF = plotDS(obj.Stim,obj);
        end
        
    end
    
end
