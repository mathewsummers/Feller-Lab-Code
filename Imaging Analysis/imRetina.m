classdef imRetina < handle
    properties
        Date
        Markers
        Neurons
        Exps
    end
    
    methods
        function obj = imRetina(date,marker)
            obj.Date = date;
            obj.Markers = marker;
            obj.Neurons = containers.Map('keyType','int32','valueType','any');
            obj.Exps = containers.Map('keyType','char','valueType','any');
        end
        
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
        
        function obj = addNeurons(obj,acqNum,traces)
            
        end
    end
end