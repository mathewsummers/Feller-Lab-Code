classdef expData < handle
    properties (Transient = true)
        RawData
    end
    properties
        Fs
        Stim
        Neuron
    end
    
    methods
        function obj = expData(nObj,stimObj)
            obj.Neuron = nObj;
            obj.Stim = stimObj;
        end
        
        function [d,si] = loadRawData(obj)
            %%% Clean inputs %%%
            abfNum = expRetina.cleanAcquisitionNumber(obj.Stim.AcqNum);
            abfDate = expRetina.cleanClampexDate(obj.Stim.Retina.Date);
            abfName = sprintf('%s%s.abf',abfDate,abfNum);
            
            %%% Switch directories %%%
            oldDir = cd(obj.Stim.Retina.recordingDirectory); %move to DSGC recordings directory
            searchDirName = sprintf('%s*',obj.Stim.Retina.Date); %find directories that match input date
            newDir = dir(searchDirName);
            cd(newDir.name);
            
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