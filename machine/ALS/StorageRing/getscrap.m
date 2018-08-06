function [PosH, PosT, PosB, RunFlag] = getscrap(Name)
% [PosH, PosT, PosB, RunFlag] = getscrap;
%                       or
% [ScraperPosition, RunFlag] = getscrap(Name);
%
%          Name = 'top', 'bottom' ('bot'), or 'horizontal' ('hor')
%
%          PosH = Horizontal scraper position [mm]
%          PosT = Top scraper position [mm]
%          PosB = Bottom scraper position [mm]
%      RunFlag  = # of motors running, 0-stopped
%

%  2002-04-18, started modifying routine for new scraper channels since scrapers have been moved to SR03
%
% Things to check:
%    are there new channels that need to be included? (i.e., DMOV, LIMITS, etc.)

if nargin == 1
	if isstr(Name)
		if strcmp(upper(Name),'HORIZONTAL') | strcmp(upper(Name),'HOR')
			PosH = scaget('SR03S___SCRAPH_AC00.EPOS');  % AMxx.EPOS is the monitor value
         PosT = scaget('SR03S___SCRAPH_AC00.MOVN');
         PosB = 0;
		elseif strcmp(upper(Name),'TOP')
			PosH = scaget('SR03S___SCRAPT_AC01.EPOS');
			PosT = scaget('SR03S___SCRAPT_AC01.MOVN');
         PosB = 0;
		elseif strcmp(upper(Name),'BOTTOM') | strcmp(upper(Name),'BOT')
			PosH = scaget('SR03S___SCRAPB_AC02.EPOS');
			PosT = scaget('SR03S___SCRAPB_AC02.MOVN');
         PosB = 0;
		else
			error('Input string not known.');
		end
	else
		error('Input must be a string.');
   end
else
   PosH = scaget('SR03S___SCRAPH_AC00.EPOS');
   PosT = scaget('SR03S___SCRAPT_AC01.EPOS');
   PosB = scaget('SR03S___SCRAPB_AC02.EPOS');
   
   if nargout == 4
      RunFlag1 = scaget('SR03S___SCRAPH_AC00.MOVN');
      RunFlag2 = scaget('SR03S___SCRAPT_AC01.MOVN');
      RunFlag3 = scaget('SR03S___SCRAPB_AC02.MOVN');    
      RunFlag = RunFlag1 | RunFlag2 | RunFlag3;
   end
end

PosH = PosH/1000;
PosT = PosT/1000;
PosB = PosB/1000;