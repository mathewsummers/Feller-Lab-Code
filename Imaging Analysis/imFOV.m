classdef imFOV < imExp
    properties
        ROIs
    end
    
    methods
        function obj = imFOV(acqNum)
            obj = obj@imExp(acqNum);
        end
        
    end
end