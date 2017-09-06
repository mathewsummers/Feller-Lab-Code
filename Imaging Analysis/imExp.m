classdef imExp < handle
    properties
        AcqNum
    end
    
    methods
        function obj = imExp(acqNum)
            if isnumeric(acqNum)
                acqNum = num2str(acqNum);
                nChars = numel(acqNum);
                for i=1:(3-nChars)
                    acqNum = ['0' acqNum];
                end
            end
            assert(ischar(acqNum),'Unrecognized acqNum input.');
            
            %obj = obj@imRetina();
            obj.AcqNum = acqNum;
        end
        
        function d = load(obj)
            %assumes Mathew's system architecture
            sysArch = 'C:\Users\Mathew\Documents\MATLAB\Feller Lab\Imaging Sessions\';
            newDir = sprintf('%s%s',sysArch,obj.Date);
            oldDir = cd(newDir);
            fn = sprintf('%s_%s_%s_%s.tif',obj.Age,obj.Marker,obj.Dye,obj.AcqNum);
            d = grabTif(fn);
            cd(oldDir);
        end
        
        function hF = play(obj)
            d = load(obj);
            upperBound = max(max(d));
            scaleFactor = 256 / upperBound;
            d = scaleFactor * d;
            hF = showTif(d);
        end
    end
end