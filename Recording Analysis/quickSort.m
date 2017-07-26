function ySort = quickSort(y,x)
%Sorts a vector of elements y (e.g. spike counts, or spike times) based on
%the unique elements of an input vector "x" (e.g. stim conditions)

uX = unique(x);
nuX = numel(uX);
[nDim1,nDim2] = size(y);

if nDim2 == 1 %if dim 2 is singleton, properly align dimensions
    nPts = nDim2;
    nTrials = nDim1;
else %otherwise assume dim1 is nPoints and dim2 nTrials
    nPts = nDim1;
    nTrials = nDim2;
end

nReps = nTrials / nuX;

sortFlag = 0;
if iscell(y)
    ySort = cell(nuX,nReps);
elseif nPts > 1
    ySort = zeros(nPts,nReps,nuX);
    sortFlag = 1;
else
    ySort = zeros(nuX,nReps);
end

if sortFlag
    
    for i = 1:nuX
        indx = ( uX(i) == x ); %find each index corresponding to a given stim
        ySort(:,:,i) = y(:,indx);
    end
    
else
    
    for i = 1:nuX
        indx = ( uX(i) == x ); %find each index corresponding to a given stim
        ySort(i,:) = y(indx);
    end
    
end

end