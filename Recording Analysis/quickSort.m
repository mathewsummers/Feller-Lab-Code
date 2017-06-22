function spSort = quickSort(spikes,x)
%Sorts a vector of spike counts or spike times based on the structure of an
%input vector of stim conditions "x"

uX = unique(x);
nX = numel(uX);
nTrials = length(spikes);
nReps = nTrials / nX;

if iscell(spikes)
    spSort = cell(nX,nReps);
else
    spSort = zeros(nX,nReps);
end

for i = 1:nX
    indx = ( uX(i) == x ); %find each index corresponding to a given stim
    spSort(i,:) = spikes(indx);
end

end