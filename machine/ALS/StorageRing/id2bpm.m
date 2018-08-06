function [BPM, X1orb, X2orb, X3orb, X4orb]= id2bpm(Dim, Sector, IDorb, CMangle)
% function [BPM, X1orb, X2orb, X3orb, X4orb]= id2bpm(Dim, Sector, IDorb, CMangle)
%
%  Converts ID Position/Angle to BPM Position (BPM(S-1,8), BPM(S,1)) or (IDBPM(S-1,8), IDBPM(S,1))
%
%  Inputs: 1.  Dim = 1-Horizontal,  2-Vertical, 'x'-Horizontal,  'y'-Vertical, 'h'-Horizontal, or 'v'-Vertical
%
%          2.  Sector  = Sector number [1-12]
%
%                        | ID position [mm]   |
%          3.  IDorbit = |                    |     (column vector)
%                        | ID angle [mrad]    |
%
%                        | beam angle at CM(S-1,8) [mrad] |   Corrector magnet angle
%          4.  CMangle = |                                |   (default: computed from actual setpoint)
%                        | beam angle at CM(S,1)   [mrad] |   (column vector)
%
%  Output:
%                    | BPM(S-1,8) [mm] |    BPM position 
%          1.  BPM = |                 |    (default: getbpm)
%                    | BPM(S  ,1) [mm] |    (column vector)


if nargin < 3
  error('At least three inputs required.');
end

global  SectorLength BPMs VCMs
BPMlist = getlist('BPMx');
Xoffset = getoffset('BPMx')
Yoffset = getoffset('BPMy')
IDBPMlist = getlist('IDBPMx');
IDXoffset = getoffset('IDBPMx')
IDYoffset = getoffset('IDBPMy')



% Units: transverse  = mm
%        S-direction = meters
%        Angles      = milliradians


if isstr(Dim)
  if strcmp(upper(Dim),'X')
    Dim = 1;
  elseif strcmp(upper(Dim),'Y')
    Dim = 2;
  elseif strcmp(upper(Dim),'H')
    Dim = 1;
  elseif strcmp(upper(Dim),'V')
    Dim = 2;
  else
    error('Dim equals 1, 2, ''x'', ''y'', ''h'', or ''v''  only.');
  end
end

if Dim == 1
  CMstr = 'HCM';
  Offset = Xoffset;
  IDOffset = IDXoffset;
elseif Dim == 2
  CMstr = 'VCM';
  Offset = Yoffset;
  IDOffset = IDYoffset;
else
  error('Dim equals 1, 2, ''x'', ''y'', ''h'', or ''v''  only.');
end


if nargin == 3
  if Sector == 1
    CMangle = [0;0];    
  else
    CM = getam(CMstr, [Sector-1 8; Sector 1]);
    CMangle = 1000*amps2rad(CMstr, CM, [Sector-1 8; Sector 1]);
  end
elseif nargin > 4
  error('Maximum of 4 inputs.');
end


if Sector==1
  Sector_1 = 12;

  % BPM(Sector-1,8) to CM(Sector-1,8) (not used)
  l1 = .460;                                           % meters

  % IDcenter to CM(Sector-1,8) (not used)
  l2 = 2.83;                                           % meters

else
  Sector_1 = Sector-1;

  % BPM(Sector-1,8) to CM(Sector-1,8)
  l1 = .460;                                           % meters
  l1 = VCMs((Sector_1)*6-1)-BPMs((Sector_1)*8);        % meters

  % IDcenter to CM(Sector-1,8)
  l2 = 2.83;                                           % meters
  l2 = (Sector_1)*SectorLength-VCMs((Sector_1)*6-1);   % meters
end


if (abs(CMangle(1))>3.4 | abs(CMangle(2))>3.4)
	disp('  WARNING:  Corrector magnet angles are greater than 3.4 milliradians.')
end


M1 = [ 1   l1;
       0   1];

M2 = [ 1   l2;
       0   1];


X2orb = inv(M2)*IDorb;
X1orb = inv(M1)*(X2orb-[0; CMangle(1)]);


X3orb = M2*IDorb+[0; CMangle(2)];
X4orb = M1*X3orb;


BPM = [X1orb(1); X4orb(1)];


