function Err = setscrap(PosH, PosT, PosB, WaitFlag);
%  Error = setscrap(New PosH, New PosT, New PosB, WaitFlag);
%        or
%  Error = setscrap('Name', Position, WaitFlag);
%
%            Name = 'top', 'bottom' ('bot'), or 'horizontal' ('hor')
%
%            PosH = Horizontal scraper position (0, 70) [mm]
%            PosT = Top scraper position        (0, 25) [mm]
%            PosB = Bottom scraper position     (0, 25) [mm]
%        WaitFlag = 0-return immediately, 1-return when ramp is done (default)
%
%           Error = 0 - no errors occurred
%                   1 - timed out waiting for a scraper reach the goal position 
%
%   For each scraper, 0mm is fully retracted, while 20mm is beam-center for the top and bottom
%      scraper, and 60mm is beam-center for the horizontal scraper.
%
%   Calling setscrap with no inputs, sets all scrapers to their home position.
%

%  2002-04-18, started modifying routine for new scraper channels since scrapers have been moved to SR03
%
% NEW VALUES ARE IN [MICRONS], NOT [MM]!!
% Things to check when install is done:
% 		what routines call this one and do they need changes due to new ranges?
%		are there new channels that need to be included?


ScraperTol = 0.2; % mm value
%ScraperTol = 200; % micron value

if nargout >= 1
   Err = 0;
end

% Inputs checking
if nargin == 0 
	%setscrap(-28,9,-9); return; %old limits in [mm] here
	setscrap(0, 0, 0); return; %old limits in microns
elseif  nargin == 1
	error('Required 0, 2, 3, or 4 inputs.');
elseif  nargin == 2
	if ~isstr(PosH)
		error('For 2 inputs the first must be a string.');
   end
   if PosT > 70
      error('The scraper positions must be entered in [mm]!');
   end   
elseif nargin == 3
	WaitFlag = 1;
   if (PosH > 70 | PosT > 25 | PosB > 25)
      error('The scraper positions must be entered in [mm]!');
   end   
end


if isstr(PosH)
	if nargin == 3
		WaitFlag = PosB;
	else
		WaitFlag = 1;
	end

	if strcmp(upper(PosH),'HORIZONTAL') | strcmp(upper(PosH),'HOR')
		PosH = PosT;
		PosT = scaget('SR03S___SCRAPT_AC01.VAL')/1000;  % ACxx.VAL are AC values, ACxx.EPOS are AM values
		PosB = scaget('SR03S___SCRAPB_AC02.VAL')/1000;
	elseif strcmp(upper(PosH),'TOP')
		PosH = scaget('SR03S___SCRAPH_AC00.VAL')/1000;
		PosB = scaget('SR03S___SCRAPB_AC02.VAL')/1000;
	elseif strcmp(upper(PosH),'BOTTOM') | strcmp(upper(PosH),'BOT')
		PosB = PosT;
		PosH = scaget('SR03S___SCRAPH_AC00.VAL')/1000;
		PosT = scaget('SR03S___SCRAPT_AC01.VAL')/1000;
	else
		error('Input string not known.');
	end
end


% Check scraper limits
%if PosH>5 | PosH<-28
if PosH>70 | PosH<0  %old limits, new units
	error('Scraper limit exceeded: horizontal scraper bounds [0 70].');
else
	% OK to set scraper
	scaput('SR03S___SCRAPH_AC00.VAL', PosH*1000);
end


if PosT>25 | PosT<0  %old limits, new units
	error('Scraper limit exceeded: top scraper bounds [0 25].');
else
	% OK to set scraper
	scaput('SR03S___SCRAPT_AC01.VAL', PosT*1000);
end


if PosB>25 | PosB<0  %old limits, new units
	error('Scraper limit exceeded: bottom scraper bounds [0 25].');
else
	% OK to set scraper
	scaput('SR03S___SCRAPB_AC02.VAL', PosB*1000);
end



if WaitFlag
	% Check for tolerance band on AC-AM
	[PosHam, PosTam, PosBam, RunFlag] = getscrap;

	% Delay for runflag
	sleep(2);
	
	t0 = gettime;
	NotDoneFlag = 1;
 	while NotDoneFlag
		[PosHam, PosTam, PosBam, RunFlag] = getscrap;
		NotDoneFlag = RunFlag | (abs(PosH-PosHam)>ScraperTol) | (abs(PosT-PosTam)>ScraperTol) | (abs(PosB-PosBam)>ScraperTol) ;

		if (gettime-t0 > 60)
			disp('WARNING:  SETSCRAP time out (60 seconds):  scraper position out of tolerance or RunFlag still high');
         disp('                                           or setpoint out of bounds (see help setscrap for details).');
         if nargout >= 1
            Err = 1;
         end
         break;
		end
	end

	% Extra delay 
	%sleep(.5);
end



