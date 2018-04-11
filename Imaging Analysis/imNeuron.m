classdef imNeuron < handle
    properties (SetAccess = private)
        Retina
        ID
        Exps
    end
    properties (SetAccess = private, Transient = true)
        RawData
    end
    
    methods
        function obj = imNeuron(R,ID)
            %%% Construct neuron object %%%
            obj.Retina = R;
            obj.ID = ID;
            obj.RawData = containers.Map('keyType','char','valueType','any');
            obj.Exps = containers.Map('keyType','char','valueType','any');
                        
        end
        
        function obj = addExp(obj,exp)
            %%% Add exp object to neuron's "exp" container %%%
            obj.Exps(exp.AcqNum) = exp;
        end
        
        function d = loadRawData(obj,acqNum)
            %%% Load raw data
            %%%%%%%% ADD CHECK FOR CORRESPONDING EXP ACQNUM
            abfNum = imRetina.cleanAcquisitionNumber(acqNum);
            abfDate = imRetina.cleanClampexDate(obj.Retina.Date);
           
            abfName = fprintf('%s%s',abfDate,abfNum);
            
            [d,si] = abfload(abfName);
            d = squeeze(d);
            
        end
                   
        function [expList,listEmpty] = getExpList(obj)
            expList = obj.Exps.keys;
            if isempty(expList)
                listEmpty = true;
            else
                listEmpty = false;
            end
        end
        
        function obj = setTrace(obj,acqNum,trace)
            %Bad, remove this later to ensure experiments always match
            %traces
            if any(strcmp(obj.Traces.keys,acqNum))
                warning('Trace for acquisition number %s already exists, and is being overwritten.',acqNum)
            end
            obj.Traces(acqNum) = trace;
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