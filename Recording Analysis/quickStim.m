function quickStim(stimNum,stimDate)

dsgcDir = 'C:\Users\Mathew\Documents\MATLAB\Feller Lab\DSGC Recordings\';
searchDirName = sprintf('%s*',stimDate); %find directories that match input date

oldDir = cd(dsgcDir);
newDir = dir(searchDirName);
cd(newDir.name);

fn = sprintf('stim%s.txt',stimNum);
stimInfo = load('-ASCII',fn);
assignin('base','stimInfo',stimInfo);
% order of stimInfo depends on stim function used, but usually:
% 1st column: bar directions
% 2nd column: bar speeds
% 3rd column: bar length
% 4th column: bar width
% 5th column: radius to traverse
% 6th column: bar brightness

cd(oldDir);

end
