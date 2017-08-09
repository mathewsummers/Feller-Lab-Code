function plotDF(dF,stimDF,fMaxSort,stimDirs,ROI,Fs)

if nargin < 6 || isempty(Fs)
    Fs = 1.48;%2.96;
end

[nY,nStim,nROIs] = size(stimDF);
y = stimDF(:,:,ROI);
%y = reshape(y,nY*nStim,1);

% figure;
% plot(y,'g','LineWidth',2);


a = stimDF(:,:,ROI);
uDirs = unique(stimDirs);
nDirs = numel(uDirs);
nReps = nStim / nDirs;
sortTable = zeros(nDirs,nReps);
for i = 1:nDirs
    indx = ( uDirs(i) == stimDirs ); %find each index corresponding to a given stim
    sortTable(i,:) = find(indx);
end
a = a(:,sortTable');
b = NaN(nY,8);
for i = 1:nDirs
    b(:,i) = mean(a(:,(1+nReps*(i-1)):nReps*i),2);
end

%% Fix later
preStimWait = 20; %sec
iti = 10; %inter  trial interval, sec
stim = 7.14;%3.6; %time of stim, sec

[nFrames,nROIs] = size(dF);
nITI = (nFrames - (nY*nStim)) / nStim;
tStimFrames = nITI:(nY + nITI):(nY + nITI)*(nStim);
tStimSec = tStimFrames / Fs;

roiDF = dF(:,ROI);
maxDF = max(1.5 * max(roiDF),.8); %formerly 3
minDF = min(1.5 * min(roiDF),-.4); %formerly -1

tFrames = 0:(nFrames-1); %time vector in frames
tSec = tFrames/Fs; %time vector in seconds
%tStimSec = iti:(stim+iti):((nStim-1)*(stim+iti) + iti); %times of stim onset in seconds
%%tStimSec = (preStimWait:(iti+stim):(tSec(end)));%(12:20:480)/Fs;
plotStim = [tStimSec(1:end-1); tStimSec(1:end-1) + stim; tStimSec(1:end-1) + stim; tStimSec(2:end)]; %Bad fixes follow
plotStim = [reshape(plotStim,1,(nStim - 1)*4) tStimSec(end) tStimSec(end)+stim];
plotArea = [repmat([maxDF maxDF minDF minDF],1,(nStim - 1)) maxDF maxDF];
%%%

figure; 
stimColor = [.8 .8 .8];
area(plotStim,plotArea,-1,'FaceColor',stimColor,'EdgeColor',stimColor)
hold on
plot(tSec,roiDF,'lineWidth',1)
ylabel('\DeltaF/F'); xlabel('Time (sec)')
xlim([0 tSec(end)]);
ylim([minDF maxDF]);
%set(gca,'XTick',[]);

figure;
hold on
t = 0:(nY - 1);
t = round(t/Fs,1);
plotDirs = 0:(360/nDirs):359;
co = hsv(nDirs);
for j = 1:nDirs
    plot(t,b(:,j),'color',co(j,:),'linewidth',1);
end
xlim([0 t(end)]);
xlabel('Time (sec)');
ylabel('\DeltaF/F')
legend(num2str(plotDirs'),'Location','Best');

%%
%dFSort = quickSort(y,stimDirs);
plotDirTraces(stimDF,stimDirs,ROI,Fs)
%%
hF = dirTuning(fMaxSort(:,:,ROI),stimDirs);
hF.Children.Title.String =['ROI ' num2str(ROI) ' ' hF.Children.Title.String];

end

% plot dF while calculating F0 from iti