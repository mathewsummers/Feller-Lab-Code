function filtData = filterData(data,sampInt,varargin)
% generate butterworth band pass (or stop) filter for filtering clampex traces
% INPUTS
%     data       a Nx1 data vector
%     sampInt    scalar; sampling interval in microseconds
%     low_cut    scalar; desired low cutoff in Hz
%     high_cut   scalar; desired high cutuff in Hz
%     order      scalar; filter will be order 2*order
%     band_stop  0 or 1, flag for a band stop filter
% OUTPUTS
%     filt       [B,A] butter
% Justin 2008-11-04

low_cut = 80; %values based on Salk MEA cutoffs
high_cut = 2000;
order = 4;
band_stop = 0;

pvpmod(varargin);

sampRate = 1/(sampInt*1e-6); %# of samples per sec
nyquistRate = sampRate/2;
Wn = [(low_cut/nyquistRate) (high_cut/nyquistRate)];

%make band pass or band stop filter
if band_stop
    [numFilt denFilt] = butter(order,Wn,'stop');
else
    [numFilt denFilt] = butter(order,Wn);
end

filtData = filtfilt(numFilt,denFilt,data);

% % % %smoothing using a gaus window
% % % bin_width = 50;
% % % win = normpdf(-(3*bin_width):(3*bin_width),0,bin_width);
% % % % win = win*freq_res;
% % % filtData = filtfilt(win,1,data);% * (1000/bin_width);

return