function [data, t, i] = arplot_SR03_vacuum(monthStr, days, year1, month2Str, days2, year2)
% [data, t] = arplot_SR03_vacuum(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
%
% Plots SR03 vaccum

BooleanFlag = 0;

semilogy_plotflag = 1;

% Inputs
if nargin < 2
   error('ARPLOTS:  You need at least two input arguments.');
elseif nargin == 2
   tmp = clock;
   year1 = tmp(1);
   monthStr2 = [];
   days2 = [];
   year2 = [];
elseif nargin == 3
   monthStr2 = [];
   days2 = [];
   year2 = [];
elseif nargin == 4
   error('ARPLOTS:  You need 2, 3, 5, or 6 input arguments.');
elseif nargin == 5
   tmp = clock;
   year2 = tmp(1);
elseif nargin == 6
else
   error('ARPLOTS:  Inputs incorrect.');
end

arplot_channel(['SR03C___IP1____AM00';'SR03C___IP2____AM00';'SR03C___IP3____AM00';'SR03C___IP4____AM00';'SR03C___IP5____AM00';'SR03C___IP6____AM00'],monthStr, days, year1, monthStr2, days2, year2);

arplot_channel(['SR03S___IP1____AM00';'SR03S___IP2____AM00';'SR03S___IP4____AM01';'SR03S___IP5____AM02';'SR03S___IP6____AM03';'SR03S___IP7____AM04';'SR03S___IP8____AM04'],monthStr, days, year1, monthStr2, days2, year2);

arplot_channel(['cmm:beam_current  ';'Topoff_lifetime_AM'],monthStr, days, year1, monthStr2, days2, year2);
