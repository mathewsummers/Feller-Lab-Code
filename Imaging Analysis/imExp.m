classdef imExp < handle
    properties (SetAccess = private)
        Retina
        AcqNum
        Type
        Neurons
    end
    
    methods
        function obj = imExp(R,acqNum,expType)
            %%% construct exp object %%%
            supportedExps = {'none','flash','bars'};
            assert(ischar(acqNum),'acqNum must be a three digit string');
            
            if any(strcmpi(expType,supportedExps))
                obj.Neurons = containers.Map('keyType','int32','valueType','any');
                obj.Type = lower(expType);
                obj.AcqNum = acqNum;
            else
                error('Unsupported experiment type')
            end
            
            obj.Retina = R;
            
        end
        
        function obj = addNeuron(obj,neuronObj)
            %%% Add neuron object to exp's "neurons" container %%%
            obj.Neurons(neuronObj.ID) = neuronObj;
        end
        
        function [neuronList,listEmpty] = getNeuronList(obj)
            neuronList = cell2mat(obj.Neurons.keys);
            if isempty(neuronList)
                listEmpty = true;
            else
                listEmpty = false;
            end
        end
    end
end
