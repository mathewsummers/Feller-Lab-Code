function quickStim(stimNum,stimDate)

newDir = sprintf('%s%s','C:\Users\Mathew\Documents\MATLAB\Feller Lab\DSGC Recordings\',stimDate);
oldDir = cd(newDir);

fn1 = sprintf('stim%s.txt',stimNum);
stimInfo = load('-ASCII',fn1);
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
