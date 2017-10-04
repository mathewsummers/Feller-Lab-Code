classdef imExp < handle
    properties
        IDs
        Type
        AcqNum
        Fs
    end
    
    methods
        function obj = imExp(expType,acqNum,Fs)
            supportedExps = {'none','flash','bars'};
            assert(ischar(acqNum),'acqNum must be a three digit string');
            
            if any(strcmpi(expType,supportedExps))
                obj.IDs = containers.Map('keyType','single','valueType','any');
                obj.Type = lower(expType);
                obj.AcqNum = acqNum;
                obj.Fs = Fs;
            else
                error('Unsupported experiment type')
            end
            
        end
        
        function obj = addNeuron(obj,id,trace)
            n = imNeuron(id,obj);
            n.setTrace(obj.AcqNum,trace);
            obj.IDs(id) = n;
        end
        
        function [neuronList,listEmpty] = getNeuronList(obj)
            neuronList = cell2mat(obj.IDs.keys);
            if isempty(neuronList)
                listEmpty = true;
            else
                listEmpty = false;
            end
        end
        
        function obj = attachNeuron(obj,n,trace)
            if any(strcmp(obj.IDs.keys,n.ID))
                error('Neuron ID %d is already associated with the current experiment.',n.ID);
            end
            
            obj.IDs(n.ID) = n;
            n.addExp(obj,trace);
        end
    end
end
