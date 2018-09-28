function [topHz,c] = testFreq(spikes,tEnd,showLess)
%function still needs work
if nargin<3 || isempty(showLess)
    showLess = 0;
end
nPts = 5; %10 for 200 ms window, 5 for 100 ms
dt = .01; %10 ms bins

t = 0:dt:(tEnd - dt);

a = normpdf(-5*nPts:5*nPts,0,nPts); %produce gaussian filter, 10 pt sigma, 2 sigma = width, width is thus 200 ms
% nPts = nPts * dt;
% t = -.25:dt:.25
% a = (1/(nPts * sqrt(2*pi))).*exp(-(t.^2)/(2*(nPts^2)));
a = a .* (1 / (sum(a) * dt));
%a = a / max(a); %normalize

N = histcounts(spikes,[t tEnd]); %bin spikes, extra timepoint for bin edges

c = conv(N,a,'same'); %filter spike bins with guassian
%sampInt = dt * 2 * nPts;
%c = c / sampInt;
if ~showLess
    plot(t,c,'linewidth',1) %plot frequency
end

topHz = max(c);

end