function [fMaxSort,fMinSort,maxList,minList,maxValList] = runAnalysis(stimDF,stimDirs,thresh,showMore)

if nargin < 4 || isempty(showMore)
    showMore = 0;
end

if nargin < 3 || isempty(thresh)
    thresh = .2;
end

[nY,nStim,nROIs] = size(stimDF);

uDirs = unique(stimDirs);
nDirs = numel(uDirs);
nReps = nStim / nDirs;

sortTable = zeros(nDirs,nReps);

for i = 1:nDirs
    indx = ( uDirs(i) == stimDirs ); %find each index corresponding to a given stim
    sortTable(i,:) = find(indx);
end

dsList = NaN(nROIs,2);
fMaxSort = NaN(nDirs,nReps,nROIs);
fMinSort = NaN(nDirs,nReps,nROIs);
maxValList = NaN(3,nROIs);

for j = 1:nROIs
    fMax = max(stimDF(:,:,j));
    %fMax = fMax - min(fMax);
    fMaxSort(:,:,j) = fMax(sortTable);
    [~,maxPrefDir,maxDSI,maxVec] = dirTuning(fMaxSort(:,:,j),stimDirs,1);
    maxValList(:,j) = [maxPrefDir,maxDSI,maxVec];
    fMin = min(stimDF(:,:,j));
    fMin = abs(fMin - max(fMin)); %Maybe check this later
    fMinSort(:,:,j) = fMin(sortTable);
    [~,minPrefDir,minDSI,minVec] = dirTuning(fMinSort(:,:,j),stimDirs,1);
    
    dsList(j,:) = [maxVec, minVec] > thresh;

%    fMax(:,:,i) = quickSort(fMax(i,:),stimDirs);
%    fMin(:,:,i) = quickSort(fMin(i,:),stimDirs);
    
end

maxList = find(dsList(:,1));
minList = find(dsList(:,2));

if showMore
    nMax = numel(maxList);
    nMin = numel(minList);
    for k = 1:nMax
        hF = dirTuning(fMaxSort(:,:,maxList(k)),stimDirs);
        hF.Children.Title.String =['ROI ' num2str(maxList(k)) ' ' hF.Children.Title.String];
    end
    for l = 1:nMin
        hF = dirTuning(fMinSort(:,:,minList(l)),stimDirs);
        hF.Children.Title.String =['ROI ' num2str(minList(l)) ' ' hF.Children.Title.String];
    end
end
        
    
% 
% if nargin < 3 || isempty(Fs)
%     Fs = 1.48; %sampling rate, Hz %2.96 for Ryan
% end
% 
% %Clip 1st col of traces
% traces = traces(:,2:end);
% 
% %assumes MTS default settings
% preStimWait = 20; %sec
% iti = 10; %inter  trial interval, sec
% stim = 3.6; %time of stim, sec
% 
% [nFrames,nROIs] = size(traces);
% nStims = numel(stimDirs);
% nRespFrames = ceil((stim+1.5)*Fs); %number of frames per stim plus 1.5 seconds
% nInterFrames = floor(iti*Fs); %number of frames in iti minus one
% 
% tFrames = 1:nFrames; %time vector in frames
% tSec = (tFrames - 1)/Fs; %time vector in seconds
% tStimSec = preStimWait:(stim+iti):((nStims-1)*(stim+iti) + preStimWait); %times of stim onset in seconds
% tStimFrame = floor(tStimSec * Fs); %times of stim onset in frames
% 
% stimPeriod = NaN(nRespFrames,nStims);
% preStimPeriod = NaN(nInterFrames,nStims);
% 
% for i = 1:nStims
%     stimPeriod(:,i) = tStimFrame(i):tStimFrame(i) + nRespFrames - 1;
%     preStimPeriod(:,i) = tStimFrame(i)-nInterFrames:tStimFrame(i)-1; 
% end
% %Establish frames where prestim and stim happen
% 
% dF = NaN(nRespFrames,nStims,nROIs);
% 
% for j = 1:nROIs %First col of traces isn't real
%     d = traces(:,j);
%     F0 = mean(d(preStimPeriod));
%     dF(:,:,j) = d(stimPeriod)./F0 - 1;    
% end


% resp = NaN(1,nStims);
% respTime = NaN(1,nStims);
% 
% altResp = NaN(1,nStims);
% 
%     F0 = mean(d(preStimPeriod));
%     dF(:,i) = d(stimPeriod)./F0 - 1;
    
    
%         [fMax,fTime] = max(dF(stimPeriod));
%         resp(i) = fMax;
%         respTime(i) = stimPeriod(1) + fTime - 2; %CHECK THIS
%         
%         altResp(i) = max(dF(:,i));
    


% peakTime = respTime / Fs;
% %%% bad plotting fixes
% plotStim = [tStimSec(1:end-1); tStimSec(1:end-1) + stim; tStimSec(1:end-1) + stim; tStimSec(2:end)]; %Bad fixes follow
% plotStim = [reshape(plotStim,1,(nStims - 1)*4) tStimSec(end) tStimSec(end)+stim];
% plotArea = [repmat([1 1 -1 -1],1,(nStims - 1)) 1 1];
% %%%
% 
% figure; 
% stimColor = [.8 .8 .8];
% area(plotStim,plotArea,-1,'FaceColor',stimColor,'EdgeColor',stimColor)
% hold on
% plot(tSec,dF,'lineWidth',1)
% plot(peakTime,resp,'ok','MarkerSize',6);
% ylabel('\DeltaF/F'); xlabel('Time (sec)')
% xlim([0 tSec(end)]);
% 
% fSort = quickSort(altResp,stimDirs);
% minF = min(min(fSort));
% plotSort = fSort - minF;
% dirTuning(plotSort,stimDirs)
