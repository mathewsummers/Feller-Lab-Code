classdef imSpikes < imData
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
    
    methods
        function obj = imSpikes(nObj,expObj)
            %%% Call imData constructor %%%
            obj@imData(nObj,expObj);
            
            %%% Load, vectorize, then filter data %%%
            [d, si] = obj.loadRawData;            
            [nPts,nTrls] = size(d);
            dVector = reshape(d,numel(d),1);
            dFilter = filterData(dVector,si);
            
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
        
        function obj = spikeCountDS(obj)
            %%% Call calcDirTuning from imBars object %%%
            [obj.PrefDir,obj.DSI,obj.VecLength,obj.PrefSpikes,...
                obj.NullSpikes,obj.DirSpikes] = calcDirTuning(obj.Exp,...
                obj.SpikeCounts);
        end
        
        function hF = plotSortData(obj)
            %%% Call plotSortData from imBars object %%%
            hF = plotSortData(obj.Exp,obj);
        end
        
    end
    
end
