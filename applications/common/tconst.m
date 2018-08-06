function [tc,maxrate] = tconst(t,y)
%TCONST - Compute the time constant assuming a first order system
%  [tc,maxrate] = tconst(t,y)


%ii=min(find(y(:,1)/y(max(size(y)),1)>=.6321));tc=t(ii);
%yrate = diff(y(:,1))./diff(t);

ii = min(find(y/max(y) >= .6321));
tc = t(ii);
yrate = diff(y)./diff(t);


fprintf('          time constant = %g (seconds)\n', tc);
fprintf('  approximate bandwidth = %g (rad/sec),  %g (Hertz)\n', 1/tc, 1/tc/2/pi);
fprintf('    Max. rate of change = %g\n', max(abs(yrate)));