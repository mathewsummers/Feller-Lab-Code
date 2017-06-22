function [h,ax,fig_num] = makeTracePlot(data,SampInt,varargin)
% Plots a clampex trace loaded with abfload.m
% INPUTS
%     data           a Nx1 data vector
%     SampInt        the Sampling Interval in microseconds
%     font_size      scalar specifying font size on plot
%     ax_offset      number in samples to offset X axis  
%     y_label        string, ylabel
%     x_label        string, xlabel
%     y_axis_range   'auto' or [min max]
% OUTPUTS
%     h                       handle to plot
%     ax                    1xN x-axis in seconds
%     fig_num       the figure number, so we can close it later
% 2008-11-16 JE

font_size = 18;
ax_offset = 0;
y_label = 'Current (pA)';
x_label = 'Time (s)';
y_axis_range = 'auto';
pvpmod(varargin);

ax = ax_offset:(ax_offset+(length(data)-1));
ax = (ax.*SampInt.*1e-6)';
scrsz = get(0,'ScreenSize'); %[left, bottom, width, height]
fig_num = figure('Position',[50 scrsz(4)/20 scrsz(3)/1.5 scrsz(4)/3]);
set(gca,'FontSize',font_size);
set(gca,'FontName','Arial');
h = plot(ax,data,'k');
ylim(y_axis_range);
ylabel(y_label,'FontSize',font_size);
xlabel(x_label,'FontSize',font_size);
box off
return
