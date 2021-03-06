function [stimDF,dF] = getDF(traces,stim,Fs)
%calculates dF/F's for a fluorescent time trace "traces", based on F0 from
%inter trial intervals. Bins dF by stimulus to become more analogous to a
%clampex recording.

if nargin < 3 || isempty(Fs)
    Fs = 1.48; %sampling rate, Hz %2.96 for Ryan
end

%Clip 1st col of traces
traces = traces(:,2:end);
[nFrames,nROIs] = size(traces);

stimDirs = stim(:,1);
nStims = numel(stimDirs);

%assumes MTS default settings
% preStimWait = 20; %sec
% iti = 10; %inter  trial interval, sec
% upTime = 7.14;%3.6; %time of stim, sec %7.14 ; 3.48
respWindow =5;%1.5; %sec, added to stim time



tFrames = 1:nFrames; %time vector in frames
%tSec = (tFrames - 1)/Fs; %time vector in seconds
%tStimSec = preStimWait:(upTime+iti):((nStims-1)*(upTime+iti) + preStimWait); %times of stim onset in seconds
tStimSec = stim(:,[7 8]);
tStimFrame = floor(tStimSec * Fs); %times of stim onset in frames
upTime = tStimSec(1,2) - tStimSec(1,1);
iti = tStimSec(2,1) - tStimSec(1,2);

nRespFrames = ceil((respWindow + upTime)*Fs); %number of frames per stim plus 1.5 seconds
%nInterFrames = floor(iti*Fs); %number of frames in iti minus one
nInterFrames = round((iti+upTime)*Fs - nRespFrames);

stimPeriod = NaN(nRespFrames,nStims);
preStimPeriod = NaN(nInterFrames,nStims);

for i = 1:nStims
    stimPeriod(:,i) = tStimFrame(i,1):tStimFrame(i,1) + nRespFrames - 1;
    preStimPeriod(:,i) = tStimFrame(i,1)-nInterFrames:tStimFrame(i,1)-1;
end
%Establish frames where prestim and stim happen

nTraceFrames = (nRespFrames + nInterFrames)*nStims;
stimDF = NaN(nRespFrames,nStims,nROIs);
dF = NaN(nTraceFrames,nROIs);

for j = 1:nROIs
    d = traces(:,j);
    preF = d(preStimPeriod);
    stimF = d(stimPeriod);
    F0 = mean(d(preStimPeriod));
    preDF = bsxfun(@rdivide,preF,F0) - 1; %pretty sure this is correct %preF ./ F0 - 1;
    stimDF(:,:,j) = bsxfun(@rdivide,stimF,F0) - 1;%stimF ./ F0 - 1;
    binDF = [preDF' stimDF(:,:,j)'];
    dF(:,j) = reshape(binDF',nTraceFrames,1);
end

end