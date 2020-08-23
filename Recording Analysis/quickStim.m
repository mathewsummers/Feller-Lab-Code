function quickStim(stimNum,stimDate)
% Function to load stimXXX.txt files for a given experiment.

if nargin < 2 || isempty(stimDate) 
    %if no input argument, assume current directory.
    [~,stimDate] = fileparts(pwd);
    fprintf('Loading from current folder; %s \n',stimDate);
else
    stimDate = char(stimDate); %ensure indexable characters, not a string
end

dsgcDir = 'C:\Users\Mathew\Documents\MATLAB\Feller Lab\DSGC Recordings\';
searchDirName = sprintf('%s*',stimDate); %find directories that match input date

oldDir = cd(dsgcDir);
newDir = dir(searchDirName);
cd(newDir.name);

fn = sprintf('stim%s.txt',stimNum);
stimInfo = load('-ASCII',fn);
assignin('caller','stimInfo',stimInfo);
% order of stimInfo depends on stim function used, but usually:
% 1st column: bar directions
% 2nd column: bar speeds
% 3rd column: bar length
% 4th column: bar width
% 5th column: radius to traverse
% 6th column: bar brightness

cd(oldDir);

end
