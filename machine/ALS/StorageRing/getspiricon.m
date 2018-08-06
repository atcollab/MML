function Output = getspiricon(Action, InfoFlag)
% Output = getspiricon(Action, InfoFlag);
%
%  Action = 'Xrms',  Outout = Horizontal Beam Size [microns rms]
%           'Yrms',  Outout = Vertical   Beam Size [microns rms]
%           'X',     Outout = Horizontal Beam Position [mm]
%           'Y',     Outout = Vertical   Beam Position [mm]
%           'Orient',Outout = Orientation             [deg]
%           [] or 'PrintAll' then all spiricon data will be printed to the screen
%
%  InfoFlag = 0    -> do not print status information, 
%             else -> print status information
%

if nargin < 1
	Action = 'PrintAll';
end
if isempty(Action)
	Action = 'PrintAll';
end

if nargin < 2
	if nargout == 0
		InfoFlag = 1;
	else
		InfoFlag = 0;
	end
end


switch Action
	
case 'PrintAll'
	getspiricon('Xrms',1);
	getspiricon('Yrms',1);
	getspiricon('X',1);
	getspiricon('Y',1);
	getspiricon('Orient',1);
	Output = [];
	return;
	
case 'Xrms'
	
	Output = scaget('SR04S___SPIRICOAM07') / 2.0;     % RMS
	
	if InfoFlag
		fprintf('  Horizontal Beam Size = %f [microns rms]\n', Output);
	end
	
case 'Yrms'
	
	Output = scaget('SR04S___SPIRICOAM08') / 2.0;     % RMS
	
	if InfoFlag
		fprintf('  Vertical   Beam Size = %f [microns rms]\n', Output);
	end
	
case 'X'
	
	Output = scaget('SR04S___SPIRICOAM01');
	
	if InfoFlag
		fprintf('  Horizontal Position = %f [mm]\n', Output);
	end
	
case 'Y'
	
	Output = scaget('SR04S___SPIRICOAM02');
	
	if InfoFlag
		fprintf('  Vertical   Position = %f [mm]\n', Output);
	end
   
case 'Orient'
	
	Output = scaget('SR04S___SPIRICOAM03');
	
	if InfoFlag
		fprintf('  Orientation = %f [deg]\n', Output);
	end
   
otherwise
	fprintf('  No action for %s.\n', Action);
end

