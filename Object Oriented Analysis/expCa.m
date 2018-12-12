classdef expCa < expData
    properties
        PrefDir
        DSI
        VecLength
        dF
    end
    properties (Hidden = true)
        supportedDSMethods = {'count'}
        dsMethodDefault = 'count';
        dsMethodUsed % dsMethod used for currently saved DS values
    end
    
    methods
        function obj = expCa(nObj,stimObj)
            %%% Call expData constructor %%%
            obj@expData(nObj,stimObj);
            
        end
    end
    
end