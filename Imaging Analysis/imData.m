classdef imData < handle
    properties
        Neuron
        Exp
    end
    properties (Transient = true)
        RawData
    end
    
    methods
        function obj = imData(nObj,expObj)
            obj.Neuron = nObj;
            obj.Exp = expObj;
        end
        
        function [d,si] = loadRawData(obj)
            %%% Clean inputs %%%
            abfNum = imRetina.cleanAcquisitionNumber(obj.Exp.AcqNum);
            abfDate = imRetina.cleanClampexDate(obj.Exp.Retina.Date);
            abfName = sprintf('%s%s.abf',abfDate,abfNum);
            
            %%% Switch directories %%%
            newDir = sprintf('%s%s','C:\Users\Mathew\Documents\MATLAB\Feller Lab\DSGC Recordings\',...
                obj.Exp.Retina.Date);
            oldDir = cd(newDir);
            
            %%% Load axon binary file, squeeze singleton dimensions %%%
            [d,si] = abfload(abfName);
            d = squeeze(d);
            obj.RawData = d;
            
            %%% Switch directories %%%
            cd(oldDir);
        end
        
    end
    
end