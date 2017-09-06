preStimWait = 20; %sec
stim = 4; %sec
iti = 20; %sec (10 down time, 10 iti)
nReps = 3;
Fs = 1.48; %Hz
skipLaserOnset = 4; %sec

if Fs == 1.48
    tFrame = 0:129;%0:259
elseif Fs == 2.96
    tFrame = 0:259;
else
    warning('Unrecognized Fs');
end
tSec = tFrame / Fs;
tStimOn = (preStimWait):(stim + iti):(preStimWait + (stim + iti)*(nReps - 1));
tStimOff = tStimOn + stim;

tStimOnFrames = floor(tStimOn * Fs);
tStimOffFrames = floor(tStimOff * Fs);

F = traces(:,2:end);

[nFrames,nROIs] = size(F);
preFrames = round(skipLaserOnset * Fs):floor(preStimWait * Fs);
stimFrames = ceil(stim * Fs);

F0 = mean(F(preFrames,:));
dF = bsxfun(@ldivide,F0,F) - 1;

onResp = NaN(stimFrames,nReps,nROIs);
offResp = NaN(stimFrames,nReps,nROIs);

for i = 1:nReps
   onIndx = tStimOnFrames(i):(tStimOnFrames(i) + stimFrames - 1);
   offIndx = tStimOffFrames(i):(tStimOffFrames(i) + stimFrames - 1);
   onResp(:,i,:) = dF(onIndx,:);
   offResp(:,i,:) = dF(offIndx,:);
end

