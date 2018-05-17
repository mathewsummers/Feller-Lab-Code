classdef imExp < handle
    properties (SetAccess = private)
        AcqNum
        Type
        Method
        Neurons
        Retina
    end
    
    methods
        function obj = imExp(R,acqNum,acqMethod,expType)
            %%% construct exp object %%%
            supportedExps = {'none','flash','bars'};
            supportedMethods = {'Spikes','Vclamp','Ca'};
            
            assert(ischar(acqNum),'acqNum must be a three digit string');
            
            if any(strcmpi(expType,supportedExps)) && any(strcmpi(acqMethod,supportedMethods))
                obj.Type = lower(expType);
                obj.Method = lower(acqMethod);
            else
                error('Unsupported experiment or recording type')
            end
            
            obj.Neurons = containers.Map('keyType','int32','valueType','any');
            obj.Retina = R;
            obj.AcqNum = acqNum;

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
