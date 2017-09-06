function [stimDF,dF,onDF,offDF] = newGetDF(F,stim,Fs)
%Calculates dF/F's for a matrix of ROI fluorescent time courses, "F", based
%on F0 calculated from inter trial intervals. Bins dF's by stim (similar
%to clampex), and by stim onset and offsets. Meant to be used on imageJ
%multimeasure traces.

if nargin < 3 || isempty(Fs)
    Fs = 2.96;
end

F = F(:,2:end); %exclude 1st column of frame counts
[nStims,~] = size(stim);
[~,nROIs] = size(F);

%shortens right end of onTime and advances offTime
shrinker = 2; %sec
shrinker = round(shrinker * Fs); %frames

%determine timing parameters
tStimSec = stim(:,[7 8]);
tStimFrames = floor(tStimSec * Fs);
iti = tStimSec(2,1) - tStimSec(1,2); %sec
iti = round(iti * Fs); %frames
upTime = mean(tStimSec(:,2) - tStimSec(:,1)); %sec %using 2nd stim because 1st occassionally lasts slightly longer
upTime = round(upTime * Fs) - shrinker; %frames
baselineFrames = round(.5 * iti); %number of frames to calculate F0 with
truePreTime = iti - upTime; %number of pre frames to keep for dF trace
binTime = truePreTime + upTime*2; %frames in a stim window
totalFrames = binTime*nStims;

preStimIndices = zeros(baselineFrames,nStims);
onIndices = zeros(upTime,nStims);
offIndices = zeros(upTime,nStims);

%for each stim, find the frame indices of the pre stim period, the stim on
%period, and the stim off period
for i = 1:nStims
    preStimIndices(:,i) = (tStimFrames(i,1) - baselineFrames):(tStimFrames(i,1) - 1);
    onIndices(:,i) = tStimFrames(i,1):(tStimFrames(i,1) + upTime - 1);
    offIndices(:,i) = (tStimFrames(i,2) - shrinker):(tStimFrames(i,2) + upTime - shrinker - 1);
end

onDF = NaN(upTime,nStims,nROIs);
offDF = NaN(upTime,nStims,nROIs);
stimDF = NaN(binTime,nStims,nROIs);
dF = NaN(binTime*nStims,nROIs);

%for each ROI, access relevant frames of F trace, calculate F0, and then
%determine dF for pre stim period, stim on period, and stim off period.
%then combine these dF's into one trace binned by each stim presentation
%(excluding pre stim dF's that overlap with stim off dF's), and another
%unbinned dF trace.
for j = 1:nROIs
    d = F(:,j);
    preF = d(preStimIndices);
    onF = d(onIndices);
    offF = d(offIndices);
    
    F0 = mean(preF,1) + 1e-10; %to prevent divide by zero error
    
    preDF = bsxfun(@rdivide,preF,F0) - 1;
    onDF(:,:,j) = bsxfun(@rdivide,onF,F0) - 1;
    offDF(:,:,j) = bsxfun(@rdivide,offF,F0) - 1;
    
    stimDF(:,:,j) = [preDF(baselineFrames - truePreTime + 1:end,:); onDF(:,:,j); offDF(:,:,j)];
    dF(:,j) = reshape(stimDF(:,:,j),totalFrames,1);
end
%to do: center stimDF such that some preDF's from the next trial are padded
%at the end of the current trial
end
