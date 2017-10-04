classdef imRetina < handle
    properties
        Date
        Dye
        Exps
        Neurons
        Genotype
        Rig
        Misc
    end
    
    methods
        function obj = imRetina(date,dye)
            obj.Date = date;
            obj.Dye = dye;
            obj.Neurons = containers.Map('keyType','int32','valueType','any');
            obj.Exps = containers.Map('keyType','char','valueType','any');
        end
        %% Add Experiment to imRetina object
        function obj = addExp(obj,acqNum,expType,Fs)
            supportedExps = {'none','flash','bars'};
            
            if nargin < 4 || isempty(Fs)
                Fs = 1.48; %Hz, default
            end
            
            if nargin < 3 || isempty(expType)
                expType = 'none';
            elseif ~any(strcmpi(expType,supportedExps))
                error('Unrecognized experiment type.');
            end
            
            if ~ischar(acqNum)
                if isreal(acqNum) && rem(acqNum,1)==0
                    acqNum = num2str(acqNum);
                    nDigits = numel(acqNum);
                    switch nDigits
                        case 1
                            acqNum = ['00' acqNum];
                        case 2
                            acqNum = ['0' acqNum];
                    end
                else
                    error('acqNum must be an integer or a string of integers.')
                end
            end
            
            if any(strcmp(obj.Exps.keys,acqNum))
                error('Given acquisition number already has an associated experiment.')
            end
            
            switch lower(expType)
                case 'none'
                    expObj = imExp(expType,acqNum,Fs);
                case 'flash'
                    expObj = imFlash(acqNum,Fs);
                case 'bars'
                    expObj = imBars(acqNum,Fs);
            end
            
            obj.Exps(acqNum) = expObj;
        end
        %% Add Neurons to imExp objects
        function obj = addNeurons(obj,acqNum,traces,IDs)
            %check that given experiment exists
            if ~any(strcmp(obj.getExpList,acqNum))
                error('There does not yet exist an associated experiment for the given acquisition number.')
            else
                exp = obj.Exps(acqNum);
            end
            
            [~,nROIs] = size(traces);
            
            %check if experiment already has associated neurons
            [expNeurons,expNeuronListEmpty] = exp.getNeuronList;
            if ~expNeuronListEmpty
                nNeurons = numel(expNeurons);
                prmptMsg = sprintf('Warning: Specified expriment %s already has %i associated neurons. You are attempting to add %i more. Proceed?', ...
                    acqNum, nNeurons, nROIs);
                button = questdlg(prmptMsg,'Continue','Continue','Cancel','Cancel');
                if strcmpi(button,'Cancel')
                    return
                end
            end
            
            [retinaNeurons,retinaNeuronListEmpty] = obj.getNeuronList;
            
            if nargin < 4 || isempty(IDs) %if IDs are not supplied, assume new neurons
                if retinaNeuronListEmpty
                    IDs = 1:nROIs;
                else
                    IDs = (max(retinaNeurons) + 1):(max(retinaNeurons) + nROIs);
                end
            end
            
            assert(numel(IDs) == nROIs,'Number of IDs must match number of input traces.')
            
            neuronExists = ismember(IDs,retinaNeurons); %find neurons that have already been declared
            for i = 1:nROIs
                if neuronExists(i)
                    n = obj.Neurons(IDs(i));
                    exp.attachNeuron(n,traces(:,i));
                    obj.Neurons(IDs(i)) = n;
                else
                    exp.addNeuron(IDs(i),traces(:,i));
                    obj.Neurons(IDs(i)) = exp.IDs(IDs(i));
                end
            end
            
        end
        %%
        function [expList,listEmpty] = getExpList(obj)
            expList = obj.Exps.keys;
            if isempty(expList)
                listEmpty = true;
            else
                listEmpty = false;
            end
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