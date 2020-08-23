function quickSpikes(d,si,isIClamp,varargin)
%Simple function to get calculate spike counts and timing, implements
%getSpikeTimes function.

if nargin < 3 || isempty(isIClamp)
    isIClamp = false;
end

thresh = -7; %default -7
manual = 0;
pvpmod(varargin)
[nPts,nTrls] = size(d);

dVector = reshape(d,numel(d),1);
dFilter = filterData(dVector,si); %could probably just implement filterData
%with a few lines here to reduce dependency on other functinos

if isIClamp %if a current clamp exp, use local maxima
    thresh = abs(thresh); %make positive for current clamp
    spTmsRaw = getSpikeTimesCurrentClamp(dFilter,si,'thresh',thresh,'manual',manual);
else %otherwise assume cell attached, use local minima
    spTmsRaw = getSpikeTimes(dFilter,si,'thresh',thresh,'manual',manual);
end

secTrial = nPts * si * 1e-6; %convert to seconds

spTms = cell(nTrls,1);
spCts = NaN(nTrls,1);

for i = 1:nTrls
    spIndx = spTmsRaw > (i-1)*secTrial & spTmsRaw < i*secTrial;
    spikes = spTmsRaw(spIndx) - (i-1)*secTrial;
    spTms{i} = spikes;
    spCts(i) = numel(spikes);
end

assignin('caller','spTms',spTms);
assignin('caller','spCts',spCts);

end
