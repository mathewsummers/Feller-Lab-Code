classdef imRetina < handle
    properties (SetAccess = private)
        Date
        Genotype
        Exps %container for experiments in associated retina
        Neurons %container for neurons in associated retina
        Rig
    end
    properties
        Misc
    end
    properties (Hidden = true)
        Directory = 'C:\Users\Mathew\Documents\MATLAB\Feller Lab\DSGC Recordings\';
        supportedRigs = {'','SOS','MOM'};
        supportedExps = {'none','flash','bars'};
        supportedMethods = {'Spikes','Vclamp','Ca'};
    end
    
    methods
        function obj = imRetina(date,genotype,rig,notes)
            %%% construct Retina object %%%
            if nargin < 4 || isempty(notes)
                notes = [];
            end
            if ~any(strcmpi(rig,obj.supportedRigs))
                error('Unrecognized rig.');
            end
            obj.Date = date;
            obj.Genotype = genotype;
            obj.Neurons = containers.Map('keyType','int32','valueType','any');
            obj.Exps = containers.Map('keyType','char','valueType','any');
            obj.Rig = rig;
            obj.Misc = notes;
        end
        %% Add Neurons to imRetina object
        function nObj = addNeuron(obj,IDs)
            %%% Check if IDs match any previously declared neurons. %%%
            [neuronIDsList,neuronIDsListEmpty] = obj.getNeuronList;
            if nargin < 2 || isempty(IDs)
                nNeurons = 1; %if no IDs supplied only add one neuron
                if neuronIDsListEmpty
                    IDs = 1;
                else
                    IDs = max(neuronIDsList) + 1;
                end
            else
                neuronExists = ismember(IDs,neuronIDsList);
                if any(neuronExists)
                    fprintf('The following neuron already exists, and will not be added: \n');
                    fprintf('\t%i \n',IDs(neuronExists))
                    IDs(neuronExists) = [];
                end
                nNeurons = numel(IDs);
            end
            
            %%% Declare neurons and add them to Retina object %%%
            for i = 1:nNeurons
                nObj = imNeuron(obj,IDs(i));
                obj.Neurons(IDs(i)) = nObj;
            end
            
        end
        %% Add Experiment to imRetina object
        function expObj = addExp(obj,acqNum,IDs,acqMethod,expType,varargin)
            %%% Check input expType matches known exp types %%%
            if nargin < 5 || isempty(expType)
                expType = 'none';
            elseif ~any(strcmpi(expType,obj.supportedExps))
                error('Unrecognized experiment type.');
            end
            
            if nargin < 4 || isempty(acqMethod)
                acqMethod = 'Vclamp';
            elseif ~any(strcmpi(acqMethod,obj.supportedMethods))
                error('Unrecognized recording method.');
            end
            
            %%% Check that input neuron IDs exist %%%
            neuronIDsList = obj.getNeuronList;
            if any(~ismember(IDs,neuronIDsList))
                error('At least one provided ID does not match any declared neurons.\n')
            end
            
            %%% Clean acqNum inputs %%%
            acqNum = obj.cleanAcquisitionNumber(acqNum);
            
            %%% Check that given exp has not already been declared %%%
            if any(strcmp(obj.Exps.keys,acqNum))
                error(['Given acquisition number already has an associated experiment:\n'...
                    'Use "modifyExp" instead (in development).\n'])
            end
            
            %%% Declare exp based on expType %%%
            switch lower(expType)
                case 'none'
                    expObj = imExp(obj,acqNum,acqMethod,expType);
                case 'flash'
                    %use varargin to modify defaults in the future
                    radius = 78 * .65;
                    delayTime = 2;
                    upTime = 3;
                    downTime = 2.5;
                    expObj = imFlash(obj,acqNum,acqMethod,radius,delayTime,upTime,downTime);
                case 'bars'
                    %use varargin to modify defaults in the future
                    expObj = imBars(obj,acqNum,acqMethod);
            end
            
            %%% Add exp to relevant neurons, add to Retina object %%%
            nNeurons = numel(IDs);
            for i = 1:nNeurons
                nObj = obj.Neurons(IDs(i));
                nObj.addExp(expObj);
                expObj.addNeuron(nObj);
            end
            obj.Exps(acqNum) = expObj;
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
        
        function [neuronIDsList,listEmpty] = getNeuronList(obj)
            neuronIDsList = cell2mat(obj.Neurons.keys);
            if isempty(neuronIDsList)
                listEmpty = true;
            else
                listEmpty = false;
            end
        end
    end
    
    methods (Static = true)
        function acqNum = cleanAcquisitionNumber(acqNum)
            %limited cleaning of acquisition number input
            if ~ischar(acqNum) %if not a string, check if integer then convert to string
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
                    error('acqNum must be an integer or a string of integers.\n')
                end
            end
        end
        
        function abfDate = cleanClampexDate(dirName)
            if strcmp(dirName(3:4),'10')
                abfDate = [dirName(1:2) 'o' dirName(5:end)];
            elseif strcmp(dirName(3:4),'11')
                abfDate = [dirName(1:2) 'n' dirName(5:end)];
            elseif strcmp(dirName(3:4),'12')
                abfDate = [dirName(1:2) 'd' dirName(5:end)];
            elseif strcmp(dirName(3),'0') %account for clampex's peculiar naming conventions
                abfDate = [dirName(1:2) dirName(4:end)];
            else
                abfDate = dirName;
            end
        end
    end
end