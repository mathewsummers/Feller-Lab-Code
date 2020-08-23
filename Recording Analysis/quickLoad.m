function hF = quickLoad(abfStim,dirName,hideOutput)
%Simple function to load an abf file and compress singleton dimensions.
%If provided only an abf file stim number, loads from current directory.
%Will automatically display raw data unless suppressed. Requires abfload.
%Inputs
%   abfStim         string, last 3 digits of abf file to be loaded
%   dirName         string, directory to load from. Assumes current
%   directory if not provided. Function interprets beginning of abf file
%   name from this string, so directory name must be date of recording in
%   Clampex's date format.
%   hideOutput      true/false, flag to hide raw data plots.
%Outputs
%   hF              figure handle of raw data trace
%   d               matrix, number of pts x number of trials (assigned in)
%   si              int, sampling interval in microseconds (assigned in)
% MTS 5/15/2016

if nargin < 3
    %Unless requested, don't display raw data traces
    hideOutput = false;
end

if nargin < 2 || isempty(dirName) 
    %if no input argument, assume current directory.
    [~,dirName] = fileparts(pwd);
    fprintf('Loading from current folder; %s \n',dirName);
else
    dirName = char(dirName); %ensure indexable characters, not a string
end

assert(size(abfStim,1) == 1,'abfStim must be a single string, not an array of strings.');

%account for clampex enforcing 5 digit dates
if strcmp(dirName(3:4),'10')
    abfDate = [dirName(1:2) 'o' dirName(5:6)];
elseif strcmp(dirName(3:4),'11')
    abfDate = [dirName(1:2) 'n' dirName(5:6)];
elseif strcmp(dirName(3:4),'12')
    abfDate = [dirName(1:2) 'd' dirName(5:6)];
elseif strcmp(dirName(3),'0') %account for clampex's peculiar naming conventions
    abfDate = [dirName(1:2) dirName(4:6)];
else
    abfDate = dirName(1:5);
end

abfName = sprintf('%s%s.abf',abfDate,abfStim);

%following line assumes Mathew's computer and system architecture
dsgcDir = 'C:\Users\Mathew\Documents\MATLAB\Feller Lab\DSGC Recordings\';
searchDirName = sprintf('%s*',dirName); %find directories that match input date

oldDir = cd(dsgcDir);
newDir = dir(searchDirName);
cd(newDir.name);

[d,si] = abfload(abfName);
d = squeeze(d);

if ~hideOutput
    size(d)
    hF = plotRawData(d,si);
else
    hF = [];
end

cd(oldDir);

%dispense variables to caller function, so don't have to declare outputs
%each time I'm calling quickLoad
assignin('caller','d',d);
assignin('caller','si',si);

end

function hF = plotRawData(d,si)
%plots unprocessed data if called, outputs figure handle.

[nPts,trials] = size(d);
dt = si*1e-6;
t = 0:dt:(nPts - 1)*dt;
L = floor(sqrt(trials));
W = ceil(trials / L);
minD = min(d(:));
maxD = max(d(:));
hF = figure;
for i = 1:trials
    subplot(L,W,i)
    plot(t,d(:,i),'r') 
    axis tight
    ylim([minD maxD])
end

end