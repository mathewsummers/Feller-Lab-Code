classdef imNeuron < handle
    properties (SetAccess = private)
        ID
        Data
        Exps
        Retina
    end
    
    methods
        function obj = imNeuron(R,ID)
            %%% Construct neuron object %%%
            obj.Retina = R;
            obj.ID = ID;
            obj.Exps = containers.Map('keyType','char','valueType','any');
            obj.Data = containers.Map('keyType','char','valueType','any');
            
        end
        
        function obj = addExp(obj,exp)
            %%% Add exp object to neuron's "exp" container %%%
            acqNum = exp.AcqNum;
            obj.Exps(acqNum) = exp;
            
            %%% Check recording method, initialize imData object %%%
            if strcmpi(exp.Method,'spikes')
                dObj = imSpikes(obj,exp);
            else
                dObj = imData(obj,exp);
            end
            
            obj.Data(acqNum) = dObj;
        end
        
        % % %
        % % %         function [expList,listEmpty] = getExpList(obj)
        % % %             expList = obj.Exps.keys;
        % % %             if isempty(expList)
        % % %                 listEmpty = true;
        % % %             else
        % % %                 listEmpty = false;
        % % %             end
        % % %         end
        
        %         function plotStim(obj,stim)
        %             expCount = [];
        %             expList = obj.Exps.values;
        %             for i = 1:obj.Exps.Count
        %                 if strcmpi(expList{i}.Type,stim)
        %                     expCount = [expCount; expList{i}.AcqNum];
        %                 end
        %             end
        %
        %             if isempty(expCount)
        %                 fprintf('No associated experiments of stim type %s\n',stim)
        %                 return
        %             end
        %
        %             for j = 1:size(expCount,1)
        %                 figure;
        %                 plot(obj.Traces(expCount(j,:)))
        %             end
        %
        %         end
    end
    
end