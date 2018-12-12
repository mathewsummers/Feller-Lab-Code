classdef expNeuron < handle
    properties (SetAccess = private)
        ID
        Data
        Stims
        Retina
    end
    
    methods
        function obj = expNeuron(R,ID)
            %%% Construct neuron object %%%
            obj.Retina = R;
            obj.ID = ID;
            obj.Stims = containers.Map('keyType','char','valueType','any');
            obj.Data = containers.Map('keyType','char','valueType','any');
            
        end
        
        function obj = addStim(obj,stim)
            %%% Add stim object to neuron's "stim" container %%%
            acqNum = stim.AcqNum;
            obj.Stims(acqNum) = stim;
            
            %%% Check recording method, initialize imData object %%%
            if strcmpi(stim.Method,'spikes')
                dObj = expSpikes(obj,stim);
            elseif strcmpi(stim.Method,'ca')
                dObj = expCa(obj,stim);
            else
                dObj = expData(obj,stim);
            end
            
            obj.Data(acqNum) = dObj;
        end
        
        function [stimList,listEmpty] = getStimList(obj)
            stimList = obj.Stims.keys;
            if isempty(stimList)
                listEmpty = true;
            else
                listEmpty = false;
            end
        end
        
        %         function plotStim(obj,stim)
        %             stimCount = [];
        %             stimList = obj.Stims.values;
        %             for i = 1:obj.Stims.Count
        %                 if strcmpi(stimList{i}.Type,stim)
        %                     stimCount = [stimCount; stimList{i}.AcqNum];
        %                 end
        %             end
        %
        %             if isempty(stimCount)
        %                 fprintf('No associated stim of stim type %s\n',stim)
        %                 return
        %             end
        %
        %             for j = 1:size(stimCount,1)
        %                 figure;
        %                 plot(obj.Traces(stimCount(j,:)))
        %             end
        %
        %         end
    end
    
end