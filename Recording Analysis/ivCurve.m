function [Rin,rSq] = ivCurve(d,vSteps,hideOutput,si)

if nargin < 4 || isempty(si)
    si = 100;
end

if nargin < 3 || isempty(hideOutput)
    hideOutput = 0;
end

if nargin < 2 || isempty(vSteps)
    vSteps = -70:10:0; %mV
end

%Ensure matching number of trials and voltage steps
[nPts,nVHold] = size(d);
assert(nVHold == numel(vSteps),'Unexpected number of voltage steps, input voltages manually.')

%Find range of points to sample
dt = si*1e-6;
tStart = .15; %sec
tEnd = .6; %sec

%Find meane current over allotted time points for each voltage step
avgStart = round(tStart / dt);
avgEnd = round(tEnd / dt);
dSteps = d(avgStart:avgEnd,:);
y = mean(dSteps,1);

%Compute linear regression
[pp,rSq] = computeRegression(vSteps,y);
Rin = 1 / (pp(1) * 1e-9);%convert slope from nS to S

%Plot outputs unless suppressed
if ~hideOutput
    t = 0:dt:(nPts - 1)*dt;
    yTop = 1.2* max(max(dSteps));
    yBottom = 1.2* min(min(dSteps));
    
    figure;
    subplot(1,2,1)
    plot(t,d,'k');%'linewidth',.5);
    ylim([yBottom yTop]);
    xlim([tStart-.1, tEnd+.1]);
    xlabel('Time (sec)');
    ylabel('Current (pA)');
    
    str = sprintf('Slope: %3.1f MOhms  |  R^2: %3.2f',Rin*1e-6,rSq);
    subplot(1,2,2)
    plot(vSteps,polyval(pp,vSteps),'-r','linewidth',1.5)
    hold on
    plot(vSteps,y,'ko-','linewidth',1.5)
    xlim([min(vSteps) - 10, max(vSteps) + 10]);
    xlabel('Voltage (mV)');
    ylabel('Current (pA)');
    title(str);
end

end

function [pp,rSq] = computeRegression(x,y)
pp = polyfit(x,y,1);
yFit = polyval(pp,x);
ssResid = sum((y - yFit).^2);
ssTotal = (length(y) - 1) * var(y);
rSq = 1 - ssResid/ssTotal;
end
