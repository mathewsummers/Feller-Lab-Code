preStimWait = 20; %sec
Fs = 1.48; %Hz
tFrame = 0:129;%0:259;
tSec = tFrame / Fs;
preFrames = 1:floor(preStimWait * Fs);
F = traces(:,2:end);

F0 = mean(F(preFrames,:));
dF = bsxfun(@ldivide,F0,F) - 1;