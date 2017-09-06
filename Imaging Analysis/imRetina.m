classdef imRetina < handle
    properties
        Date
        Age
        Marker
        Dye
        Fs
        FOV
    end
    
    methods
        function obj = imRetina(Date,Age,Marker,Dye,Fs)
            if nargin < 1
                obj.Date = '???';
                obj.Age = '???';
                obj.Marker = '???';
                obj.Dye = '???';
                obj.Fs = 1.48;
                obj.FOV = containers.Map('KeyType', 'single', 'ValueType', 'any');
            else
                obj.Date = Date;
                obj.Age = Age;
                obj.Marker = Marker;
                obj.Dye = Dye;
                obj.Fs = Fs;
            end
        end
        
    end
end