classdef imFlash < imExp
    properties
        preStim
        upTime
        downTime
        iti
        nReps
    end
    
    methods
        function obj = imFlash(R,acqNum)
            obj@imExp(R,acqNum,'flash');
% %             obj.preStim = 20; %sec
% %             obj.upTime = 4;
% %             obj.downTime = 0;
% %             obj.iti = 20;
% %             obj.nReps = 3;
        end
    end
end