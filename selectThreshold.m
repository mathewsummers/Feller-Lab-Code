function [xselect,yselect] = selectThreshold(default_cutoff)
% Demonstrates the default threshold for AP and enables to select manually
% NOTE: the data is stored in gca

% extract xdata and ydata from the specified axes
params.Axes = gca;
hc = get(params.Axes,'children');
xdata = get(hc,'xdata');
ydata = get(hc,'ydata');
select_lower_limit = 0; % In case there are high amplitude noises

if default_cutoff~=0
    selected = find(ydata<default_cutoff);
    hold on
    plot(xdata,default_cutoff*ones(1,length(xdata)),':r');
    plot(xdata(selected),ydata(selected),'or');
    hold off    
end
ButtonManual = questdlg('Are you satisfied with the default selected?','???','Yes','Select Manualy','Yes');
switch ButtonManual
    case 'Yes'
        selection_flag = false;
    case 'Select Manualy'
        selection_flag = true;
        plot(xdata,ydata,'k');
end

while selection_flag
    plot(xdata,ydata,'k');
    disp('Select Y threshold');
    [~,y] = ginput(1);
    if ~select_lower_limit
        selected = find(ydata<y);
        min_y = y;
    else
        selected = find (ydata<=y & ydata>min_y);        
    end
    hold on
    plot(xdata(selected),ydata(selected),'r.','MarkerSize',10);
    hold off

    % verify - pop up a dialog
    if ~select_lower_limit
        ButtonSelect = questdlg('Are you satisfied with the points selected?','???','Yes','Redo selection','Choose upper limit','Yes');
    else
        ButtonSelect = questdlg('Are you satisfied with the points selected?','???','Yes','Redo upper limit selection','Yes');
    end
   switch ButtonSelect            
     case 'Yes'
        selection_flag = false;  
     case 'Redo selection'
         plot(xdata,ydata,'k');
     case 'Choose upper limit'
         select_lower_limit = 1;
         plot(xdata,ydata,'k');
       case 'Redo upper limit selection'
           plot(xdata,ydata,'k');
   end
end

xselect = xdata(selected);
yselect = ydata(selected);

return