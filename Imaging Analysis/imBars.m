classdef imBars < imExp
    properties
        stim
    end
    
    methods
        function obj = imBars(R,acqNum)
            obj@imExp(R,acqNum,'bars');
            %[~,fn,~] = fileparts(pwd);
            %str = sprintf('stim%s',acqNum);
            %obj.stim = load(str);
        end
        
    end
    
end