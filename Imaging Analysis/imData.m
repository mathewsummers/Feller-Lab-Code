classdef imData < handle
    properties (Transient = true)
        RawData
    end
    properties
        Fs
        Exp
        Neuron
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
            newDir = sprintf('%s%s',obj.Exp.Retina.Directory, obj.Exp.Retina.Date);
            oldDir = cd(newDir);
            
            %%% Load axon binary file, squeeze singleton dimensions %%%
            [d,si] = abfload(abfName);
            d = squeeze(d);
            obj.RawData = d;
            obj.Fs = 1 / (si * 1e-6); %convert from useconds to hertz
            
            %%% Switch directories %%%
            cd(oldDir);
        end
        
        function hF = plotRawData(obj)
            %%% Load raw data if not already available %%%
            if isempty(obj.RawData)
                [d,si] = obj.loadRawData;
                dt = si*1e-6;%convert to seconds
            else
                d = obj.RawData;
                dt = 1 / obj.Fs;%convert to seconds
            end
            
            %%% Determine bounds of figure %%%
            [nPts,trials] = size(d);
            t = 0:dt:(nPts - 1)*dt;
            L = floor(sqrt(trials));
            W = ceil(trials / L);
            minD = min(d(:));
            maxD = max(d(:));
            
            %%% Plot figure %%%
            hF = figure;
            for i = 1:trials
                subplot(L,W,i)
                plot(t,d(:,i),'r')
                axis tight
                ylim([minD maxD])
            end
            
        end
    end
    
end