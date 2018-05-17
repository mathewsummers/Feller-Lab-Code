classdef imFlash < imExp
    properties
        radius
        delayTime
        upTime
        downTime
    end
    
    methods
        function obj = imFlash(R,acqNum,acqMethod,radius,delayTime,...
                upTime,downTime)
            %%% Construct imExp / imFlash object %%%
            obj@imExp(R,acqNum,acqMethod,'flash');
            obj.radius = radius; %in microns
            obj.delayTime = delayTime;
            obj.upTime = upTime;
            obj.downTime = downTime;
        end
    end
end