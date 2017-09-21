classdef imNeuron < handle
    properties
        ID
        FOV
        Coords
        Traces
        Exps
    end
    
    methods
        function obj = imNeuron(ID,exp)
            
            if nargin < 2 || isempty(exp)
                declaredByExp = 0;
            elseif isa(exp,'imExp')
                declaredByExp = 1;
            else
                error('Declaration by an unrecognized experiment object.');
            end
            
            obj.ID = ID;
            obj.Traces = containers.Map('keyType','char','valueType','any');
            obj.Exps = containers.Map('keyType','char','valueType','any');
            
            if declaredByExp
                obj.Exps(exp.AcqNum) = exp;
            end
            
        end
        
        function obj = addExp(obj,expList,traceList)
            %function to add experiment and ensuing trace to a neuron,
            %should probably add via addNeuron function in imExp instead.
            if isa(expList,'imExp')
                expList = {expList}; %if a single exp input, make into cell array
                traceList = {traceList};
                nExps = 1;
            elseif iscell(expList) && isa([expList{:}],'imExp')
                nExps = numel(expList);
            else
                error('Input is not an imExp object, nor a cell array containing imExp objects.')
            end
            
            for i = 1:nExps
                indx = expList{i}.AcqNum;
                if ~obj.Exps.isKey(indx) && ~obj.Traces.isKey(indx)
                    obj.Exps(indx) = expList{i};
                    obj.Traces(indx) = traceList{i};
                else
                    error('Neuron already contains an experiment with acquisition number %s',indx)
                end
            end
        end
        
        function plotStim(obj,stim)
            expCount = [];
            expList = obj.Exps.values;
            for i = 1:obj.Exps.Count
                if strcmpi(expList{i}.Type,stim)
                    expCount = [expCount; expList{i}.AcqNum];
                end
            end
            
            if isempty(expCount)
                fprintf('No associated experiments of stim type %s\n',stim)
                return
            end
            
            for j = 1:size(expCount,1)
                figure;
                plot(obj.Traces(expCount(j,:)))
            end
            
        end
    end
    
end