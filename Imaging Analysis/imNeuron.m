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
            obj.Exps(exp.AcqNum) = exp;
        end
        
        function obj = runData(obj,acqNum)
            acqNum = imRetina.cleanAcquisitionNumber(acqNum);
            %check associated exp
            dObj = imData(obj,obj.Exps(acqNum));
            
            obj.Data(acqNum) = dObj;
        end
        
        %shifted to imData
% % %         %% Load raw data for a given experiment
% % %         function [d,si] = loadRawData(obj,acqNum)
% % %             %%% Check acqNum is an associated experiment %%%
% % %             expList = obj.getExpList;
% % %             if ~ismember(acqNum,expList)
% % %                error('Given acquisition number is not a listed experiment for this neuron.');
% % %             end
% % %             
% % %             %%% Clean inputs %%%
% % %             abfNum = imRetina.cleanAcquisitionNumber(acqNum);
% % %             abfDate = imRetina.cleanClampexDate(obj.Retina.Date);
% % %             abfName = sprintf('%s%s.abf',abfDate,abfNum);
% % %             
% % %             %%% Load axon binary file, squeeze singleton dimensions %%%
% % %             [d,si] = abfload(abfName);
% % %             d = squeeze(d);
% % %             obj.RawData(acqNum) = d;
% % %         end
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