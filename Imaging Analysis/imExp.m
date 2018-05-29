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
            %%% Check inputs match expected types %%%
            assert(ischar(acqNum),'acqNum must be a three digit string');
            
            if any(strcmpi(expType,R.supportedExps)) && any(strcmpi(acqMethod,R.supportedMethods))
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
    
    methods (Static = true)
        function ySort = sort(y,x)
            %%% Sort data elements y by unique stim elements x %%%
            uX = unique(x);
            nuX = numel(uX);
            [nDim1,nDim2] = size(y);
            
            if nDim2 == 1 %if dim 2 is singleton, properly align dimensions
                nPts = nDim2;
                nTrials = nDim1;
            else %otherwise assume dim1 is nPoints and dim2 nTrials
                nPts = nDim1;
                nTrials = nDim2;
            end
            
            nReps = nTrials / nuX;
            assert(rem(nReps,1) == 0,'# Trials / # Unique Elements should be 0');
            
            %%% Initialize output, sort differently if scalars %%%
            sortFlag = 0;
            if iscell(y)
                ySort = cell(nuX,nReps);
            elseif nPts > 1
                ySort = zeros(nPts,nReps,nuX);
                sortFlag = 1;
            else
                ySort = zeros(nuX,nReps);
            end
            
            %%% Sort via for loop %%%
            if sortFlag
                for i = 1:nuX
                    indx = ( uX(i) == x ); %find each index corresponding to a given stim
                    ySort(:,:,i) = y(:,indx);
                end
            else
                for i = 1:nuX
                    indx = ( uX(i) == x ); %find each index corresponding to a given stim
                    ySort(i,:) = y(indx);
                end
            end
        end
        
    end
end
