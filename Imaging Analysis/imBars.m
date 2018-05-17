classdef imBars < imExp
    properties
        stim
    end
    
    methods
        function obj = imBars(R,acqNum,acqMethod)
            obj@imExp(R,acqNum,acqMethod,'bars');
            %[~,fn,~] = fileparts(pwd);
            %str = sprintf('stim%s',acqNum);
            %obj.stim = load(str);
        end
        
    end
    
end