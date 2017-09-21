classdef imExp < handle
    properties
        IDs
        Type
        AcqNum
        Fs
    end
    
    methods
        function obj = imExp(expType,acqNum,Fs)
            supportedExps = {'none','flash','bars'};
            assert(ischar(acqNum),'acqNum must be a three digit string');
            
            if any(strcmpi(expType,supportedExps))
                obj.IDs = containers.Map('keyType','single','valueType','any');
                obj.Type = lower(expType);
                obj.AcqNum = acqNum;
                obj.Fs = Fs;
            else
                error('Unsupported experiment type')
            end
            
        end
        
        function obj = addNeuron(obj,traces)
            traces = traces(:,2:end); %skip first row for now
            warning('Clipping first row of traces.');
            [~,nROIs] = size(traces);
            
            for i = 1:nROIs
                n = imNeuron(i,obj);
                n.Trace(obj.AcqNum) = traces(:,i);
                obj.IDs(i) = n;
            end
        end
        
    end
end
