07/26/17 Analysis Guidelines

In ImageJ:
Select imaging movie
Register with StackReg, choose "Translation"
Load corresponding ROI zip file
Multimeasure ROIs to get fluorescent time courses

In Matlab:
traces = [ *Copy and paste fluorescent time courses* ];
stim = load('stimXXX.txt');
stimDirs = stim(:,1);
Fs = 1.48 for OGB data, 2.96 for Cal590

[stimDF,dF] = getDF(traces,stim,Fs); %calculates dF and chunks by stim times
[fMaxSort,fMinSort,maxList,minList,maxValList] = runAnalysis(stimDF,stimDirs); %finds max and min values in every stim chunk, sorts by stimulus direction

%To then look at individual ROIs:
roiNumber = 10; %choose any ROI index
plotDF(dF,stimDF,fMaxSort,stimDirs,roiNumber,Fs); %Fig1 plots dF trace with shaded stim times (these might be slightly off, as getDF now incorporates actual stim times, while plotDF estimates), Fig2 plots mean dF trace for each stim direction and colors by stim direction, Fig3 plots each stim chunk sorted by stim direction (using plotDirTraces) with each stim direction a column and reps as rows, Fig4 plots tuning curve polar plot produced from fMaxSort.



%Other DS analysis functions:

dFSort = quickSort(stimDF(:,:,roiNumber),stimDirs);
plotDirTraces(dFSort,stimDirs,Fs); %same as Fig3 above

plotCellGUI(dF); %creates GUI with slider to view full traces of each ROI



%Primarily a spot analysis function

thresh = .5; %example threshold
plotCellTraces(dF,Fs,thresh); %plots all dF traces for every ROI that surpasses the input dF threshold at least once during the movie, i.e. visualizes all responsive ROIs


