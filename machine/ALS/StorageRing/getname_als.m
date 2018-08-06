function  [ChannelName, ErrorFlag] = getname_als(Family, DeviceList, ChanTypeFlag)
% ChannelName = getname(Family, DeviceList, ChanTypeStr)
%
%   Inputs:  Family name
%            DeviceList ([Sector Device #] or [element #]) (default: whole family)
%            ChanTypeStr 0 -> 'AM' channel type (default)
%                        1 -> 'AC' channel type
%                        2 -> 'BM' channel type
%                        3 -> 'BC' channel type
%
%   Outputs: ChannelName = IOC channel name corresponding to the family and DeviceList
%            ErrorFlag = 0 if family name was found
%                       -1 if no family name was found, ChannelName = Family

ErrorFlag = 0;

if nargin == 0
    error('Must have at least one input (''Family'')!');
elseif nargin == 1
    DeviceList = getlist(Family);
    ChanTypeFlag = 1;
elseif nargin == 2
    ChanTypeFlag = 1;
elseif nargin > 3
    error('GETNAME_ALS: maximum of 3 input arguments.');
end


if (ChanTypeFlag==0)
    ChanTypeStr = 'AM';	% Analog Monitor (AM)
elseif (ChanTypeFlag==1)
    ChanTypeStr = 'AC';	% Analog Control (AC)
elseif (ChanTypeFlag==2)
    ChanTypeStr ='BM';	% Boolean monitor (BM)
    EPICSChanTypeStr ='bi';
elseif (ChanTypeFlag==3)
    ChanTypeStr ='BC';	% Boolean Control (BC)
    EPICSChanTypeStr ='bo';
else
    error('Channel type unknown');
end


if isempty(DeviceList)
    DeviceList = getlist(Family);
elseif (size(DeviceList,2) == 1)
    DeviceList = elem2dev(Family, DeviceList);
end

ChannelName = [];

for i = 1:size(DeviceList,1)
    SectorList = DeviceList(i,1);
    DevList = DeviceList(i,2);
    
    % First look for arc-BPM that have been modified with new Bergoz electronics
    if strcmp(Family,'BPMx') && SectorList==1 && DevList==2
        ChanName = sprintf('SR%02dS___IBPM%1dX_%s02',  1, 2, ChanTypeStr);
        
    elseif strcmp(Family,'BPMx') && SectorList==1 && any(DevList==[2 4 6 7 8]+1)
        ChanName = sprintf('SR%02dC:BPM%1d:SA:X',  SectorList, DevList-1);
    elseif strcmp(Family,'BPMy') && SectorList==1 && any(DevList==[2 4 6 7 8]+1)
        ChanName = sprintf('SR%02dC:BPM%1d:SA:Y',  SectorList, DevList-1); 
        
    elseif strcmp(Family,'BPMx') && SectorList==2 && any(DevList==[2 7]+1)
        ChanName = sprintf('SR%02dC:BPM%1d:SA:X',  SectorList, DevList-1);
    elseif strcmp(Family,'BPMy') && SectorList==2 && any(DevList==[2 7]+1)
        ChanName = sprintf('SR%02dC:BPM%1d:SA:Y',  SectorList, DevList-1); 

    elseif strcmp(Family,'BPMx') && SectorList==3 && any(DevList==[2 7 8]+1)
        ChanName = sprintf('SR%02dC:BPM%1d:SA:X',  SectorList, DevList-1);
    elseif strcmp(Family,'BPMy') && SectorList==3 && any(DevList==[2 7 8]+1)
        ChanName = sprintf('SR%02dC:BPM%1d:SA:Y',  SectorList, DevList-1); 
    
    elseif strcmp(Family,'BPMx') && SectorList==4 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC:BPM%1d:SA:X',  SectorList, DevList-1);
    elseif strcmp(Family,'BPMy') && SectorList==4 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC:BPM%1d:SA:Y',  SectorList, DevList-1); 
    
    elseif strcmp(Family,'BPMx') && SectorList==5 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC:BPM%1d:SA:X',  SectorList, DevList-1);
    elseif strcmp(Family,'BPMy') && SectorList==5 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC:BPM%1d:SA:Y',  SectorList, DevList-1); 

    elseif strcmp(Family,'BPMx') && SectorList==6 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC:BPM%1d:SA:X',  SectorList, DevList-1);
    elseif strcmp(Family,'BPMy') && SectorList==6 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC:BPM%1d:SA:Y',  SectorList, DevList-1); 

    elseif strcmp(Family,'BPMx') && SectorList==7 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC:BPM%1d:SA:X',  SectorList, DevList-1);
    elseif strcmp(Family,'BPMy') && SectorList==7 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC:BPM%1d:SA:Y',  SectorList, DevList-1); 

    elseif strcmp(Family,'BPMx') && SectorList==8 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC:BPM%1d:SA:X',  SectorList, DevList-1);
    elseif strcmp(Family,'BPMy') && SectorList==8 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC:BPM%1d:SA:Y',  SectorList, DevList-1);
        
    elseif strcmp(Family,'BPMx') && SectorList==9 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC:BPM%1d:SA:X',  SectorList, DevList-1);
    elseif strcmp(Family,'BPMy') && SectorList==9 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC:BPM%1d:SA:Y',  SectorList, DevList-1);
        
    elseif strcmp(Family,'BPMx') && SectorList==10 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC:BPM%1d:SA:X',  SectorList, DevList-1);
    elseif strcmp(Family,'BPMy') && SectorList==10 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC:BPM%1d:SA:Y',  SectorList, DevList-1);
        
    elseif strcmp(Family,'BPMx') && SectorList==11 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC:BPM%1d:SA:X',  SectorList, DevList-1);
    elseif strcmp(Family,'BPMy') && SectorList==11 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC:BPM%1d:SA:Y',  SectorList, DevList-1);
        
    elseif strcmp(Family,'BPMx') && SectorList==12 && any(DevList==[1 2 7]+1)
        ChanName = sprintf('SR%02dC:BPM%1d:SA:X',  SectorList, DevList-1);
    elseif strcmp(Family,'BPMy') && SectorList==12 && any(DevList==[1 2 7]+1)
        ChanName = sprintf('SR%02dC:BPM%1d:SA:Y',  SectorList, DevList-1);
        
% Golden Setpoints - first the bew BPMs - using legacy channels on the crioc        
    elseif strcmp(Family,'BPMxGoldenSetpoint') && SectorList==1 && any(DevList==[2 7 8]+1)
        ChanName = sprintf('SR%02dC___BPM%1d_X_GOLDEN',  SectorList, DevList-1);
    elseif strcmp(Family,'BPMyGoldenSetpoint') && SectorList==1 && any(DevList==[2 7 8]+1)
        ChanName = sprintf('SR%02dC___BPM%1d_Y_GOLDEN',  SectorList, DevList-1);
        
    elseif strcmp(Family,'BPMxGoldenSetpoint') && SectorList==2 && any(DevList==[2 7]+1)
        ChanName = sprintf('SR%02dC___BPM%1d_X_GOLDEN',  SectorList, DevList-1);
    elseif strcmp(Family,'BPMyGoldenSetpoint') && SectorList==2 && any(DevList==[2 7]+1)
        ChanName = sprintf('SR%02dC___BPM%1d_Y_GOLDEN',  SectorList, DevList-1);

    elseif strcmp(Family,'BPMxGoldenSetpoint') && SectorList==3 && any(DevList==[2 7 8]+1)
        ChanName = sprintf('SR%02dC___BPM%1d_X_GOLDEN',  SectorList, DevList-1);
    elseif strcmp(Family,'BPMyGoldenSetpoint') && SectorList==3 && any(DevList==[2 7 8]+1)
        ChanName = sprintf('SR%02dC___BPM%1d_Y_GOLDEN',  SectorList, DevList-1);
    
    elseif strcmp(Family,'BPMxGoldenSetpoint') && SectorList==4 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC___BPM%1d_X_GOLDEN',  SectorList, DevList-1);
    elseif strcmp(Family,'BPMyGoldenSetpoint') && SectorList==4 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC___BPM%1d_Y_GOLDEN',  SectorList, DevList-1);
    
    elseif strcmp(Family,'BPMxGoldenSetpoint') && SectorList==5 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC___BPM%1d_X_GOLDEN',  SectorList, DevList-1);
    elseif strcmp(Family,'BPMyGoldenSetpoint') && SectorList==5 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC___BPM%1d_Y_GOLDEN',  SectorList, DevList-1);

    elseif strcmp(Family,'BPMxGoldenSetpoint') && SectorList==6 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC___BPM%1d_X_GOLDEN',  SectorList, DevList-1);
    elseif strcmp(Family,'BPMyGoldenSetpoint') && SectorList==6 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC___BPM%1d_Y_GOLDEN',  SectorList, DevList-1);

    elseif strcmp(Family,'BPMxGoldenSetpoint') && SectorList==7 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC___BPM%1d_X_GOLDEN',  SectorList, DevList-1);
    elseif strcmp(Family,'BPMyGoldenSetpoint') && SectorList==7 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC___BPM%1d_Y_GOLDEN',  SectorList, DevList-1);

    elseif strcmp(Family,'BPMxGoldenSetpoint') && SectorList==8 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC___BPM%1d_X_GOLDEN',  SectorList, DevList-1);
    elseif strcmp(Family,'BPMyGoldenSetpoint') && SectorList==8 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC___BPM%1d_Y_GOLDEN',  SectorList, DevList-1);
        
    elseif strcmp(Family,'BPMxGoldenSetpoint') && SectorList==9 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC___BPM%1d_X_GOLDEN',  SectorList, DevList-1);
    elseif strcmp(Family,'BPMyGoldenSetpoint') && SectorList==9 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC___BPM%1d_Y_GOLDEN',  SectorList, DevList-1);
        
    elseif strcmp(Family,'BPMxGoldenSetpoint') && SectorList==10 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC___BPM%1d_X_GOLDEN',  SectorList, DevList-1);
    elseif strcmp(Family,'BPMyGoldenSetpoint') && SectorList==10 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC___BPM%1d_Y_GOLDEN',  SectorList, DevList-1);
        
    elseif strcmp(Family,'BPMxGoldenSetpoint') && SectorList==11 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC___BPM%1d_X_GOLDEN',  SectorList, DevList-1);
    elseif strcmp(Family,'BPMyGoldenSetpoint') && SectorList==11 && any(DevList==[1 2 7 8]+1)
        ChanName = sprintf('SR%02dC___BPM%1d_Y_GOLDEN',  SectorList, DevList-1);
        
    elseif strcmp(Family,'BPMxGoldenSetpoint') && SectorList==12 && any(DevList==[1 2 7]+1)
        ChanName = sprintf('SR%02dC___BPM%1d_X_GOLDEN',  SectorList, DevList-1);
    elseif strcmp(Family,'BPMyGoldenSetpoint') && SectorList==12 && any(DevList==[1 2 7]+1)
        ChanName = sprintf('SR%02dC___BPM%1d_Y_GOLDEN',  SectorList, DevList-1);

% Golden Setpoint for all other BPMs
    elseif strcmp(Family,'BPMxGoldenSetpoint')
        tmpname = getname_als('BPMx', [SectorList DevList], 0);
        ChanName = strcat(tmpname(1:end-4), 'GOLDEN');
    elseif strcmp(Family,'BPMyGoldenSetpoint')
        tmpname = getname_als('BPMy', [SectorList DevList], 0);
        ChanName = strcat(tmpname(1:end-4), 'GOLDEN');



% Vertical BPMs
    elseif strcmp(Family,'BPMy') && SectorList==1 && DevList==2
        ChanName = sprintf('SR%02dS___IBPM%1dY_%s03',  1, 2, ChanTypeStr);

    elseif strcmp(Family,'BPMx') && SectorList==12 && DevList==9
        ChanName = sprintf('SR%02dS___IBPM%1dX_%s00',  1, 1, ChanTypeStr);
    elseif strcmp(Family,'BPMy') && SectorList==12 && DevList==9
        ChanName = sprintf('SR%02dS___IBPM%1dY_%s01',  1, 1, ChanTypeStr);
        
    elseif strcmp(Family,'BPMx') && SectorList==2 && DevList==9
        ChanName = sprintf('SR%02dS___IBPM%1dX_%s00',  3, 1, ChanTypeStr);
    elseif strcmp(Family,'BPMy') && SectorList==2 && DevList==9
        ChanName = sprintf('SR%02dS___IBPM%1dY_%s01',  3, 1, ChanTypeStr);
    elseif strcmp(Family,'BPMx') && SectorList==3 && DevList==2
        ChanName = sprintf('SR%02dS___IBPM%1dX_%s02',  3, 2, ChanTypeStr);
    elseif strcmp(Family,'BPMy') && SectorList==3 && DevList==2
        ChanName = sprintf('SR%02dS___IBPM%1dY_%s03',  3, 2, ChanTypeStr);
        
        % Bergoz retrofit in center of arc
    elseif (strcmp(Family,'BPMx') && DevList==5)
        ChanName = sprintf('SR%02dC___BPM%1dXT_%s00',  SectorList,  4, ChanTypeStr);
    elseif (strcmp(Family,'BPMy') && DevList==5)
        ChanName = sprintf('SR%02dC___BPM%1dYT_%s01',  SectorList,  4, ChanTypeStr);
    elseif (strcmp(Family,'BPMx') && DevList==6)
        ChanName = sprintf('SR%02dC___BPM%1dXT_%s02',  SectorList,  5, ChanTypeStr);
    elseif (strcmp(Family,'BPMy') && DevList==6)
        ChanName = sprintf('SR%02dC___BPM%1dYT_%s03',  SectorList,  5, ChanTypeStr);

        % Bergoz retrofit in next to QFA magnets (2007-06-13), C. Steier, T. Scarvie
    elseif (strcmp(Family,'BPMx') && DevList==4) 
        ChanName = sprintf('SR%02dC___BPM%1dXT_%s00',  SectorList,  3, ChanTypeStr);
    elseif (strcmp(Family,'BPMy') && DevList==4) 
        ChanName = sprintf('SR%02dC___BPM%1dYT_%s00',  SectorList,  3, ChanTypeStr);
    elseif (strcmp(Family,'BPMx') && DevList==7) 
        ChanName = sprintf('SR%02dC___BPM%1dXT_%s00',  SectorList,  6, ChanTypeStr);
    elseif (strcmp(Family,'BPMy') && DevList==7) 
        ChanName = sprintf('SR%02dC___BPM%1dYT_%s00',  SectorList,  6, ChanTypeStr);
        
    elseif (strcmp(Family,'BPMx') && DevList==2 && SectorList==2)  % Used for LFB/TFB 
        ChanName = sprintf(' ');
    elseif (strcmp(Family,'BPMy') && DevList==2 && SectorList==2)  % Used for LFB/TFB 
        ChanName = sprintf(' ');

    elseif strcmp(Family,'BPMx') && (DevList==2 || DevList==3 || DevList==4 || DevList==5 || DevList==6 || DevList==7 || DevList==8 || DevList==9)
        ChanName = sprintf('SR%02dC___BPM%1d_X_%s00',  SectorList,  DevList-1, ChanTypeStr);
    elseif strcmp(Family,'BPMy') && (DevList==2 || DevList==3 || DevList==4 || DevList==5 || DevList==6 || DevList==7 || DevList==8 || DevList==9)
        ChanName = sprintf('SR%02dC___BPM%1d_Y_%s01',  SectorList,  DevList-1, ChanTypeStr);
        
    elseif (strcmp(Family,'BPMx') && DevList==1)
        ChanName = sprintf('SR%02dS___IBPM%1dX_%s02',  SectorList,  2, ChanTypeStr);
    elseif (strcmp(Family,'BPMy') && DevList==1)
        ChanName = sprintf('SR%02dS___IBPM%1dY_%s03',  SectorList,  2, ChanTypeStr);
    elseif (strcmp(Family,'BPMx') && DevList==10)
        ChanName = sprintf('SR%02dS___IBPM%1dX_%s00',  SectorList+1,  1, ChanTypeStr);
    elseif (strcmp(Family,'BPMy') && DevList==10)
        ChanName = sprintf('SR%02dS___IBPM%1dY_%s01',  SectorList+1,  1, ChanTypeStr);
        
    elseif (strcmp(Family,'BPMx') && DevList==11 && (SectorList==3 || SectorList==5 || SectorList==6 || SectorList==10))
        ChanName = sprintf('SR%02dS___IBPM%1dX_%s00',  SectorList+1,  3, ChanTypeStr);
    elseif (strcmp(Family,'BPMy') && DevList==11 && (SectorList==3 || SectorList==5 || SectorList==6 || SectorList==10))
        ChanName = sprintf('SR%02dS___IBPM%1dY_%s01',  SectorList+1,  3, ChanTypeStr);
    elseif (strcmp(Family,'BPMx') && DevList==12 && (SectorList==3 || SectorList==5 || SectorList==6 || SectorList==10))
        ChanName = sprintf('SR%02dS___IBPM%1dX_%s02',  SectorList+1,  4, ChanTypeStr);
    elseif (strcmp(Family,'BPMy') && DevList==12 && (SectorList==3 || SectorList==5 || SectorList==6 || SectorList==10))
        ChanName = sprintf('SR%02dS___IBPM%1dY_%s03',  SectorList+1,  4, ChanTypeStr);
        
    elseif (strcmp(Family,'BPMxTimeConstant') || strcmp(Family,'BPMyTimeConstant')) && (DevList==2) && (SectorList==1)
        ChanName = sprintf('SR%02dS___IBPM___AC00', SectorList);
    elseif (strcmp(Family,'BPMxTimeConstant') || strcmp(Family,'BPMyTimeConstant')) && (DevList==9) && (SectorList==2)
        ChanName = sprintf('SR%02dS___IBPM___AC00', SectorList);
    elseif (strcmp(Family,'BPMxTimeConstant') || strcmp(Family,'BPMyTimeConstant')) && (DevList==2) && (SectorList==3)
        ChanName = sprintf('SR%02dS___IBPM___AC00', SectorList);
    elseif (strcmp(Family,'BPMxTimeConstant') || strcmp(Family,'BPMyTimeConstant')) && (DevList==9) && (SectorList==12)
        ChanName = sprintf('SR%02dS___IBPM___AC00', SectorList);
    elseif (strcmp(Family,'BPMxTimeConstant') || strcmp(Family,'BPMyTimeConstant')) && (DevList==2 || DevList==3 || DevList==8 || DevList==9)
        ChanName =' ';
    elseif (strcmp(Family,'BPMxTimeConstant') || strcmp(Family,'BPMyTimeConstant')) && (DevList==1) && (SectorList==1)
        ChanName =' ';
    elseif (strcmp(Family,'BPMxTimeConstant') || strcmp(Family,'BPMyTimeConstant')) && (DevList==5 || DevList==6) && (SectorList==4 || SectorList==8 || SectorList==12)
        ChanName = sprintf('SR%02dC___BPM__T_AC00', SectorList);
    elseif strcmp(Family,'BPMxTimeConstant') || strcmp(Family,'BPMyTimeConstant')
        ChanName = sprintf('SR%02dS___IBPM___AC00', SectorList);
        % End of BPM family
        
        % Old style BPM
    elseif (strcmp(Family,'BPM96x'))
        ChanName = sprintf('SR%02dC___BPM%1d_X_%s00',  SectorList,  DevList, ChanTypeStr);
    elseif (strcmp(Family,'BPM96y'))
        ChanName = sprintf('SR%02dC___BPM%1d_Y_%s01',  SectorList,  DevList, ChanTypeStr);
        
        % Old naming for IDBPMs
    elseif (strcmp(Family,'IDBPMx') && DevList==1)
        ChanName = sprintf('SR%02dS___IBPM%1dX_%s00',  SectorList,  DevList, ChanTypeStr);
    elseif (strcmp(Family,'IDBPMy') && DevList==1)
        ChanName = sprintf('SR%02dS___IBPM%1dY_%s01',  SectorList,  DevList, ChanTypeStr);
    elseif (strcmp(Family,'IDBPMx') && DevList==2)
        ChanName = sprintf('SR%02dS___IBPM%1dX_%s02',  SectorList,  DevList, ChanTypeStr);
    elseif (strcmp(Family,'IDBPMy') && DevList==2)
        ChanName = sprintf('SR%02dS___IBPM%1dY_%s03',  SectorList,  DevList, ChanTypeStr);
        
    elseif (strcmp(Family,'IDBPMx') && DevList==3 && (SectorList==4 || SectorList==6 || SectorList==7 || SectorList==11))
        ChanName = sprintf('SR%02dS___IBPM%1dX_%s00',  SectorList,  DevList, ChanTypeStr);
    elseif (strcmp(Family,'IDBPMy') && DevList==3 && (SectorList==4 || SectorList==6 || SectorList==7 || SectorList==11))
        ChanName = sprintf('SR%02dS___IBPM%1dY_%s01',  SectorList,  DevList, ChanTypeStr);
    elseif (strcmp(Family,'IDBPMx') && DevList==4 && (SectorList==4 || SectorList==6 || SectorList==7 || SectorList==11))
        ChanName = sprintf('SR%02dS___IBPM%1dX_%s02',  SectorList,  DevList, ChanTypeStr);
    elseif (strcmp(Family,'IDBPMy') && DevList==4 && (SectorList==4 || SectorList==6 || SectorList==7 || SectorList==11))
        ChanName = sprintf('SR%02dS___IBPM%1dY_%s03',  SectorList,  DevList, ChanTypeStr);
        
        % Moved SR04, SR08, and SR12 BPMs from superbend crates to ffb crates - all element numbers went to zero - (2007-09-05)
    elseif (strcmp(Family,'BBPMx') && DevList==5) && (SectorList==4 || SectorList==8 || SectorList==12)
        ChanName = sprintf('SR%02dC___BPM%1dXT_%s00',  SectorList,  4, ChanTypeStr);
    elseif (strcmp(Family,'BBPMy') && DevList==5) && (SectorList==4 || SectorList==8 || SectorList==12)
        ChanName = sprintf('SR%02dC___BPM%1dYT_%s00',  SectorList,  4, ChanTypeStr);
    elseif (strcmp(Family,'BBPMx') && DevList==6) && (SectorList==4 || SectorList==8 || SectorList==12)
        ChanName = sprintf('SR%02dC___BPM%1dXT_%s00',  SectorList,  5, ChanTypeStr);
    elseif (strcmp(Family,'BBPMy') && DevList==6) && (SectorList==4 || SectorList==8 || SectorList==12)
        ChanName = sprintf('SR%02dC___BPM%1dYT_%s00',  SectorList,  5, ChanTypeStr);

    elseif (strcmp(Family,'BBPMx') && DevList==5) %&& (SectorList==1 || SectorList==2 || SectorList==3 || SectorList==5 || SectorList==6 || SectorList==7 || SectorList==9 || SectorList==10 || SectorList==11)
        ChanName = sprintf('SR%02dC___BPM%1dXT_%s00',  SectorList,  4, ChanTypeStr);
    elseif (strcmp(Family,'BBPMy') && DevList==5) %&& (SectorList==1 || SectorList==2 || SectorList==3 || SectorList==5 || SectorList==6 || SectorList==7 || SectorList==9 || SectorList==10 || SectorList==11)
        ChanName = sprintf('SR%02dC___BPM%1dYT_%s01',  SectorList,  4, ChanTypeStr);
    elseif (strcmp(Family,'BBPMx') && DevList==6) %&& (SectorList==1 || SectorList==2 || SectorList==3 || SectorList==5 || SectorList==6 || SectorList==7 || SectorList==9 || SectorList==10 || SectorList==11)
        ChanName = sprintf('SR%02dC___BPM%1dXT_%s02',  SectorList,  5, ChanTypeStr);
    elseif (strcmp(Family,'BBPMy') && DevList==6) %&& (SectorList==1 || SectorList==2 || SectorList==3 || SectorList==5 || SectorList==6 || SectorList==7 || SectorList==9 || SectorList==10 || SectorList==11)
        ChanName = sprintf('SR%02dC___BPM%1dYT_%s03',  SectorList,  5, ChanTypeStr);
        
    elseif (strcmp(Family,'HCM') && DevList==1)
        ChanName = sprintf('SR%02dC___HCM1___%s00',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'HCMready') && DevList==1 && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___HCM1___BM01',  SectorList);
    elseif (strcmp(Family,'HCMon') && DevList==1    && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___HCM1___BM02',  SectorList);
    elseif (strcmp(Family,'HCMon') && DevList==1    && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___HCM1___BC16',  SectorList);
    elseif (strcmp(Family,'HCMreset') && DevList==1 && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___HCM1_R_BC17',  SectorList);
    elseif (strcmp(Family,'HCMdac') && DevList==1   && (ChanTypeFlag==1))
        ChanName = sprintf('SR%02dC___HCM1___AC10',  SectorList);
    elseif (strcmp(Family,'HCMtimeconstant') && DevList==1)
        ChanName = sprintf('SR%02dC___HCM1___AC20',  SectorList);
    elseif (strcmp(Family,'HCMramprate') && DevList==1)
        ChanName = sprintf('SR%02dC___HCM1___AC30',  SectorList);
    elseif (strcmp(Family,'HCMtrim') && DevList==1)
        ChanName = sprintf('SR%02dC___HCM1T__%s10',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'HCMFF2') && DevList==1 && (SectorList==4 || SectorList==5 || SectorList==6 || SectorList==7 || SectorList==8 || SectorList==9 || SectorList==10 || SectorList==11 || SectorList==12))
        ChanName = sprintf('SR%02dC___HCM1FF2AC00',  SectorList);
        
    elseif (strcmp(Family,'HCM') && DevList==2)
        ChanName = sprintf('SR%02dC___HCM2___%s01',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'HCMready') && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___HCM2___BM04',  SectorList);
    elseif (strcmp(Family,'HCMon') && DevList==2    && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___HCM2___BM05',  SectorList);
    elseif (strcmp(Family,'HCMon') && DevList==2    && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___HCM2___BC18',  SectorList);
    elseif (strcmp(Family,'HCMreset') && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___HCM2_R_BC19',  SectorList);
    elseif (strcmp(Family,'HCMdac') && DevList==2   && (ChanTypeFlag==1))
        ChanName = sprintf('SR%02dC___HCM2___AC10',  SectorList);
    elseif (strcmp(Family,'HCMtimeconstant') && DevList==2)
        ChanName = sprintf('SR%02dC___HCM2___AC20',  SectorList);
    elseif (strcmp(Family,'HCMramprate') && DevList==2)
        ChanName = sprintf('SR%02dC___HCM2___AC30',  SectorList);
    elseif (strcmp(Family,'HCMtrim') && DevList==2)
        ChanName = sprintf('SR%02dC___HCM2T__%s10',  SectorList, ChanTypeStr);
        
        
    elseif (strcmp(Family,'HCM') && DevList==3)
        %if SectorList==5
        %    ChanName = sprintf('SR%02dC___SQSD1__%s00',  SectorList, ChanTypeStr);
        %else
        ChanName = sprintf('SR%02dC___HCSD1__%s00',  SectorList, ChanTypeStr);
        %end
    elseif (strcmp(Family,'HCMready') && DevList==3 && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___HCSD1__BM01',  SectorList);
    elseif (strcmp(Family,'HCMon') && DevList==3    && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___HCSD1__BM02',  SectorList);
    elseif (strcmp(Family,'HCMon') && DevList==3    && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___HCSD1__BC16',  SectorList);
    elseif (strcmp(Family,'HCMreset') && DevList==3 && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___HCSD1R_BC17',  SectorList);
        
    elseif (strcmp(Family,'HCMdac') && DevList==3   && (ChanTypeFlag==1))
        ChanName = sprintf('SR%02dC___HCSD1__AC10',  SectorList);
    elseif (strcmp(Family,'HCMtimeconstant') && DevList==3)
        ChanName = sprintf('SR%02dC___HCSD1__AC20',  SectorList);
    elseif (strcmp(Family,'HCMramprate') && DevList==3)
        ChanName = sprintf('SR%02dC___HCSD1__AC30',  SectorList);
    elseif (strcmp(Family,'HCMtrim') && DevList==3)
        ChanName = sprintf('SR%02dC___HCSD1T_%s10',  SectorList, ChanTypeStr);
        
    elseif (strcmp(Family,'HCM') && DevList==4)
        %if SectorList==7
        %    ChanName = sprintf('SR%02dC___SQSF1__%s00',  SectorList, ChanTypeStr);
        %else
        ChanName = sprintf('SR%02dC___HCSF1__%s02',  SectorList, ChanTypeStr);
        %end
    elseif (strcmp(Family,'HCMready') && DevList==4 && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___HCSF1__BM07',  SectorList);
    elseif (strcmp(Family,'HCMon') && DevList==4    && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___HCSF1__BM08',  SectorList);
    elseif (strcmp(Family,'HCMon') && DevList==4    && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___HCSF1__BC20',  SectorList);
    elseif (strcmp(Family,'HCMreset') && DevList==4 && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___HCSF1R_BC21',  SectorList);
        
    elseif (strcmp(Family,'HCMdac') && DevList==4   && (ChanTypeFlag==1))
        ChanName = sprintf('SR%02dC___HCSF1__AC10',  SectorList);
    elseif (strcmp(Family,'HCMtimeconstant') && DevList==4)
        ChanName = sprintf('SR%02dC___HCSF1__AC20',  SectorList);
    elseif (strcmp(Family,'HCMramprate') && DevList==4)
        ChanName = sprintf('SR%02dC___HCSF1__AC30',  SectorList);
    elseif (strcmp(Family,'HCMtrim') && DevList==4)
        ChanName = sprintf('SR%02dC___HCSF1T_%s10',  SectorList, ChanTypeStr);

    elseif (strcmp(Family,'HCM') && DevList==5)
        %if (SectorList==5 && ChanTypeFlag==0)
        %    ChanName = sprintf('SR%02dC___SQSF2__AM01',  SectorList);
        %elseif  (SectorList==5 && ChanTypeFlag==1)
        %    ChanName = sprintf('SR%02dC___SQSF2__AC00',  SectorList);
        %else
        ChanName = sprintf('SR%02dC___HCSF2__%s03',  SectorList, ChanTypeStr);
        %end
    elseif (strcmp(Family,'HCMready') && DevList==5 && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___HCSF2__BM10',  SectorList);
    elseif (strcmp(Family,'HCMon') && DevList==5    && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___HCSF2__BM11',  SectorList);
    elseif (strcmp(Family,'HCMon') && DevList==5    && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___HCSF2__BC22',  SectorList);
    elseif (strcmp(Family,'HCMreset') && DevList==5 && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___HCSF2R_BC23',  SectorList);
        
    elseif (strcmp(Family,'HCMdac') && DevList==5   && (ChanTypeFlag==1))
        ChanName = sprintf('SR%02dC___HCSF2__AC10',  SectorList);
    elseif (strcmp(Family,'HCMtimeconstant') && DevList==5)
        ChanName = sprintf('SR%02dC___HCSF2__AC20',  SectorList);
    elseif (strcmp(Family,'HCMramprate') && DevList==5)
        ChanName = sprintf('SR%02dC___HCSF2__AC30',  SectorList);
    elseif (strcmp(Family,'HCMtrim') && DevList==5)
        ChanName = sprintf('SR%02dC___HCSF2T_%s10',  SectorList, ChanTypeStr);

    elseif (strcmp(Family,'HCM') && DevList==6)
        %if (SectorList==5 && ChanTypeFlag==0)
        %    ChanName = sprintf('SR%02dC___SQSD2__AM01',  SectorList);
        %elseif  (SectorList==5 && ChanTypeFlag==1)
        %    ChanName = sprintf('SR%02dC___SQSD2__AC00',  SectorList);
        %else
        ChanName = sprintf('SR%02dC___HCSD2__%s01',  SectorList, ChanTypeStr);
        %end
    elseif (strcmp(Family,'HCMready') && DevList==6 && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___HCSD2__BM04',  SectorList);
    elseif (strcmp(Family,'HCMon') && DevList==6    && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___HCSD2__BM05',  SectorList);
    elseif (strcmp(Family,'HCMon') && DevList==6    && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___HCSD2__BC18',  SectorList);
    elseif (strcmp(Family,'HCMreset') && DevList==6 && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___HCSD2R_BC19',  SectorList);
        
    elseif (strcmp(Family,'HCMdac') && DevList==6   && (ChanTypeFlag==1))
        ChanName = sprintf('SR%02dC___HCSD2__AC10',  SectorList);
    elseif (strcmp(Family,'HCMtimeconstant') && DevList==6)
        ChanName = sprintf('SR%02dC___HCSD2__AC20',  SectorList);
    elseif (strcmp(Family,'HCMramprate') && DevList==6)
        ChanName = sprintf('SR%02dC___HCSD2__AC30',  SectorList);
    elseif (strcmp(Family,'HCMtrim') && DevList==6)
        ChanName = sprintf('SR%02dC___HCSD2T_%s10',  SectorList, ChanTypeStr);

    elseif (strcmp(Family,'HCM') && DevList==7)
        ChanName = sprintf('SR%02dC___HCM3___%s02',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'HCMready') && DevList==7 && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___HCM3___BM07',  SectorList);
    elseif (strcmp(Family,'HCMon') && DevList==7    && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___HCM3___BM08',  SectorList);
    elseif (strcmp(Family,'HCMon') && DevList==7    && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___HCM3___BC20',  SectorList);
    elseif (strcmp(Family,'HCMreset') && DevList==7 && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___HCM3_R_BC21',  SectorList);
    elseif (strcmp(Family,'HCMdac') && DevList==7   && (ChanTypeFlag==1))
        ChanName = sprintf('SR%02dC___HCM3___AC10',  SectorList);
    elseif (strcmp(Family,'HCMtimeconstant') && DevList==7)
        ChanName = sprintf('SR%02dC___HCM3___AC20',  SectorList);
    elseif (strcmp(Family,'HCMramprate') && DevList==7)
        ChanName = sprintf('SR%02dC___HCM3___AC30',  SectorList);
    elseif (strcmp(Family,'HCMtrim') && DevList==7)
        ChanName = sprintf('SR%02dC___HCM3T__%s10',  SectorList, ChanTypeStr);
        
    elseif (strcmp(Family,'HCM') && DevList==8)
        ChanName = sprintf('SR%02dC___HCM4___%s03',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'HCMready') && DevList==8 && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___HCM4___BM10',  SectorList);
    elseif (strcmp(Family,'HCMon') && DevList==8    && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___HCM4___BM11',  SectorList);
    elseif (strcmp(Family,'HCMon') && DevList==8    && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___HCM4___BC22',  SectorList);
    elseif (strcmp(Family,'HCMreset') && DevList==8 && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___HCM4_R_BC23',  SectorList);
    elseif (strcmp(Family,'HCMdac') && DevList==8   && (ChanTypeFlag==1))
        ChanName = sprintf('SR%02dC___HCM4___AC10',  SectorList);
    elseif (strcmp(Family,'HCMtimeconstant') && DevList==8)
        ChanName = sprintf('SR%02dC___HCM4___AC20',  SectorList);
    elseif (strcmp(Family,'HCMramprate') && DevList==8)
        ChanName = sprintf('SR%02dC___HCM4___AC30',  SectorList);
    elseif (strcmp(Family,'HCMtrim') && DevList==8)
        ChanName = sprintf('SR%02dC___HCM4T__%s10',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'HCMFF1') && DevList==8 && (SectorList==3 || SectorList==4 || SectorList==5 || SectorList==6 || SectorList==7 || SectorList==8 || SectorList==9 || SectorList==10 || SectorList==11))
        ChanName = sprintf('SR%02dC___HCM4FF1AC00',  SectorList);
        
    elseif (strcmp(Family,'HCM') && DevList==10 && SectorList==5 && ChanTypeFlag==0)
        ChanName = sprintf('SR%02dU___HCM2___%s01',  SectorList+1, ChanTypeStr);
    elseif (strcmp(Family,'HCM') && DevList==10)
        ChanName = sprintf('SR%02dU___HCM2___%s00',  SectorList+1, ChanTypeStr);
    elseif (strcmp(Family,'HCMdac') && DevList==10   && (ChanTypeFlag==1))
        ChanName = sprintf('SR%02dU___HCM2___AC10',  SectorList+1);
%     all chicane trim coils are now CAEN PSs with no time constants  
%     elseif (strcmp(Family,'HCMtimeconstant') && DevList==10 && SectorList==5)
%         ChanName = sprintf('SR%02dU___HCM2___AC20',  SectorList+1);
    elseif (strcmp(Family,'HCMramprate') && DevList==10)
        ChanName = sprintf('SR%02dU___HCM2___AC30',  SectorList+1);
    elseif (strcmp(Family,'HCMready') && DevList==10 && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dU___HCM2___BM19',  SectorList+1);
    elseif (strcmp(Family,'HCMon') && DevList==10    && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dU___HCM2___BM18',  SectorList+1);
    elseif (strcmp(Family,'HCMon') && DevList==10    && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dU___HCM2___BC23',  SectorList+1);
        %elseif (strcmp(Family,'HCMtrim') && DevList==10)
        %    ChanName = sprintf('SR%02dU___HCM1T__%s10',  SectorList+1, ChanTypeStr);
    elseif (strcmp(Family,'HCMFF1') && DevList==10 && (SectorList==3 || SectorList==5 || SectorList==6 || SectorList==10))
        ChanName = sprintf('SR%02dU___HCM2FF1AC00',  SectorList+1);
    elseif (strcmp(Family,'HCMFF2') && DevList==10 && (SectorList==3 || SectorList==5 || SectorList==6 || SectorList==10))
        ChanName = sprintf('SR%02dU___HCM2FF2AC00',  SectorList+1);
        
        
    elseif (strcmp(Family,'VCM') && DevList==1)
        ChanName = sprintf('SR%02dC___VCM1___%s00',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'VCMready') && DevList==1 && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___VCM1___BM01',  SectorList);
    elseif (strcmp(Family,'VCMon') && DevList==1    && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___VCM1___BM02',  SectorList);
    elseif (strcmp(Family,'VCMon') && DevList==1    && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___VCM1___BC16',  SectorList);
    elseif (strcmp(Family,'VCMreset') && DevList==1 && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___VCM1_R_BC17',  SectorList);
    elseif (strcmp(Family,'VCMdac') && DevList==1   && (ChanTypeFlag==1))
        ChanName = sprintf('SR%02dC___VCM1___AC10',  SectorList);
    elseif (strcmp(Family,'VCMtimeconstant') && DevList==1)
        ChanName = sprintf('SR%02dC___VCM1___AC20',  SectorList);
    elseif (strcmp(Family,'VCMramprate') && DevList==1)
        ChanName = sprintf('SR%02dC___VCM1___AC30',  SectorList);
    elseif (strcmp(Family,'VCMtrim') && DevList==1)
        ChanName = sprintf('SR%02dC___VCM1T__%s10',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'VCMFF2') && DevList==1 && (SectorList==4 || SectorList==5 || SectorList==6 || SectorList==7 || SectorList==8 || SectorList==9 || SectorList==10 || SectorList==11 || SectorList==12))
        ChanName = sprintf('SR%02dC___VCM1FF2AC00',  SectorList);
        
    elseif (strcmp(Family,'VCM') && DevList==2)
        ChanName = sprintf('SR%02dC___VCM2___%s01',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'VCMready') && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___VCM2___BM04',  SectorList);
    elseif (strcmp(Family,'VCMon') && DevList==2    && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___VCM2___BM05',  SectorList);
    elseif (strcmp(Family,'VCMon') && DevList==2    && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___VCM2___BC18',  SectorList);
    elseif (strcmp(Family,'VCMreset') && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___VCM2_R_BC19',  SectorList);
    elseif (strcmp(Family,'VCMdac') && DevList==2   && (ChanTypeFlag==1))
        ChanName = sprintf('SR%02dC___VCM2___AC10',  SectorList);
    elseif (strcmp(Family,'VCMtimeconstant') && DevList==2)
        ChanName = sprintf('SR%02dC___VCM2___AC20',  SectorList);
    elseif (strcmp(Family,'VCMramprate') && DevList==2)
        ChanName = sprintf('SR%02dC___VCM2___AC30',  SectorList);
    elseif (strcmp(Family,'VCMtrim') && DevList==2)
        ChanName = sprintf('SR%02dC___VCM2T__%s10',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'VCM') && DevList==3)
        error('No VCSD1 corrector magnet.');
        
    elseif (strcmp(Family,'VCM') && DevList==4)
        ChanName = sprintf('SR%02dC___VCSF1__%s00',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'VCMready') && DevList==4 && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___VCSF1__BM01',  SectorList);
    elseif (strcmp(Family,'VCMon') && DevList==4    && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___VCSF1__BM02',  SectorList);
    elseif (strcmp(Family,'VCMon') && DevList==4    && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___VCSF1__BC16',  SectorList);
    elseif (strcmp(Family,'VCMreset') && DevList==4 && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___VCSF1R_BC17',  SectorList);
        
    elseif (strcmp(Family,'VCMdac') && DevList==4   && (ChanTypeFlag==1))
        ChanName = sprintf('SR%02dC___VCSF1__AC10',  SectorList);
    elseif (strcmp(Family,'VCMtimeconstant') && DevList==4)
        ChanName = sprintf('SR%02dC___VCSF1__AC20',  SectorList);
    elseif (strcmp(Family,'VCMramprate') && DevList==4)
        ChanName = sprintf('SR%02dC___VCSF1__AC30',  SectorList);
    elseif (strcmp(Family,'VCMtrim') && DevList==4)
        ChanName = sprintf('SR%02dC___VCSF1T_%s10',  SectorList, ChanTypeStr);

    elseif (strcmp(Family,'VCM') && DevList==5)
        ChanName = sprintf('SR%02dC___VCSF2__%s01',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'VCMready') && DevList==5 && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___VCSF2__BM04',  SectorList);
    elseif (strcmp(Family,'VCMon') && DevList==5    && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___VCSF2__BM05',  SectorList);
    elseif (strcmp(Family,'VCMon') && DevList==5    && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___VCSF2__BC18',  SectorList);
    elseif (strcmp(Family,'VCMreset') && DevList==5 && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___VCSF2R_BC19',  SectorList);
    elseif (strcmp(Family,'VCM') && DevList==6)
        error('No VCSD2 corrector magnet.');
        
    elseif (strcmp(Family,'VCMdac') && DevList==5   && (ChanTypeFlag==1))
        ChanName = sprintf('SR%02dC___VCSF2__AC10',  SectorList);
    elseif (strcmp(Family,'VCMtimeconstant') && DevList==5)
        ChanName = sprintf('SR%02dC___VCSF2__AC20',  SectorList);
    elseif (strcmp(Family,'VCMramprate') && DevList==5)
        ChanName = sprintf('SR%02dC___VCSF2__AC30',  SectorList);
    elseif (strcmp(Family,'VCMtrim') && DevList==5)
        ChanName = sprintf('SR%02dC___VCSF2T_%s10',  SectorList, ChanTypeStr);

        
    elseif (strcmp(Family,'VCM') && DevList==7)
        ChanName = sprintf('SR%02dC___VCM3___%s02',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'VCMready') && DevList==7 && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___VCM3___BM07',  SectorList);
    elseif (strcmp(Family,'VCMon') && DevList==7    && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___VCM3___BM08',  SectorList);
    elseif (strcmp(Family,'VCMon') && DevList==7    && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___VCM3___BC20',  SectorList);
    elseif (strcmp(Family,'VCMreset') && DevList==7 && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___VCM3_R_BC21',  SectorList);
    elseif (strcmp(Family,'VCMdac') && DevList==7   && (ChanTypeFlag==1))
        ChanName = sprintf('SR%02dC___VCM3___AC10',  SectorList);
    elseif (strcmp(Family,'VCMtimeconstant') && DevList==7)
        ChanName = sprintf('SR%02dC___VCM3___AC20',  SectorList);
    elseif (strcmp(Family,'VCMramprate') && DevList==7)
        ChanName = sprintf('SR%02dC___VCM3___AC30',  SectorList);
    elseif (strcmp(Family,'VCMtrim') && DevList==7)
        ChanName = sprintf('SR%02dC___VCM3T__%s10',  SectorList, ChanTypeStr);
        
    elseif (strcmp(Family,'VCM') && DevList==8)
        ChanName = sprintf('SR%02dC___VCM4___%s03',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'VCMready') && DevList==8 && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___VCM4___BM10',  SectorList);
    elseif (strcmp(Family,'VCMon') && DevList==8    && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___VCM4___BM11',  SectorList);
    elseif (strcmp(Family,'VCMon') && DevList==8    && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___VCM4___BC22',  SectorList);
    elseif (strcmp(Family,'VCMreset') && DevList==8 && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___VCM4_R_BC23',  SectorList);
    elseif (strcmp(Family,'VCMdac') && DevList==8   && (ChanTypeFlag==1))
        ChanName = sprintf('SR%02dC___VCM4___AC10',  SectorList);
    elseif (strcmp(Family,'VCMtimeconstant') && DevList==8)
        ChanName = sprintf('SR%02dC___VCM4___AC20',  SectorList);
    elseif (strcmp(Family,'VCMramprate') && DevList==8)
        ChanName = sprintf('SR%02dC___VCM4___AC30',  SectorList);
    elseif (strcmp(Family,'VCMtrim') && DevList==8)
        ChanName = sprintf('SR%02dC___VCM4T__%s10',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'VCMFF1') && DevList==8 && (SectorList==3 || SectorList==4 || SectorList==5 || SectorList==6 || SectorList==7 || SectorList==8 || SectorList==9 || SectorList==10 || SectorList==11))
        ChanName = sprintf('SR%02dC___VCM4FF1AC00',  SectorList);
        
    elseif (strcmp(Family,'VCM') && DevList==10 && SectorList==5 && ChanTypeFlag==1)
        ChanName = sprintf('SR%02dU___VCM2___%s00',  SectorList+1, ChanTypeStr);
    elseif (strcmp(Family,'VCM') && DevList==10)
        ChanName = sprintf('SR%02dU___VCM2___%s01',  SectorList+1, ChanTypeStr);
    elseif (strcmp(Family,'VCMdac') && DevList==10   && (ChanTypeFlag==1))
        ChanName = sprintf('SR%02dU___VCM2___AC10',  SectorList+1);
%     all chicane trim coils are now CAEN PSs with no time constants  
%     elseif (strcmp(Family,'VCMtimeconstant') && DevList==10 && SectorList==5)
%         ChanName = sprintf('SR%02dU___VCM2___AC20',  SectorList+1);
    elseif (strcmp(Family,'VCMramprate') && DevList==10)
        ChanName = sprintf('SR%02dU___VCM2___AC30',  SectorList+1);
    elseif (strcmp(Family,'VCMready') && DevList==10 && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dU___VCM2___BM17',  SectorList+1);
    elseif (strcmp(Family,'VCMon') && DevList==10    && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dU___VCM2___BM16',  SectorList+1);
    elseif (strcmp(Family,'VCMon') && DevList==10    && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dU___VCM2___BC22',  SectorList+1);
    %elseif (strcmp(Family,'VCMtrim') && DevList==10)
    %    ChanName = sprintf('SR%02dU___VCM1T__%s10',  SectorList+1, ChanTypeStr);
    elseif (strcmp(Family,'VCMFF1') && DevList==10 && (SectorList==3 || SectorList==5 || SectorList==6 || SectorList==10))
        ChanName = sprintf('SR%02dU___VCM2FF1AC00',  SectorList+1);
    elseif (strcmp(Family,'VCMFF2') && DevList==10 && (SectorList==3 || SectorList==5 || SectorList==6 || SectorList==10))
        ChanName = sprintf('SR%02dU___VCM2FF2AC00',  SectorList+1);
        
        
    elseif (strcmp(Family,'QF') && DevList==1)
        ChanName = sprintf('SR%02dC___QF1____%s02',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'QFFF') && DevList==1)
        ChanName = sprintf('SR%02dC___QF1FF__%s02',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'QFM') && DevList==1)
        ChanName = sprintf('SR%02dC___QF1M___%s02',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'QFready') && DevList==1 && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___QF1____BM07',  SectorList);
    elseif (strcmp(Family,'QFon') && DevList==1    && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___QF1____BM08',  SectorList);
    elseif (strcmp(Family,'QFon') && DevList==1    && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___QF1____BC20',  SectorList);
    elseif (strcmp(Family,'QFreset') && DevList==1 && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___QF1__R_BC21',  SectorList);
    elseif (strcmp(Family,'QFdac') && DevList==1   && (ChanTypeFlag==1))
        ChanName = sprintf('SR%02dC___QF1____AC10',  SectorList);
    elseif (strcmp(Family,'QFtimeconstant') && DevList==1)
        ChanName = sprintf('SR%02dC___QF1____AC20',  SectorList);
    elseif (strcmp(Family,'QFramprate') && DevList==1)
        ChanName = sprintf('SR%02dC___QF1____AC30',  SectorList);
        
    elseif (strcmp(Family,'QF') && DevList==2)
        ChanName = sprintf('SR%02dC___QF2____%s03',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'QFFF') && DevList==2)
        ChanName = sprintf('SR%02dC___QF2FF__%s03',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'QFM') && DevList==2)
        ChanName = sprintf('SR%02dC___QF2M___%s03',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'QFready') && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___QF2____BM10',  SectorList);
    elseif (strcmp(Family,'QFon') && DevList==2    && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___QF2____BM11',  SectorList);
    elseif (strcmp(Family,'QFon') && DevList==2    && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___QF2____BC22',  SectorList);
    elseif (strcmp(Family,'QFreset') && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___QF2__R_BC23',  SectorList);
    elseif (strcmp(Family,'QFdac') && DevList==2   && (ChanTypeFlag==1))
        ChanName = sprintf('SR%02dC___QF2____AC10',  SectorList);
    elseif (strcmp(Family,'QFtimeconstant') && DevList==2)
        ChanName = sprintf('SR%02dC___QF2____AC20',  SectorList);
    elseif (strcmp(Family,'QFramprate') && DevList==2)
        ChanName = sprintf('SR%02dC___QF2____AC30',  SectorList);
        
    elseif (strcmp(Family,'QD') && DevList==1)
        ChanName = sprintf('SR%02dC___QD1____%s00',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'QDFF') && DevList==1)
        ChanName = sprintf('SR%02dC___QD1FF__%s00',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'QDM') && DevList==1)
        ChanName = sprintf('SR%02dC___QD1M___%s00',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'QDready') && DevList==1 && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___QD1____BM01',  SectorList);
    elseif (strcmp(Family,'QDon') && DevList==1    && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___QD1____BM02',  SectorList);
    elseif (strcmp(Family,'QDon') && DevList==1    && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___QD1____BC16',  SectorList);
    elseif (strcmp(Family,'QDreset') && DevList==1 && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___QD1__R_BC17',  SectorList);
    elseif (strcmp(Family,'QDdac') && DevList==1   && (ChanTypeFlag==1))
        ChanName = sprintf('SR%02dC___QD1____AC10',  SectorList);
    elseif (strcmp(Family,'QDtimeconstant') && DevList==1)
        ChanName = sprintf('SR%02dC___QD1____AC20',  SectorList);
    elseif (strcmp(Family,'QDramprate') && DevList==1)
        ChanName = sprintf('SR%02dC___QD1____AC30',  SectorList);
        
    elseif (strcmp(Family,'QD') && DevList==2)
        ChanName = sprintf('SR%02dC___QD2____%s01',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'QDFF') && DevList==2)
        ChanName = sprintf('SR%02dC___QD2FF__%s01',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'QDM') && DevList==2)
        ChanName = sprintf('SR%02dC___QD2M___%s01',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'QDready') && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___QD2____BM04',  SectorList);
    elseif (strcmp(Family,'QDon') && DevList==2    && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___QD2____BM05',  SectorList);
    elseif (strcmp(Family,'QDon') && DevList==2    && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___QD2____BC18',  SectorList);
    elseif (strcmp(Family,'QDreset') && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___QD2__R_BC19',  SectorList);
    elseif (strcmp(Family,'QDdac') && DevList==2   && (ChanTypeFlag==1))
        ChanName = sprintf('SR%02dC___QD2____AC10',  SectorList);
    elseif (strcmp(Family,'QDtimeconstant') && DevList==2)
        ChanName = sprintf('SR%02dC___QD2____AC20',  SectorList);
    elseif (strcmp(Family,'QDramprate') && DevList==2)
        ChanName = sprintf('SR%02dC___QD2____AC30',  SectorList);
        
    elseif (strcmp(Family,'QDA') && DevList==1 && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___QDA1___%s00',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'QDAready') && (ChanTypeFlag==0 || ChanTypeFlag==2) && DevList==1 && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___QDA1___BM10',  SectorList);
    elseif (strcmp(Family,'QDAon')    && (ChanTypeFlag==0 || ChanTypeFlag==2) && DevList==1 && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___QDA1___BM09',  SectorList);
    elseif (strcmp(Family,'QDAon')    && (ChanTypeFlag==1 || ChanTypeFlag==3) && DevList==1 && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___QDA1___BC15',  SectorList);
    elseif (strcmp(Family,'QDAreset') && (ChanTypeFlag==1 || ChanTypeFlag==3) && DevList==1 && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___QDA1R__BC14',  SectorList);
    elseif (strcmp(Family,'QDAtimeconstant') && DevList==1 && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___QDA1___AC02',  SectorList);
    elseif (strcmp(Family,'QDAramprate') && DevList==1 && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___QDA1___AC03',  SectorList);
    elseif (strcmp(Family,'QDA') && DevList==2 && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___QDA2___%s00',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'QDAready') && (ChanTypeFlag==0 || ChanTypeFlag==2) && DevList==2 && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___QDA2___BM07',  SectorList);
    elseif (strcmp(Family,'QDAon')    && (ChanTypeFlag==0 || ChanTypeFlag==2) && DevList==2 && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___QDA2___BM06',  SectorList);
    elseif (strcmp(Family,'QDAon')    && (ChanTypeFlag==1 || ChanTypeFlag==3) && DevList==2 && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___QDA2___BC13',  SectorList);
    elseif (strcmp(Family,'QDAreset') && (ChanTypeFlag==1 || ChanTypeFlag==3) && DevList==2 && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___QDA2R__BC12',  SectorList);
    elseif (strcmp(Family,'QDAtimeconstant') && DevList==2 && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___QDA2___AC02',  SectorList);
    elseif (strcmp(Family,'QDAramprate') && DevList==2 && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___QDA2___AC03',  SectorList);
    elseif (strcmp(Family,'QDA') && (SectorList==1 || SectorList==2 || SectorList==3 || SectorList==5 || SectorList==6 || SectorList==7 || SectorList==9 || SectorList==10 || SectorList==11))
        error('No QDA magnet in that sector.');
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% temporary SR01C___SQSF1 name configuration for testing CAEN PS - 11-05-10, T.Scarvie %
%  CAEN PS removed 1-18-10 for further off-line testing, Kepco reinstalled, T.Scarvie  %
%    elseif (strcmp(Family,'SQSF') && DevList==1 && SectorList==1 && ChanTypeFlag==0)
%        ChanName = sprintf('sqsf1:cmon');
%    elseif (strcmp(Family,'SQSF') && DevList==1 && SectorList==1 && ChanTypeFlag==1)
%        ChanName = sprintf('sqsf1:cset');
%    elseif (strcmp(Family,'SQSFon')    && DevList==1 && SectorList==1 && (ChanTypeFlag==0 || ChanTypeFlag==2))
%        ChanName = sprintf('sqsf1:onmon');
%    elseif (strcmp(Family,'SQSFon')    && DevList==1 && SectorList==1 && (ChanTypeFlag==1 || ChanTypeFlag==3))
%        ChanName = sprintf('sqsf1:on');
%    elseif (strcmp(Family,'SQSFreset') && DevList==1 && SectorList==1 && (ChanTypeFlag==1 || ChanTypeFlag==3))
%        ChanName = sprintf('sqsf1:reset');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    elseif (strcmp(Family,'SQSF') && DevList==1 && ChanTypeFlag==0)
        %if SectorList == 7
        %    ChanName = sprintf('SR%02dC___HCSF1__AM02',  SectorList);
        %else
        ChanName = sprintf('SR%02dC___SQSF1__AM00',  SectorList);
        %end
    elseif (strcmp(Family,'SQSF') && DevList==1 && ChanTypeFlag==1)
        %if SectorList == 7
        %    ChanName = sprintf('SR%02dC___HCSF1__AC02',  SectorList);
        %else
        ChanName = sprintf('SR%02dC___SQSF1__AC00',  SectorList);
        %end
    elseif (strcmp(Family,'SQSFready') && DevList==1 && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___SQSF1__BM19',  SectorList);
    elseif (strcmp(Family,'SQSFon')    && DevList==1 && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___SQSF1__BM18',  SectorList);
    elseif (strcmp(Family,'SQSFon')    && DevList==1 && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___SQSF1__BC23',  SectorList);
    elseif (strcmp(Family,'SQSFdac') && DevList==1 && ChanTypeFlag==1 && SectorList~=5)
        ChanName = sprintf('SR%02dC___SQSF1__AC10',  SectorList);
    elseif (strcmp(Family,'SQSFtimeconstant') && DevList==1 && ChanTypeFlag==1 && SectorList~=5)
        ChanName = sprintf('SR%02dC___SQSF1__AC20',  SectorList);
    elseif (strcmp(Family,'SQSFramprate') && DevList==1 && ChanTypeFlag==1 && SectorList~=5)
        ChanName = sprintf('SR%02dC___SQSF1__AC30',  SectorList);
    elseif (strcmp(Family,'SQSFreset') && DevList==1 && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___SQSF1__BC01',  SectorList);
    elseif (strcmp(Family,'SQSF') && DevList==2 && ChanTypeFlag==0)
        %if SectorList == 5
        %ChanName = sprintf('SR%02dC___HCSF2__AM03',  SectorList);
        %else
        ChanName = sprintf('SR%02dC___SQSF2__AM01',  SectorList);
        %end
    elseif (strcmp(Family,'SQSF') && DevList==2 && ChanTypeFlag==1)
        %if SectorList == 5
        %    ChanName = sprintf('SR%02dC___HCSF2__AC03',  SectorList);
        %else
        ChanName = sprintf('SR%02dC___SQSF2__AC00',  SectorList);
        %end
    elseif (strcmp(Family,'SQSFready') && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___SQSF2__BM08',  SectorList);
    elseif (strcmp(Family,'SQSFon')    && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___SQSF2__BM09',  SectorList);
    elseif (strcmp(Family,'SQSFon')    && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___SQSF2__BC21',  SectorList);
    elseif (strcmp(Family,'SQSFdac') && DevList==2 && ChanTypeFlag==1 && SectorList~=5)
        ChanName = sprintf('SR%02dC___SQSF2__AC10',  SectorList);
    elseif (strcmp(Family,'SQSFtimeconstant') && DevList==2 && ChanTypeFlag==1 && SectorList~=5)
        ChanName = sprintf('SR%02dC___SQSF2__AC20',  SectorList);
    elseif (strcmp(Family,'SQSFramprate') && DevList==2 && ChanTypeFlag==1 && SectorList~=5)
        ChanName = sprintf('SR%02dC___SQSF2__AC30',  SectorList);
%     elseif (strcmp(Family,'SQSFreset') && DevList==2 && ChanTypeFlag==3 && SectorList==5)
%         ChanName = sprintf('SR%02dC___SQSF2__BC08',  SectorList);
    elseif (strcmp(Family,'SQSFreset') && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___SQSF2__BC01',  SectorList);
        
    elseif (strcmp(Family,'SQSD') && DevList==1 && ChanTypeFlag==0)
        %if SectorList == 5
        %    ChanName = sprintf('SR%02dC___HCSD1__AM00',  SectorList);
        %else
        ChanName = sprintf('SR%02dC___SQSD1__AM00',  SectorList);
        %end
    elseif (strcmp(Family,'SQSD') && DevList==1 && ChanTypeFlag==1)
        %if SectorList == 5
        %    ChanName = sprintf('SR%02dC___HCSD1__AC00',  SectorList);
        %else
        ChanName = sprintf('SR%02dC___SQSD1__AC00',  SectorList);
        %end
    elseif (strcmp(Family,'SQSDready') && DevList==1 && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___SQSD1__BM17',  SectorList);
    elseif (strcmp(Family,'SQSDon')    && DevList==1 && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___SQSD1__BM16',  SectorList);
    elseif (strcmp(Family,'SQSDon')    && DevList==1 && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___SQSD1__BC22',  SectorList);
    elseif (strcmp(Family,'SQSDdac') && DevList==1 && ChanTypeFlag==1 && SectorList~=5)
        ChanName = sprintf('SR%02dC___SQSD1__AC10',  SectorList);
    elseif (strcmp(Family,'SQSDtimeconstant') && DevList==1 && ChanTypeFlag==1 && SectorList~=5)
        ChanName = sprintf('SR%02dC___SQSD1__AC20',  SectorList);
    elseif (strcmp(Family,'SQSDramprate') && DevList==1 && ChanTypeFlag==1 && SectorList~=5)
        ChanName = sprintf('SR%02dC___SQSD1__AC30',  SectorList);
    elseif (strcmp(Family,'SQSDreset') && DevList==1 && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___SQSD1__BC01',  SectorList);
%     elseif (strcmp(Family,'SQSDreset') && DevList==1 && ChanTypeFlag==3 && SectorList==5)
%         ChanName = sprintf('SR%02dC___SQSD1__BC17',  SectorList);
        
        % SQSD2 for all sectors except SR01C
    elseif (strcmp(Family,'SQSD') && DevList==2 && ChanTypeFlag==0&& SectorList~=1)
        %if SectorList == 5
        %    ChanName = sprintf('SR%02dC___HCSD2__AM01',  SectorList);
        %else
        ChanName = sprintf('SR%02dC___SQSD2__AM01',  SectorList);
        %end
    elseif (strcmp(Family,'SQSD') && DevList==2 && ChanTypeFlag==1 && SectorList~=1)
        %if SectorList == 5
        %    ChanName = sprintf('SR%02dC___HCSD2__AC01',  SectorList);
        %else
        ChanName = sprintf('SR%02dC___SQSD2__AC00',  SectorList);
        %end
    elseif (strcmp(Family,'SQSDready') && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList~=1)
        ChanName = sprintf('SR%02dC___SQSD2__BM10',  SectorList);
    elseif (strcmp(Family,'SQSDon')    && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList~=1)
        ChanName = sprintf('SR%02dC___SQSD2__BM11',  SectorList);
    elseif (strcmp(Family,'SQSDon')    && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3) && SectorList~=1)
        ChanName = sprintf('SR%02dC___SQSD2__BC20',  SectorList);
    elseif (strcmp(Family,'SQSDdac') && DevList==2 && ChanTypeFlag==1 && SectorList~=5)
        ChanName = sprintf('SR%02dC___SQSD2__AC10',  SectorList);
    elseif (strcmp(Family,'SQSDtimeconstant') && DevList==2 && ChanTypeFlag==1 && SectorList~=5)
        ChanName = sprintf('SR%02dC___SQSD2__AC20',  SectorList);
    elseif (strcmp(Family,'SQSDramprate') && DevList==2 && ChanTypeFlag==1 && SectorList~=5)
        ChanName = sprintf('SR%02dC___SQSD2__AC30',  SectorList);
    elseif (strcmp(Family,'SQSDreset') && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___SQSD2__BC01',  SectorList);
%     elseif (strcmp(Family,'SQSDreset') && DevList==2 && ChanTypeFlag==3 && SectorList==5)
%         ChanName = sprintf('SR%02dC___SQSD2__BC10',  SectorList);
        
        % ganged SR01C SQSD2
    elseif (strcmp(Family,'SQSD') && DevList==2  && SectorList==1)
        ChanName = sprintf('SR%02dC___SQSD2__%s02',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'SQSDready') && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList==1)
        ChanName = sprintf('SR%02dC___SQSD2__BM07',  SectorList);
    elseif (strcmp(Family,'SQSDon')    && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList==1)
        ChanName = sprintf('SR%02dC___SQSD2__BM08',  SectorList);
    elseif (strcmp(Family,'SQSDon')    && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3) && SectorList==1)
        ChanName = sprintf('SR%02dC___SQSD2__BC20',  SectorList);
    elseif (strcmp(Family,'SQSDreset') && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3) && SectorList==1)
        ChanName = sprintf('SR%02dC___SQSD2R_BC21',  SectorList);
        
        
    %elseif (strcmp(Family,'SF') && (ChanTypeFlag==0 || ChanTypeFlag==1))
    %    ChanName = sprintf('SR01C___SF_____%s00', ChanTypeStr);
    elseif strcmp(Family,'SF') && ChanTypeFlag==0
        ChanName = 'SR01C___SF_____AM00';
        % ChanName = 'SRSF_Mag_I_MonA';    % Change because SR01C___SF_____AM00 max is ~368.4
        %ChanName = 'SRSF_Mag_I_MonB';
    elseif strcmp(Family,'SF') && ChanTypeFlag==1
        ChanName = 'SR01C___SF_____AC00';
        % ChanName = 'Physics1'; %change PV for SF setpoint to temp channel name due to control reconfiguration for broken SF supply - T.Scarvie, 20100609
    elseif (strcmp(Family,'SFready') && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR01C___SF_____BM17');
    elseif (strcmp(Family,'SFon')    && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR01C___SF_____BM18');
    elseif (strcmp(Family,'SFon')    && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR01C___SF_____BC22');
    elseif (strcmp(Family,'SFdac'))
        ChanName = sprintf('SR01C___SF_____AC10');
    elseif (strcmp(Family,'SFtimeconstant'))
        ChanName = sprintf('SR01C___SF_____AC20');
    elseif (strcmp(Family,'SFramprate'))
        ChanName = sprintf('SR01C___SF_____AC30');
    elseif (strcmp(Family,'SFreset') && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR01C___SF___R_BC23');
        
        
    elseif (strcmp(Family,'SD') && (ChanTypeFlag==0 || ChanTypeFlag==1))
        ChanName = sprintf('SR01C___SD_____%s00', ChanTypeStr);
    elseif (strcmp(Family,'SDready') && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR01C___SD_____BM17');
    elseif (strcmp(Family,'SDon')    && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR01C___SD_____BM18');
    elseif (strcmp(Family,'SDon')    && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR01C___SD_____BC22');
    elseif (strcmp(Family,'SDdac'))
        ChanName = sprintf('SR01C___SD_____AC10');
    elseif (strcmp(Family,'SDtimeconstant'))
        ChanName = sprintf('SR01C___SD_____AC20');
    elseif (strcmp(Family,'SDramprate'))
        ChanName = sprintf('SR01C___SD_____AC30');
    elseif (strcmp(Family,'SDreset') && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR01C___SD___R_BC23');
        
    elseif strcmp(Family,'SHF')
        if (SectorList==1 && DevList==1) || (SectorList==12 && DevList==2)
            ChanName = sprintf('SR%02dC___SHFA___%s00',  SectorList, ChanTypeStr);
        else
            ChanName = sprintf('SR%02dC___SHF%01d___%s00',  SectorList, DevList, ChanTypeStr);
        end
    elseif (strcmp(Family,'SHFready') && (ChanTypeFlag==0 || ChanTypeFlag==2))
        if (SectorList==1 && DevList==1) || (SectorList==12 && DevList==2)
            ChanName = sprintf('SR%02dC___SHFA___BM01',  SectorList);
        else
            ChanName = sprintf('SR%02dC___SHF%01d___BM01',  SectorList, DevList);
        end
    elseif (strcmp(Family,'SHFon')  && (ChanTypeFlag==0 || ChanTypeFlag==2))
        if (SectorList==1 && DevList==1) || (SectorList==12 && DevList==2)
            ChanName = sprintf('SR%02dC___SHFA___BM02',  SectorList);
        else
            ChanName = sprintf('SR%02dC___SHF%01d___BM02',  SectorList, DevList);
        end
    elseif (strcmp(Family,'SHFon') && (ChanTypeFlag==1 || ChanTypeFlag==3))
        if (SectorList==1 && DevList==1) || (SectorList==12 && DevList==2)
            ChanName = sprintf('SR%02dC___SHFA___BC16',  SectorList);
        else
            ChanName = sprintf('SR%02dC___SHF%01d___BC16',  SectorList, DevList);
        end
    elseif (strcmp(Family,'SHFreset') && (ChanTypeFlag==1 || ChanTypeFlag==3))
        if (SectorList==1 && DevList==1) || (SectorList==12 && DevList==2)
            ChanName = sprintf('SR%02dC___SHFA___BC17',  SectorList);
        else
            ChanName = sprintf('SR%02dC___SHF%01d___BC17',  SectorList, DevList);
        end
        
    elseif strcmp(Family,'SHD')
        ChanName = sprintf('SR%02dC___SHD%01d___%s00',  SectorList, DevList, ChanTypeStr);
    elseif (strcmp(Family,'SHDready') && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___SHD%01d___BM01',  SectorList, DevList);
    elseif (strcmp(Family,'SHDon')  && (ChanTypeFlag==0 || ChanTypeFlag==2))
        ChanName = sprintf('SR%02dC___SHD%01d___BM02',  SectorList, DevList);
    elseif (strcmp(Family,'SHDon') && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___SHD%01d___BC16',  SectorList, DevList);
    elseif (strcmp(Family,'SHDreset') && (ChanTypeFlag==1 || ChanTypeFlag==3))
        ChanName = sprintf('SR%02dC___SHD%01d___BC17',  SectorList, DevList);
        
    elseif findstr(Family,'QFA')
        if ~any([SectorList==4  SectorList==8  SectorList==12])
            SectorList = 1;
        end
        if (strcmp(Family,'QFA') && ChanTypeFlag==0)   % && (SectorList==1 || SectorList==4 || SectorList==8 || SectorList==12))
            ChanName = sprintf('SR%02dC___QFA____%s00',  SectorList, ChanTypeStr);
        elseif (strcmp(Family,'QFA') && ChanTypeFlag==1) % && (SectorList==1 || SectorList==4 || SectorList==8 || SectorList==12))
            ChanName = sprintf('SR%02dC___QFA____%s00',  SectorList, ChanTypeStr);
        elseif (strcmp(Family,'QFAtimeconstant')) % && (SectorList==1 || SectorList==4 || SectorList==8 || SectorList==12))
            ChanName = sprintf('SR%02dC___QFA____AC02',  SectorList);
        elseif (strcmp(Family,'QFAramprate'))  % && (SectorList==1 || SectorList==4 || SectorList==8 || SectorList==12))
            ChanName = sprintf('SR%02dC___QFA____AC03',  SectorList);
        elseif (strcmp(Family,'QFAready') && (ChanTypeFlag==0 || ChanTypeFlag==2) && (SectorList==4 || SectorList==8 || SectorList==12))
            ChanName = sprintf('SR%02dC___QFA____BM18',  SectorList);
        elseif (strcmp(Family,'QFAon')    && (ChanTypeFlag==0 || ChanTypeFlag==2) && (SectorList==4 || SectorList==8 || SectorList==12))
            ChanName = sprintf('SR%02dC___QFA____BM17',  SectorList);
        elseif (strcmp(Family,'QFAon')    && (ChanTypeFlag==1 || ChanTypeFlag==3) && (SectorList==4 || SectorList==8 || SectorList==12))
            ChanName = sprintf('SR%02dC___QFA____BC07',  SectorList);
        elseif (strcmp(Family,'QFAreset') && (ChanTypeFlag==1 || ChanTypeFlag==3) && (SectorList==4 || SectorList==8 || SectorList==12))
            ChanName = sprintf('SR%02dC___QFA_R__BC06',  SectorList);
        elseif (strcmp(Family,'QFAready') && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList==1)
            ChanName = sprintf('SR%02dC___QFA____BM02',  SectorList);
        elseif (strcmp(Family,'QFAon')    && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList==1)
            ChanName = sprintf('SR%02dC___QFA____BM04',  SectorList);
        elseif (strcmp(Family,'QFAon')    && (ChanTypeFlag==1 || ChanTypeFlag==3) && SectorList==1)
            ChanName = sprintf('SR%02dC___QFA____BC22',  SectorList);
        elseif (strcmp(Family,'QFAreset') && (ChanTypeFlag==1 || ChanTypeFlag==3) && SectorList==1)
            ChanName = sprintf('SR%02dC___QFA__R_BC23',  SectorList);
        elseif (strcmp(Family,'QFA') && (SectorList==2 || SectorList==3 || SectorList==5 || SectorList==6 || SectorList==7 || SectorList==9 || SectorList==10 || SectorList==11))
            error('No QFA magnet in that sector.');
        else
            ChanName = ' ';
            ErrorFlag = -1;
        end
        
        % Combine the BEND and Superbends
    elseif (strcmp(Family,'BEND') && ChanTypeFlag==0 && (SectorList==4 || SectorList==8 || SectorList==12) && DevList==2)
        ChanName = sprintf('SR%02dC___BSC_P__%s00',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'BEND') && ChanTypeFlag==1 && (SectorList==4 || SectorList==8 || SectorList==12) && DevList==2)
        ChanName = sprintf('SR%02dC___BSC_P__%s00',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'BENDtimeconstant') && (SectorList==4 || SectorList==8 || SectorList==12) && DevList==2)
        %error('No BENDtimeconstant for the superbends')
        ChanName = ' ';
    elseif (strcmp(Family,'BENDramprate') && (SectorList==4 || SectorList==8 || SectorList==12) && DevList==2)
        ChanName = sprintf('SR%02dC___BSC_P__AC01',  SectorList);
    elseif (strcmp(Family,'BENDdac') && (SectorList==4 || SectorList==8 || SectorList==12) && DevList==2)
        ChanName = sprintf('SR%02dC___BSC_P__AM01',  SectorList);
    elseif (strcmp(Family,'BENDlimit') && (SectorList==4 || SectorList==8 || SectorList==12) && DevList==2)
        ChanName = sprintf('SR%02dC___BSC_P__AC02',  SectorList);
    elseif (strcmp(Family,'BENDready') && (ChanTypeFlag==0 || ChanTypeFlag==2) && (SectorList==4 || SectorList==8 || SectorList==12) && DevList==2)
        ChanName = sprintf('SR%02dC___BSC_P__BM14',  SectorList);
    elseif (strcmp(Family,'BENDon') && (ChanTypeFlag==0 || ChanTypeFlag==2) && (SectorList==4 || SectorList==8 || SectorList==12) && DevList==2)
        ChanName = sprintf('SR%02dC___BSC_P__BM15',  SectorList);
    elseif (strcmp(Family,'BENDon') && (ChanTypeFlag==1 || ChanTypeFlag==3) && (SectorList==4 || SectorList==8 || SectorList==12) && DevList==2)
        ChanName = sprintf('SR%02dC___BSC_P__BC00',  SectorList);
    elseif (strcmp(Family,'BENDreset') && (ChanTypeFlag==1 || ChanTypeFlag==3) && (SectorList==4 || SectorList==8 || SectorList==12) && DevList==2)
        ChanName = sprintf('SR%02dC___BSC_PR_BC01',  SectorList);
        
    elseif (strcmp(Family,'BEND') && ChanTypeFlag==0) % && (SectorList==1 || SectorList==2 || SectorList==3 || SectorList==4 || SectorList==5 || SectorList==6 || SectorList==7 || SectorList==9 || SectorList==10 || SectorList==11)
        ChanName = sprintf('SR01C___B______%s00', ChanTypeStr);
    elseif (strcmp(Family,'BEND') && ChanTypeFlag==1) % && (SectorList==1 || SectorList==2 || SectorList==3 || SectorList==5 || SectorList==6 || SectorList==7 || SectorList==9 || SectorList==10 || SectorList==11)
        ChanName = sprintf('SR01C___B______%s00', ChanTypeStr);
    elseif (strcmp(Family,'BENDtimeconstant')) % && (SectorList==1 || SectorList==2 || SectorList==3 || SectorList==5 || SectorList==6 || SectorList==7 || SectorList==9 || SectorList==10 || SectorList==11)
        ChanName = sprintf('SR01C___B______AC02');
    elseif (strcmp(Family,'BENDramprate')) % && (SectorList==1 || SectorList==2 || SectorList==3 || SectorList==5 || SectorList==6 || SectorList==7 || SectorList==9 || SectorList==10 || SectorList==11)
        ChanName = sprintf('SR01C___B______AC03');
    elseif (strcmp(Family,'BENDready')) % && (ChanTypeFlag==0 || ChanTypeFlag==2)) && (SectorList==1 || SectorList==2 || SectorList==3 || SectorList==5 || SectorList==6 || SectorList==7 || SectorList==9 || SectorList==10 || SectorList==11)
        ChanName = sprintf('SR01C___B______BM18');
    elseif (strcmp(Family,'BENDon'))  && (ChanTypeFlag==0 || ChanTypeFlag==2) && (SectorList==1 || SectorList==2 || SectorList==3 || SectorList==5 || SectorList==6 || SectorList==7 || SectorList==9 || SectorList==10 || SectorList==11)
        ChanName = sprintf('SR01C___B______BM19');
    elseif (strcmp(Family,'BENDon'))  && (ChanTypeFlag==1 || ChanTypeFlag==3) && (SectorList==1 || SectorList==2 || SectorList==3 || SectorList==5 || SectorList==6 || SectorList==7 || SectorList==9 || SectorList==10 || SectorList==11)
        ChanName = sprintf('SR01C___B______BC23');
    elseif (strcmp(Family,'BENDreset')) % && (ChanTypeFlag==1 || ChanTypeFlag==3)) && (SectorList==1 || SectorList==2 || SectorList==3 || SectorList==5 || SectorList==6 || SectorList==7 || SectorList==9 || SectorList==10 || SectorList==11)
        ChanName = sprintf('SR01C___B____R_BC22');
        
    elseif (strcmp(Family,'BSC') && ChanTypeFlag==0 && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___BSC_P__%s00',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'BSC') && ChanTypeFlag==1 && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___BSC_P__%s00',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'BSCramprate') && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___BSC_P__AC01',  SectorList);
    elseif (strcmp(Family,'BSCdac') && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___BSC_P__AM01',  SectorList);
    elseif (strcmp(Family,'BSClimit') && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___BSC_P__AC02',  SectorList);
    elseif (strcmp(Family,'BSCready') && (ChanTypeFlag==0 || ChanTypeFlag==2) && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___BSC_P__BM14',  SectorList);
    elseif (strcmp(Family,'BSCon') && (ChanTypeFlag==0 || ChanTypeFlag==2) && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___BSC_P__BM15',  SectorList);
    elseif (strcmp(Family,'BSCon') && (ChanTypeFlag==1 || ChanTypeFlag==3) && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___BSC_P__BC00',  SectorList);
    elseif (strcmp(Family,'BSCreset') && (ChanTypeFlag==1 || ChanTypeFlag==3) && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___BSC_PR_BC01',  SectorList);
    elseif (strcmp(Family,'BSC') && (SectorList==1 || SectorList==2 || SectorList==3 || SectorList==5 || SectorList==6 || SectorList==7 || SectorList==9 || SectorList==10 || SectorList==11))
        error('No BSC magnet in that sector.');
        
        % BSC Hall Probes
    elseif (strcmp(Family,'BSChall') && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___BSCHALLAM00',  SectorList);
        
        % BSC Vertical Trim Correctors
    elseif (strcmp(Family,'VCBSC') && DevList==2 && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___VCBSC1_%s00',  SectorList, ChanTypeStr);
    elseif (strcmp(Family,'VCBSCready') && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2) && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___VCBSC1_BM10',  SectorList);
    elseif (strcmp(Family,'VCBSCon') && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2) && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___VCBSC1_BM09',  SectorList);
    elseif (strcmp(Family,'VCBSCon') && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3) && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___VCBSC1_BC15',  SectorList);
    elseif (strcmp(Family,'VCBSCreset') && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3) && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___VCBSC1RBC14',  SectorList);
    elseif (strcmp(Family,'VCBSCtimeconstant') && DevList==2 && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___VCBSC1_AC02',  SectorList);
    elseif (strcmp(Family,'VCBSCramprate') && DevList==2 && (SectorList==4 || SectorList==8 || SectorList==12))
        ChanName = sprintf('SR%02dC___VCBSC1_AC03',  SectorList);
    elseif (strcmp(Family,'VCBSC') && (SectorList==1 || SectorList==2 || SectorList==3 || SectorList==5 || SectorList==6 || SectorList==7 || SectorList==9 || SectorList==10 || SectorList==11))
        error('No VCBSC magnet in that sector.');
        
    elseif (strcmp(Family,'HCMCHICANE') && (DevList==1 || DevList==3) && (ChanTypeFlag==0 || ChanTypeFlag==1) && SectorList==4)
        ChanName = sprintf('SR%02dU___HCM%1d___%s01',  SectorList,  DevList, ChanTypeStr);
    elseif (strcmp(Family,'HCMCHICANE') && DevList==1 && (ChanTypeFlag==0 || ChanTypeFlag==1) && SectorList==6)
        ChanName = sprintf('SR%02dU___HCM%1d___%s00',  SectorList,  DevList, ChanTypeStr);
    elseif (strcmp(Family,'HCMCHICANE') && DevList==3 && (ChanTypeFlag==0 || ChanTypeFlag==1) && SectorList==6)
        ChanName = sprintf('SR%02dU___HCM%1d___%s01',  SectorList,  DevList, ChanTypeStr);
    elseif (strcmp(Family,'HCMCHICANE') && DevList==2 && (ChanTypeFlag==0) && (SectorList==6))
        ChanName = sprintf('SR%02dU___HCM%1d___%s01',  SectorList,  DevList, ChanTypeStr);
    elseif (strcmp(Family,'HCMCHICANE') && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==1) && (SectorList==4 || SectorList==6 || SectorList==11))
        ChanName = sprintf('SR%02dU___HCM%1d___%s00',  SectorList,  DevList, ChanTypeStr);
    elseif (strcmp(Family,'HCMCHICANEready') && (DevList==1 || DevList==3) && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList==4)
        ChanName = sprintf('SR%02dU___HCM%1d___BM04',  SectorList,  DevList);
    elseif (strcmp(Family,'HCMCHICANEready') && DevList==1 && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList==6)
        ChanName = sprintf('SR%02dU___HCM%1d___BM01',  SectorList,  DevList);
    elseif (strcmp(Family,'HCMCHICANEready') && DevList==3 && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList==6)
        ChanName = sprintf('SR%02dU___HCM%1d___BM04',  SectorList,  DevList);
    elseif (strcmp(Family,'HCMCHICANEready') && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2) && (SectorList==4 || SectorList==6 || SectorList==11))
        ChanName = sprintf('SR%02dU___HCM%1d___BM19',  SectorList,  DevList);
    elseif (strcmp(Family,'HCMCHICANEon') && (DevList==1 || DevList==3) && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList==4)
        ChanName = sprintf('SR%02dU___HCM%1d___BM05',  SectorList,  DevList);
    elseif (strcmp(Family,'HCMCHICANEon') && DevList==1 && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList==6)
        ChanName = sprintf('SR%02dU___HCM%1d___BM02',  SectorList,  DevList);
    elseif (strcmp(Family,'HCMCHICANEon') && DevList==3 && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList==6)
        ChanName = sprintf('SR%02dU___HCM%1d___BM05',  SectorList,  DevList);
    elseif (strcmp(Family,'HCMCHICANEon') && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2) && (SectorList==4 || SectorList==6 || SectorList==11))
        ChanName = sprintf('SR%02dU___HCM%1d___BM18',  SectorList,  DevList);
    elseif (strcmp(Family,'HCMCHICANEon') && (DevList==1 || DevList==3) && (ChanTypeFlag==1 || ChanTypeFlag==3) && SectorList==4)
        ChanName = sprintf('SR%02dU___HCM%1d___BC18',  SectorList,  DevList);
    elseif (strcmp(Family,'HCMCHICANEon') && DevList==1 && (ChanTypeFlag==1 || ChanTypeFlag==3) && SectorList==6)
        ChanName = sprintf('SR%02dU___HCM%1d___BC16',  SectorList,  DevList);
    elseif (strcmp(Family,'HCMCHICANEon') && DevList==3 && (ChanTypeFlag==1 || ChanTypeFlag==3) && SectorList==6)
        ChanName = sprintf('SR%02dU___HCM%1d___BC18',  SectorList,  DevList);
    elseif (strcmp(Family,'HCMCHICANEon') && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3) && (SectorList==4 || SectorList==6 || SectorList==11))
        ChanName = sprintf('SR%02dU___HCM%1d___BC23',  SectorList,  DevList);
    elseif (strcmp(Family,'HCMCHICANEdac') && (SectorList==4 || SectorList==6 || SectorList==11))
        ChanName = sprintf('SR%02dU___HCM%1d___AC10',  SectorList,  DevList);
    elseif (strcmp(Family,'HCMCHICANEtimeconstant') && (SectorList==4 || SectorList==6 || SectorList==11))
        ChanName = sprintf('SR%02dU___HCM%1d___AC20',  SectorList,  DevList);
    elseif (strcmp(Family,'HCMCHICANEramprate') && (SectorList==4 || SectorList==6 || SectorList==11))
        ChanName = sprintf('SR%02dU___HCM%1d___AC30',  SectorList,  DevList);
    elseif (strcmp(Family,'HCMCHICANEreset') && (DevList==1 || DevList==3) && ChanTypeFlag==3 && SectorList==4)
        ChanName = sprintf('SR%02dU___HCM%1d_R_BC19',  SectorList,  DevList);
    elseif (strcmp(Family,'HCMCHICANEreset') && DevList==1 && ChanTypeFlag==3 && SectorList==6)
        ChanName = sprintf('SR%02dU___HCM%1d_R_BC17',  SectorList,  DevList);
    elseif (strcmp(Family,'HCMCHICANEreset') && DevList==3 && ChanTypeFlag==3 && SectorList==6)
        ChanName = sprintf('SR%02dU___HCM%1d___BC19',  SectorList,  DevList);
        % No reset channels for chicane magnet trim coils
        
    % Changed EPOS to RBV since sector 6 does not have a EPOS (GJP 2005-06-07)
    elseif (strcmp(Family,'HCMCHICANEM') && DevList==1 && ChanTypeFlag==0 && (SectorList==4 || SectorList==11))
        ChanName = sprintf('SR%02dU___HCM2M1_AC00',  SectorList);
    elseif (strcmp(Family,'HCMCHICANEM') && DevList==2 && ChanTypeFlag==0 && (SectorList==4 || SectorList==11))
        ChanName = sprintf('SR%02dU___HCM2M2_AC01',  SectorList);
    elseif (strcmp(Family,'HCMCHICANEM') && DevList==1 && ChanTypeFlag==1 && (SectorList==4 || SectorList==11))
        ChanName = sprintf('SR%02dU___HCM2M1_AC00',  SectorList);
    elseif (strcmp(Family,'HCMCHICANEM') && DevList==2 && ChanTypeFlag==1 && (SectorList==4 || SectorList==11))
        ChanName = sprintf('SR%02dU___HCM2M2_AC01',  SectorList);
    % SR07 chicane has AMs instead of .RBVs - 9-16-13, T.Scarvie - now also sector 6 (C. Steier, 2015-01-08)
    elseif (strcmp(Family,'HCMCHICANEM') && DevList==1 && ChanTypeFlag==0 && (SectorList==6 || SectorList==7))
        ChanName = sprintf('SR%02dU___HCM2M1_AM00',  SectorList);
    elseif (strcmp(Family,'HCMCHICANEM') && DevList==2 && ChanTypeFlag==0 && (SectorList==6 || SectorList==7))
        ChanName = sprintf('SR%02dU___HCM2M2_AM01',  SectorList);
    elseif (strcmp(Family,'HCMCHICANEM') && DevList==1 && ChanTypeFlag==1 && (SectorList==6 || SectorList==7))
        ChanName = sprintf('SR%02dU___HCM2M1_AC00',  SectorList);
    elseif (strcmp(Family,'HCMCHICANEM') && DevList==2 && ChanTypeFlag==1 && (SectorList==6 || SectorList==7))
        ChanName = sprintf('SR%02dU___HCM2M2_AC01',  SectorList);
    elseif (strcmp(Family,'HCMCHICANEMramprate') && (SectorList==4 || SectorList==6 || SectorList==7 || SectorList==11))
        ChanName = sprintf('SR%02dU___HCM2MV_AC00',  SectorList);
        
    elseif (strncmp(Family,'HCMCHICANE',10) && (SectorList==1 || SectorList==2 || SectorList==3 || SectorList==5 || SectorList==7 || SectorList==8 || SectorList==9 || SectorList==10 || SectorList==12))
        error('No CHICANE magnets in that sector.');
        
    elseif (strcmp(Family,'VCMCHICANE') && (DevList==1 || DevList==3) && (ChanTypeFlag==0 || ChanTypeFlag==1) && (SectorList==4))
        ChanName = sprintf('SR%02dU___VCM%1d___%s00',  SectorList,  DevList, ChanTypeStr);
    elseif (strcmp(Family,'VCMCHICANE') && DevList==2 && (ChanTypeFlag==0) && (SectorList==6))
        ChanName = sprintf('SR%02dU___VCM%1d___%s01',  SectorList,  DevList, ChanTypeStr);
    elseif (strcmp(Family,'VCMCHICANE') && DevList==2 && (ChanTypeFlag==1) && (SectorList==6))
        ChanName = sprintf('SR%02dU___VCM%1d___%s00',  SectorList,  DevList, ChanTypeStr);
    elseif (strcmp(Family,'VCMCHICANE') && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==1) && (SectorList==4 || SectorList==6 || SectorList==11))
        ChanName = sprintf('SR%02dU___VCM%1d___%s01',  SectorList,  DevList, ChanTypeStr);
    elseif (strcmp(Family,'VCMCHICANEready') && (DevList==1 || DevList==3) && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList==4)
        ChanName = sprintf('SR%02dU___VCM%1d___BM01',  SectorList,  DevList);
    elseif (strcmp(Family,'VCMCHICANEready') && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2) && (SectorList==4 || SectorList==6 || SectorList==11))
        ChanName = sprintf('SR%02dU___VCM%1d___BM17',  SectorList,  DevList);
    elseif (strcmp(Family,'VCMCHICANEon') && (DevList==1 || DevList==3) && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList==4)
        ChanName = sprintf('SR%02dU___VCM%1d___BM02',  SectorList,  DevList);
    elseif (strcmp(Family,'VCMCHICANEon') && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2) && (SectorList==4 || SectorList==6 || SectorList==11))
        ChanName = sprintf('SR%02dU___VCM%1d___BM16',  SectorList,  DevList);
    elseif (strcmp(Family,'VCMCHICANEon') && (DevList==1 || DevList==3) && (ChanTypeFlag==1 || ChanTypeFlag==3) && SectorList==4)
        ChanName = sprintf('SR%02dU___VCM%1d___BC16',  SectorList,  DevList);
    elseif (strcmp(Family,'VCMCHICANEon') && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3) && (SectorList==4 || SectorList==6 || SectorList==11))
        ChanName = sprintf('SR%02dU___VCM%1d___BC22',  SectorList,  DevList);
    elseif (strcmp(Family,'VCMCHICANEdac') && (SectorList==4 || SectorList==6 || SectorList==11))
        ChanName = sprintf('SR%02dU___VCM%1d___AC10',  SectorList,  DevList);
    elseif (strcmp(Family,'VCMCHICANEtimeconstant') && (SectorList==4 || SectorList==6 || SectorList==11))
        ChanName = sprintf('SR%02dU___VCM%1d___AC20',  SectorList,  DevList);
    elseif (strcmp(Family,'VCMCHICANEramprate') && (SectorList==4 || SectorList==6 || SectorList==11))
        ChanName = sprintf('SR%02dU___VCM%1d___AC30',  SectorList,  DevList);
    elseif (strcmp(Family,'VCMCHICANEreset') && (DevList==1 || DevList==3) && ChanTypeFlag==3 && SectorList==4)
        ChanName = sprintf('SR%02dU___VCM%1d_R_BC17',  SectorList,  DevList);
        % No reset channels for chicane magnet trim coils
    elseif (strncmp(Family,'VCMCHICANE',10) && (SectorList==1 || SectorList==2 || SectorList==3 || SectorList==5 || SectorList==7 || SectorList==8 || SectorList==9 || SectorList==10 || SectorList==12))
        error('No CHICANE magnets in that sector.');
        
        % Insertion devices
    elseif (strcmp(Family,'ID'))
        if (SectorList==5)
            ChanName = sprintf('SR%02dW___GDS1PS_%s00',    SectorList, ChanTypeStr);
        elseif (SectorList==4 || SectorList==6 || SectorList==7 || SectorList==11)
            ChanName = sprintf('SR%02dU___GDS%1dPS_%s00',  SectorList, DevList, ChanTypeStr);
% %%%%%%%% added 8-31-16 since one encoder on EPU6-2 broke
%         if SectorList==6 && DevList==2 && strcmp(ChanTypeStr,'AM')
%             ChanName = sprintf('SR06U___GDS2PS_AM01');
%         end
% %%%%%%%%
        else
            ChanName = sprintf('SR%02dU___GDS1PS_%s00',    SectorList, ChanTypeStr);
        end
    elseif (strcmp(Family,'IDpos'))
        if (SectorList==5)
            ChanName = sprintf('SR%02dW___GDS1PS_%s00',    SectorList, ChanTypeStr);
        elseif (SectorList==4 || SectorList==6 || SectorList==7 || SectorList==11)
            ChanName = sprintf('SR%02dU___GDS%1dPS_%s00',  SectorList, DevList, ChanTypeStr);
        else
            ChanName = sprintf('SR%02dU___GDS1PS_%s00',    SectorList, ChanTypeStr);
        end
    elseif (strcmp(Family,'IDvel'))
        if (SectorList==5)
            ChanName = sprintf('SR%02dW___GDS1V__%s01',    SectorList, ChanTypeStr);
        elseif (SectorList==4 || SectorList==6 || SectorList==7 || SectorList==11)
            ChanName = sprintf('SR%02dU___GDS%1dV__%s01',  SectorList, DevList, ChanTypeStr);
        else
            ChanName = sprintf('SR%02dU___GDS1V__%s01',    SectorList, ChanTypeStr);
        end
    elseif (strcmp(Family,'IDrunflag'))
        if (SectorList==5)
            ChanName = sprintf('SR%02dW___GDS1PS_BM00',    SectorList);
        elseif (SectorList==4 || SectorList==6 || SectorList==7 || SectorList==11)
            ChanName = sprintf('SR%02dU___GDS%1dPS_BM00',  SectorList, DevList);
        else
            ChanName = sprintf('SR%02dU___GDS1PS_BM00',    SectorList);
        end
    elseif strcmp(Family,'MoveCount')
        if (SectorList==5)
            ChanName = sprintf('SR%02dW___GDS%1dE__AM02', SectorList, DevList);
        else
            ChanName = sprintf('SR%02dU___GDS%1dE__AM02', SectorList, DevList);
        end
    elseif strcmp(Family,'Amp')
        if any(SectorList==5)          
            ChanName = ' ';  %sprintf('SR%02dW___GDS%1dPS_BM04', SectorList, DevList);
        elseif (SectorList==6) && (DevList==1)          
            ChanName = ' ';  %sprintf('SR%02dW___GDS%1dPS_BM04', SectorList, DevList);
        else
            ChanName = sprintf('SR%02dU___GDS%1dPS_BM04', SectorList, DevList);
        end        
    elseif strcmp(Family,'AmpReset')
        if any(SectorList==5)
            ChanName = ' ';  %sprintf('SR%02dW___GDS%1dPS_BC04', SectorList, DevList);
        elseif (SectorList==6) && (DevList==1)          
            ChanName = ' ';  %sprintf('SR%02dW___GDS%1dPS_BC04', SectorList, DevList);
        else
            ChanName = sprintf('SR%02dU___GDS%1dPS_BC04', SectorList, DevList);
        end        
    elseif strcmp(Family,'EPUAmp')
        if any(SectorList==[4 6 7 11])
            ChanName = sprintf('SR%02dU___ODS%1dPS_BM04', SectorList, DevList);
        else
            ChanName = ' ';
        end        
    elseif strcmp(Family,'EPUAmpReset')
        if any(SectorList==[4 6 7 11])
            ChanName = sprintf('SR%02dU___ODS%1dPS_BC04', SectorList, DevList);
        else
            ChanName = ' ';
        end        
    elseif strcmp(Family,'UserGap')
        if ((SectorList==4 || SectorList==6) && DevList==2) || SectorList==7 || SectorList==11
            ChanName = sprintf('sr%02du%1d:bl_input', SectorList, DevList);
        else
            ChanName = sprintf('cmm:ID%d_bl_input', SectorList);
        end
    elseif strcmp(Family,'EPUUserGap')
        if SectorList==4
            ChanName = sprintf('cmm:ID%d_bl_input', SectorList);
        elseif SectorList==11
            ChanName = sprintf('sr%02du%1d:bl_input', SectorList, DevList);
        else
            ChanName = ' ';
            ErrorFlag = -1;
        end
    elseif strcmp(Family,'EPUUserGapZ')
        if SectorList==4 && DevList==1
            ChanName = sprintf('cmm:ID%d_bl_input_h', SectorList);
        elseif SectorList==4 && DevList==2
            ChanName = sprintf('sr%02du%1d:bl_input_h', SectorList, DevList);
        elseif SectorList==6 || SectorList==7 || SectorList==11
            ChanName = sprintf('sr%02du%1d:bl_input_h', SectorList, DevList);
        else
            ChanName = ' ';
            ErrorFlag = -1;
        end
        
        % Velocity Profile
    elseif strcmp(Family,'IDVelocityProfile')
        if SectorList==5
            ChanName = sprintf('SR%02dW___GDS%1dE__BC02', SectorList, DevList);
        else
            ChanName = sprintf('SR%02dU___GDS%1dE__BC02', SectorList, DevList);
        end
%     elseif strcmp(Family,'IDVelocityProfile') &&  SectorList==4 && DevList==2
%         ChanName = sprintf('SR%02dU___GDS%1dE__BC02', SectorList, DevList);
%     elseif strcmp(Family,'IDVelocityProfile') && SectorList==5
%         ChanName = sprintf('SR%02dW___GDS1E__BC02', SectorList);
%     elseif strcmp(Family,'IDVelocityProfile') && SectorList==11
%         ChanName = sprintf('SR%02dU___GDS%1dE__BC02', SectorList, DevList);
%     elseif strcmp(Family,'IDVelocityProfile')
%         ChanName = sprintf('SR%02dU___GDS1E__BC02', SectorList);

        % FFEnable
    elseif strcmp(Family,'FFEnable') && (SectorList==4 || SectorList==6 || SectorList==7) && DevList==2
        ChanName = sprintf('sr%02du%1d:FFEnable:%s', SectorList, DevList, EPICSChanTypeStr);
    elseif strcmp(Family,'FFEnable') && SectorList==5
        ChanName = sprintf('sr%02dw:FFEnable:%s', SectorList, EPICSChanTypeStr);
    elseif strcmp(Family,'FFEnable') && (SectorList==7 || SectorList==11)
        ChanName = sprintf('sr%02du%1d:FFEnable:%s', SectorList, DevList, EPICSChanTypeStr);
    elseif strcmp(Family,'FFEnable')
        ChanName = sprintf('sr%02du:FFEnable:%s', SectorList, EPICSChanTypeStr);
        
        % GapEnable
    elseif strcmp(Family,'GapEnable') && (SectorList==4 || SectorList==6 || SectorList==7) && DevList==2
        ChanName = sprintf('sr%02du%1d:GapEnable:%s', SectorList, DevList, EPICSChanTypeStr);
    elseif strcmp(Family,'GapEnable') && SectorList==5
        ChanName = sprintf('sr%02dw:GapEnable:%s', SectorList, EPICSChanTypeStr);
    elseif strcmp(Family,'GapEnable') && (SectorList==7 || SectorList==11)
        ChanName = sprintf('sr%02du%1d:GapEnable:%s', SectorList, DevList, EPICSChanTypeStr);
    elseif strcmp(Family,'GapEnable')
        ChanName = sprintf('sr%02du:GapEnable:%s', SectorList, EPICSChanTypeStr);
        
    elseif strcmp(Family,'GapEnableBC') && (SectorList==4 || SectorList==6 || SectorList==7) && DevList==2
        ChanName = sprintf('sr%02du%1d:opr_grant', SectorList, DevList);
        
    elseif strcmp(Family,'GapEnableBC') && (SectorList==7 || SectorList==11)
        ChanName = sprintf('sr%02du%1d:opr_grant', SectorList, DevList);
    elseif strcmp(Family,'GapEnableBC')
        ChanName = sprintf('cmm:ID%d_opr_grant', SectorList);
        
    elseif strcmp(Family,'EPU')
        ChanName = sprintf('SR%02dU___ODS%1dPS_%s00', SectorList, DevList, ChanTypeStr);
    elseif strcmp(Family,'EPUOffsetA')
        ChanName = sprintf('SR%02dU___ODA%1dPS_AM00', SectorList, DevList);
    elseif strcmp(Family,'EPUOffsetASP')
        ChanName = sprintf('SR%02dU___ODA%1dPS_AC02', SectorList, DevList);
    elseif strcmp(Family,'EPUOffsetB')
        ChanName = sprintf('SR%02dU___ODB%1dPS_AM01', SectorList, DevList);
    elseif strcmp(Family,'EPUOffsetBSP')
        ChanName = sprintf('SR%02dU___ODB%1dPS_AC03', SectorList, DevList);
    elseif strcmp(Family,'EPUvel')
        ChanName = sprintf('SR%02dU___ODS%1dV__AM01', SectorList, DevList);
    elseif strcmp(Family,'EPUvelcontrol')
        ChanName = sprintf('SR%02dU___ODS%1dV__AC01', SectorList, DevList);
    elseif strcmp(Family,'EPUrunflag')
        ChanName = sprintf('SR%02dU___ODS%1dPS_BM00', SectorList, DevList);
    elseif strcmp(Family,'EPUmovecount')
        ChanName = sprintf('SR%02dU___ODS%1dE__AM02', SectorList, DevList);
    elseif strcmp(Family,'EPUZMode')
        ChanName = sprintf('SR%02dU___ODS%1dM__DC00', SectorList, DevList);

    elseif strncmp(Family,'SQEPU',5)
        if SectorList==4
            if (strcmp(Family,'SQEPU') && DevList==1 && ChanTypeFlag==0)
                ChanName = sprintf('SR%02dU___Q1_____AM00',  SectorList);
            elseif (strcmp(Family,'SQEPU') && DevList==1 && ChanTypeFlag==1)
                ChanName = sprintf('SR%02dU___Q1_____AC00',  SectorList);
            elseif strcmp(Family,'SQEPUFF')
                ChanName = sprintf('SR%02dU___Q%1dFF___AC00',  SectorList, DevList);
            elseif strcmp(Family,'SQEPUFFMultiplier')
                ChanName = sprintf('SR%02dU___Q%1dM____AC00',  SectorList, DevList);
            elseif strcmp(Family,'SQEPUFFSum')
                ChanName = sprintf('SR%02dU___Q%1dJ____AC00',  SectorList, DevList);
            elseif (strcmp(Family,'SQEPUready') && DevList==1 && (ChanTypeFlag==0 || ChanTypeFlag==2))
                ChanName = sprintf('SR%02dU___Q1_____BM15',  SectorList);
            elseif (strcmp(Family,'SQEPUon')    && DevList==1 && (ChanTypeFlag==0 || ChanTypeFlag==2))
                ChanName = sprintf('SR%02dU___Q1_____BM14',  SectorList);
            elseif (strcmp(Family,'SQEPUon')    && DevList==1 && (ChanTypeFlag==1 || ChanTypeFlag==3))
                ChanName = sprintf('SR%02dU___Q1_____BC21',  SectorList);
            elseif (strcmp(Family,'SQEPUdac') && DevList==1 && ChanTypeFlag==1)
                ChanName = sprintf('SR%02dU___Q1_____AC10',  SectorList);
            elseif (strcmp(Family,'SQEPUtimeconstant') && DevList==1 && ChanTypeFlag==1)
                ChanName = sprintf('SR%02dU___Q1_____AC20',  SectorList);
            elseif (strcmp(Family,'SQEPUramprate') && DevList==1 && ChanTypeFlag==1)
                ChanName = sprintf('SR%02dU___Q1_____AC30',  SectorList);
                
                
            elseif (strcmp(Family,'SQEPU') && DevList==2 && ChanTypeFlag==0)
                ChanName = sprintf('SR%02dU___Q2_____AM00',  SectorList);
            elseif (strcmp(Family,'SQEPU') && DevList==2 && ChanTypeFlag==1)
                ChanName = sprintf('SR%02dU___Q2_____AC00',  SectorList);
            elseif (strcmp(Family,'SQEPUready') && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2))
                ChanName = sprintf('SR%02dU___Q2_____BM10',  SectorList);
            elseif (strcmp(Family,'SQEPUon')    && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2))
                ChanName = sprintf('SR%02dU___Q2_____BM11',  SectorList);
            elseif (strcmp(Family,'SQEPUon')    && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3))
                ChanName = sprintf('SR%02dU___Q2_____BC20',  SectorList);
            elseif (strcmp(Family,'SQEPUdac') && DevList==2 && ChanTypeFlag==1)
                ChanName = sprintf('SR%02dU___Q2_____AC10',  SectorList);
            elseif (strcmp(Family,'SQEPUtimeconstant') && DevList==2 && ChanTypeFlag==1)
                ChanName = sprintf('SR%02dU___Q2_____AC20',  SectorList);
            elseif (strcmp(Family,'SQEPUramprate') && DevList==2 && ChanTypeFlag==1)
                ChanName = sprintf('SR%02dU___Q2_____AC30',  SectorList);
            else
                ChanName = ' ';
                ErrorFlag = -1;
            end
        elseif SectorList==6
            if (strcmp(Family,'SQEPU') && DevList==2 && ChanTypeFlag==0)
                ChanName = sprintf('SR%02dU___Q2_____AM00',  SectorList);
            elseif (strcmp(Family,'SQEPU') && DevList==2 && ChanTypeFlag==1)
                ChanName = sprintf('SR%02dU___Q2_____AC00',  SectorList);
            elseif strcmp(Family,'SQEPUFF')
                ChanName = sprintf('SR%02dU___Q2FF___AC00',  SectorList);
            elseif strcmp(Family,'SQEPUFFMultiplier')
                ChanName = sprintf('SR%02dU___Q2M____AC00',  SectorList);
            elseif strcmp(Family,'SQEPUFFSum')
                ChanName = sprintf('SR%02dU___Q2J____AC00',  SectorList);
            elseif (strcmp(Family,'SQEPUready') && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2))
                ChanName = sprintf('SR%02dU___Q2_____BM19',  SectorList);
            elseif (strcmp(Family,'SQEPUon')    && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2))
                ChanName = sprintf('SR%02dU___Q2_____BM18',  SectorList);
            elseif (strcmp(Family,'SQEPUon')    && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3))
                ChanName = sprintf('SR%02dU___Q2_____BC20',  SectorList);
            elseif (strcmp(Family,'SQEPUdac') && DevList==2 && ChanTypeFlag==1)
                ChanName = sprintf('SR%02dU___Q2_____AC10',  SectorList);
            elseif (strcmp(Family,'SQEPUtimeconstant') && DevList==2 && ChanTypeFlag==1)
                ChanName = sprintf('SR%02dU___Q2_____AC20',  SectorList);
            elseif (strcmp(Family,'SQEPUramprate') && DevList==2 && ChanTypeFlag==1)
                ChanName = sprintf('SR%02dU___Q2_____AC30',  SectorList);
            else
                ChanName = ' ';
                ErrorFlag = -1;
            end
        elseif SectorList==7
            if (strcmp(Family,'SQEPU') && DevList==1 && ChanTypeFlag==0)
                ChanName = sprintf('SR%02dU___Q1_____AM00',  SectorList);
            elseif (strcmp(Family,'SQEPU') && DevList==1 && ChanTypeFlag==1)
                ChanName = sprintf('SR%02dU___Q1_____AC00',  SectorList);
            elseif strcmp(Family,'SQEPUFF') && DevList==1
                ChanName = sprintf('SR%02dU___Q1FF___AC00',  SectorList);
            elseif strcmp(Family,'SQEPUFFMultiplier') && DevList==1
                ChanName = sprintf('SR%02dU___Q1M____AC00',  SectorList);
            elseif strcmp(Family,'SQEPUFFSum') && DevList==1
                ChanName = sprintf('SR%02dU___Q1J____AC00',  SectorList);
            elseif strcmp(Family,'SQEPUready') && DevList==1
                ChanName = sprintf('SR%02dU___Q1_____BM15',  SectorList);
            elseif strcmp(Family,'SQEPUon') && DevList==1 && (ChanTypeFlag==0 || ChanTypeFlag==2)
                ChanName = sprintf('SR%02dU___Q1_____BM14',  SectorList);
            elseif strcmp(Family,'SQEPUreset') && DevList==1
                ChanName = sprintf('SR%02dU___Q1_____BC01',  SectorList);
            elseif strcmp(Family,'SQEPUon') && DevList==1 && (ChanTypeFlag==1 || ChanTypeFlag==3)
                ChanName = sprintf('SR%02dU___Q1_____BC21',  SectorList);
            elseif strcmp(Family,'SQEPUdac') && DevList==1 && ChanTypeFlag==1
                ChanName = sprintf('SR%02dU___Q1_____AC10',  SectorList);
            elseif (strcmp(Family,'SQEPUramprate') && DevList==1 && ChanTypeFlag==1)
                ChanName = sprintf('SR%02dU___Q1_____AC30',  SectorList);
                
                
            elseif (strcmp(Family,'SQEPU') && DevList==2 && ChanTypeFlag==0)
                ChanName = sprintf('SR%02dU___Q2_____AM00',  SectorList);
            elseif (strcmp(Family,'SQEPU') && DevList==2 && ChanTypeFlag==1)
                ChanName = sprintf('SR%02dU___Q2_____AC00',  SectorList);
            elseif strcmp(Family,'SQEPUFF')
                ChanName = sprintf('SR%02dU___Q2FF___AC00',  SectorList);
            elseif strcmp(Family,'SQEPUFFMultiplier')
                ChanName = sprintf('SR%02dU___Q2M____AC00',  SectorList);
            elseif strcmp(Family,'SQEPUFFSum')
                ChanName = sprintf('SR%02dU___Q2J____AC00',  SectorList);
            elseif (strcmp(Family,'SQEPUready'))
                ChanName = sprintf('SR%02dU___Q2_____BM10',  SectorList);
            elseif (strcmp(Family,'SQEPUon') && (ChanTypeFlag==0 || ChanTypeFlag==2))
                ChanName = sprintf('SR%02dU___Q2_____BM11',  SectorList);
            elseif (strcmp(Family,'SQEPUreset'))
                ChanName = sprintf('SR%02dU___Q2_____BC01',  SectorList);
            elseif (strcmp(Family,'SQEPUon') && (ChanTypeFlag==1 || ChanTypeFlag==3))
                ChanName = sprintf('SR%02dU___Q2_____BC20',  SectorList);
            elseif (strcmp(Family,'SQEPUdac') && ChanTypeFlag==1)
                ChanName = sprintf('SR%02dU___Q2_____AC10',  SectorList);
            elseif (strcmp(Family,'SQEPUramprate') && ChanTypeFlag==1)
                ChanName = sprintf('SR%02dU___Q2_____AC30',  SectorList);
            else
                ChanName = ' ';
                ErrorFlag = -1;
            end
        elseif SectorList==11
            if (strcmp(Family,'SQEPU') && ChanTypeFlag==0)
                ChanName = sprintf('SR%02dU___Q%1d_____AM00',  SectorList, DevList);
            elseif (strcmp(Family,'SQEPU') && ChanTypeFlag==1)
                ChanName = sprintf('SR%02dU___Q%1d_____AC01',  SectorList, DevList);
            elseif strcmp(Family,'SQEPUFF')
                ChanName = sprintf('SR%02dU___Q%1dFF___AC00',  SectorList, DevList);
            elseif strcmp(Family,'SQEPUFFMultiplier')
                ChanName = sprintf('SR%02dU___Q%1dM____AC01',  SectorList, DevList);
            elseif strcmp(Family,'SQEPUFFSum')
                ChanName = sprintf('SR%02dU___Q%1dJ____AC01',  SectorList, DevList);
            elseif (strcmp(Family,'SQEPUready') && (ChanTypeFlag==0 || ChanTypeFlag==2))
                ChanName = sprintf('SR%02dU___Q%1d_____BM17',  SectorList, DevList);
            elseif (strcmp(Family,'SQEPUon') && (ChanTypeFlag==0 || ChanTypeFlag==2))
                ChanName = sprintf('SR%02dU___Q%1d_____BM16',  SectorList, DevList);
            elseif (strcmp(Family,'SQEPUon') && (ChanTypeFlag==1 || ChanTypeFlag==3))
                ChanName = sprintf('SR%02dU___Q%1d_____BC22',  SectorList, DevList);
            elseif (strcmp(Family,'SQEPUdac') && ChanTypeFlag==1)
                ChanName = sprintf('SR%02dU___Q%1d_____AC10',  SectorList, DevList);
            elseif (strcmp(Family,'SQEPUtimeconstant') && ChanTypeFlag==1)
                ChanName = sprintf('SR%02dU___Q%1d_____AC20',  SectorList, DevList);
            elseif (strcmp(Family,'SQEPUramprate') && ChanTypeFlag==1)
                ChanName = sprintf('SR%02dU___Q%1d_____AC30',  SectorList, DevList);
            else
                ChanName = ' ';
                ErrorFlag = -1;
            end
        else
            ChanName = ' ';
            ErrorFlag = -1;
        end
        
        % SR04U___Q1_____AC10	DAC out
        % SR04U___Q1_____AC00	Set Current
        % SR04U___Q1_____AC20	Time Constant
        % SR04U___Q1_____AC30	Ramp Rate
        % SR04U___Q1_____AM00	CURRENT_MON
        % SR04U___Q1_____BC21	PS_ON/OFF_CNTRL
        % SR04U___Q1_____BM15	PS_READY_MON
        % SR04U___Q1_____BM14	PS_ON_MONITOR
        % SR04U___Q1M____AC00	Multiplier for auto settings
        % SR04U___Q1FF___AC00	Feed Forward Current Setting
        % SR04U___Q1___TRBM15	Ready Off Notification
        % SR04U___Q1___TRBM14	PS Off Unexpectedly
        % SR04U___Q1___HWBC21	Hardware PS On/Off
        % SR04U___Q1J____AC00	Summing Junction
        % SR04U___Q1_____GS00	Power Supply Control
        %
        % SR04U___Q2_____AC10	DAC out
        % SR04U___Q2_____AC00	Set Current
        % SR04U___Q2_____AC20	Time Constant
        % SR04U___Q2_____AC30	Ramp Rate
        % SR04U___Q2_____AM00	CURRENT_MON
        % SR04U___Q2_____BC20	PS_ON/OFF_CNTRL
        % SR04U___Q2_____BM10	PS_READY_MON
        % SR04U___Q2_____BM11	PS_ON_MONITOR
        % SR04U___Q2M____AC00	Multiplier for auto settings
        % SR04U___Q2FF___AC00	Feed Forward Current Setting
        % SR04U___Q2___TRBM10	Ready Off Notification
        % SR04U___Q2___TRBM11	PS Off Unexpectedly
        % SR04U___Q2___HWBC20	Hardware PS On/Off
        % SR04U___Q2J____AC00	Summing Junction
        % SR04U___Q2_____GS00	Power Supply Control
        %
        % SR07U___Q2FF___AC00 FF Current Setting
        % SR07U___Q2J____AC00 Summing Junction
        % SR07U___Q2M____AC00 Multiplier for auto settings
        % SR07U___Q2_____AC00 Set Current
        % SR07U___Q2_____AC10 Current setpoint
        % SR07U___Q2_____AC30 Output slew rate
        % SR07U___Q2_____AM00 Current readback
        % SR07U___Q2_____BC01 Reset supply
        % SR07U___Q2_____BC20 Turn supply off/on
        % SR07U___Q2_____BM10 PS_READY_MON
        % SR07U___Q2_____BM10_calc
        % SR07U___Q2_____BM11 Supply on?
        % SR07U___Q2_____BM13 temp ok
        % SR07U___Q2_____BM13_calc
        %
        % SR11U___Q1_____AC10	DAC out
        % SR11U___Q1_____AC01	Set Current
        % SR11U___Q1_____AC20	Time Constant
        % SR11U___Q1_____AC30	Ramp Rate
        % SR11U___Q1_____AM00	CURRENT_MON
        % SR11U___Q1_____BC22	PS_ON/OFF_CNTRL
        % SR11U___Q1_____BM17	PS_READY_MON
        % SR11U___Q1_____BM16	PS_ON_MONITOR
        % SR11U___Q1M____AC01	Multiplier for auto settings
        % SR11U___Q1FF___AC00	Feed Forward Current Setting
        % SR11U___Q1___TRBM17	Ready Off Notification
        % SR11U___Q1___TRBM16	PS Off Unexpectedly
        % SR11U___Q1___HWBC22	Hardware PS On/Off
        % SR11U___Q1J____AC01	Summing Junction
        % SR11U___Q1_____GS00	Power Supply Control
        %
        % SR11U___Q2_____AC10	DAC out
        % SR11U___Q2_____AC01	Set Current
        % SR11U___Q2_____AC20	Time Constant
        % SR11U___Q2_____AC30	Ramp Rate
        % SR11U___Q2_____AM00	CURRENT_MON
        % SR11U___Q2_____BC22	PS_ON/OFF_CNTRL
        % SR11U___Q2_____BM17	PS_READY_MON
        % SR11U___Q2_____BM16	PS_ON_MONITOR
        % SR11U___Q2M____AC01	Multiplier for auto settings
        % SR11U___Q2FF___AC00	Feed Forward Current Setting
        % SR11U___Q2___TRBM17	Ready Off Notification
        % SR11U___Q2___TRBM16	PS Off Unexpectedly
        % SR11U___Q2___HWBC22	Hardware PS On/Off
        % SR11U___Q2J____AC01	Summing Junction
        % SR11U___Q2_____GS00	Power Supply Control
        
    elseif (strcmp(Family,'TOPSCRAPER') && ChanTypeFlag==0)
        if SectorList==3
            ChanName = sprintf('SR03S___SCRAPT_AC01.EPOS');
            %ChanName = sprintf('SR03S___SCRAPT_AC01.RBV');  % GP 2009-05-06
        else
            ChanName = sprintf('SR%02dC___SCRAP%1dTAC01.RBV',  SectorList, DevList);
        end
    elseif (strcmp(Family,'TOPSCRAPER') && ChanTypeFlag==1)
        if SectorList==3
            ChanName = sprintf('SR03S___SCRAPT_AC01.VAL');
        else
            ChanName = sprintf('SR%02dC___SCRAP%1dTAC01.VAL',  SectorList, DevList);
        end
    elseif (strcmp(Family,'BOTTOMSCRAPER') && ChanTypeFlag==0)
        if SectorList==3
            ChanName = sprintf('SR03S___SCRAPB_AC02.EPOS');
        else
            ChanName = sprintf('SR%02dC___SCRAP%1dBAC01.RBV',  SectorList, DevList);
        end
    elseif (strcmp(Family,'BOTTOMSCRAPER') && ChanTypeFlag==1)
        if SectorList==3
            ChanName = sprintf('SR03S___SCRAPB_AC02.VAL');
        else
            ChanName = sprintf('SR%02dC___SCRAP%1dBAC01.VAL',  SectorList, DevList);
        end
    elseif (strcmp(Family,'INSIDESCRAPER') && SectorList==3 && ChanTypeFlag==0)
        %ChanName = sprintf('SR03S___SCRAPH_AC00.EPOS');
        ChanName = sprintf('SR03S___SCRAPH_AC00.RBV');  % GP 2009-05-06
    elseif (strcmp(Family,'INSIDESCRAPER') && SectorList==3 && ChanTypeFlag==1)
        ChanName = sprintf('SR03S___SCRAPH_AC00.VAL');
        
        
        
    else
        ChanName = ' ';
        ErrorFlag = -1;
    end
    
    % Check for missing magnets
    if ((strcmp(Family,'HCM') || strcmp(Family,'VCM')) && SectorList==1 && DevList==1)
        error('HCM1 && VCM1 are missing from sector 1.');
    elseif ((strcmp(Family,'HCM') || strcmp(Family,'VCM')) && SectorList==12 && DevList==8)
        error('HCM4 && VCM4 are missing from sector 12.');
    end
    
    ChannelName = strvcat(ChannelName, ChanName);
end

