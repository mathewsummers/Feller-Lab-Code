classdef expFlash < expStim
    properties
        radius
        delayTime
        upTime
        downTime
    end
    
    methods
        function obj = expFlash(R,acqNum,acqMethod,radius,delayTime,...
                upTime,downTime)
            %%% Construct expStim / expFlash object %%%
            obj@expStim(R,acqNum,acqMethod,'flash');
            obj.radius = radius; %in microns
            obj.delayTime = delayTime;
            obj.upTime = upTime;
            obj.downTime = downTime;
        end
    end
end