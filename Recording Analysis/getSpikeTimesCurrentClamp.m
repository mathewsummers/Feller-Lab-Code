function [spike_times,excluded_trials,fig_num] = getSpikeTimesCurrentClamp(data,samp_int,varargin)
% finds spiketimes (local minima) in clampex data loaded with abfload
%
% %INPUTS:
%     data                                      Nx1 vector
%     samp_int                            scalar sampling interval in microseconds
%     thresh                                 threshold in std
%     manual                                 0 or 1, manually choose spike threshold
%     show_plot                          0 or 1, optional plot flag
%     ax_offset                          time offset in samples for plot
%     y_axis_range                  'auto' or [min max]
%     refractory_period     scalar, time in ms to exclude spikes
%     tlt                                          titlr of the plot
%     dirs                                        if a whole repetition that contains all different directions is given, 
%                                                       the plot will be split by lines between the trials of the different dirs
%     dur                                          the duration of each trial (in sec)
%
% %OUTPUTS
%     SpikeTimes                        1xN vector of spiketimes
%     excluded_trials           the nmbers of all trials that should be excluded from the analysis
%     fig_num                                the figure number, so we can close it later

%default values
thresh = 7;
manual = 0;
show_plot=0;
ax_offset = 0;
y_axis_range = 'auto';
refractory_period = 0.001;
tlt = '';
dirs = [];
dur=0;

%assign input variables
pvpmod(varargin);

default_cutoff=mean(data)+thresh*std(data);
spike_times = [];
excluded_trials = [];
fig_num = [];
lower_cutoff = 0;

if manual
    [~,~,fig_num] = makeTracePlot(data,samp_int,'ax_offset',ax_offset,'y_axis_range',y_axis_range);
    [~,ys] = selectThreshold(default_cutoff);
    if ~isempty(ys)
        cutoff = max(ys);
        lower_cutoff = min(ys);
    else %no spikes deined
        cutoff = min(data)-1;
    end
    close;
else
    cutoff=default_cutoff;    
end

%find spikes according to local minima
ind = 1;
suspect_points = find(data>=cutoff);    
for d = 2:(length(suspect_points)-1)
    if data(suspect_points(d)) >= data(suspect_points(d)-1) && data(suspect_points(d)) >= data(suspect_points(d)+1)
        spike_times(ind) = (suspect_points(d))*samp_int*1e-6; %convert to seconds
        spike_vals(ind) = data(suspect_points(d));
        ind = ind + 1;
    end
end
%remove refractory period violations
bad_inds = diff(spike_times) <= refractory_period;
spike_times(bad_inds) = [];
spike_vals(bad_inds) = [];

% remove noises with a high amplitude
if lower_cutoff
    rem = find(spike_vals<lower_cutoff);
    spike_times(rem) = [];
    spike_vals(rem) = [];
end

%convert sec
ax_offset_sec = ax_offset*samp_int*1e-6; 
spike_times = spike_times + ax_offset_sec;

%optional plot of data with selected threshold
if show_plot
    [~,ax,fig_num] = makeTracePlot(data,samp_int,'ax_offset',ax_offset);
    %show threshold cutoff for spikes
    hold on
    title(sprintf('%s; %d spikes',tlt,length(spike_times)));
    threshline = ones(length(data),1).*cutoff;
    plot(ax,threshline,'r--','LineWidth',2);
    if spike_times
        plot(spike_times,spike_vals,'r.','MarkerSize',10);
    end
    hold off
    ylim(y_axis_range);
    if ~isempty(dirs)
        trial_list = cell(length(dirs),1);
        for d=1:length(dirs)
            trial_list{d} = num2str(d);
            line(dur*(d-1)*[1 1],[min(data) 1.2*max(data)],'color','r');
% % %             % Temporal change: %%%%%%%
% % %             f=sprintf('text(%d, %d, ''%d'');',dur*(d-1),1.1*max(data),dirs(d));            
            % Do not write the directions, so no bias in the decision of trials to exclude            
            % Instead, just give each trial a number for recognition
            f=sprintf('text(%d, %d, ''%d'');',dur*(d-1),1.1*max(data),d);
            eval(f);
        end
        if manual
            [excluded_trials,~] = listdlg('ListString',trial_list,'CancelString','Include All','PromptString','Select trials to exclude');
        end
    end
end

return