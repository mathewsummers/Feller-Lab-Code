classdef imBars < imExp
    properties
        stim
    end
    
    methods
        function obj = imBars(acqNum,Fs)
            obj@imExp('bars',acqNum,Fs);
            %[~,fn,~] = fileparts(pwd);
            %str = sprintf('stim%s',acqNum);
            %obj.stim = load(str);
        end
        
    end
    
end