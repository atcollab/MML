function measamlinearity(Family)
%
%
% See also plotamlinearity


ArchiveFlag = 1;

if nargin < 1
    Family = 'HCM';  % 'HCM' 'VCM' 'BEND' 'Q'
end

%Tol = getfamilydata(Family,'Setpoint','Tolerance');
%setfamilydata(4*Tol, Family,'Setpoint','Tolerance');

T       = 15;
N       = 21;
SP      = [];
Name    = family2channel(Family);
DevList = family2dev(Family);

if any(strcmpi(Family, {'HCM', 'VCM'}))
    Max = maxsp(Family) - .1*maxsp(Family);
    Min = minsp(Family) - .1*minsp(Family);
else
    Max = maxsp(Family) - .1*maxsp(Family);
    Min = minsp(Family);
end

%Max = maxsp(Family);
%Min = minsp(Family);

SP0     = getpv(Family, 'Setpoint', 'Struct');
AM0     = getpv(Family, 'Monitor',  'Struct');

ESLO_SP = getpv(family2channel(Family, 'Setpoint'), 'ESLO');
ESLO_AM = getpv(family2channel(Family, 'Monitor'),  'ESLO');

EOFF_SP = getpv(family2channel(Family, 'Setpoint'), 'EOFF');
EOFF_AM = getpv(family2channel(Family, 'Monitor'),  'EOFF');


% HCM & VCM families
if any(strcmpi(Family, {'HCM','VCM'}))
    setpv(Family, 'Trim', 0);
    setpv(Family, 'FF1',  0);
    setpv(Family, 'FF2',  0);
elseif any(strcmpi(Family, {'QF','QD'}))
    setpv(Family, 'FF',  0);
end


Delta = (Max-Min) / (N-1);
setsp(Family, Min, [], 0);
pause(1.5*T);

i = 1;
SP(:,i) = getsp(Family);
AM(:,i) = getam(Family);
N
for i = 2:N
    i
    stepsp(Family, Delta, [], 0);
    pause(T);

    SP(:,i) = getsp(Family);
    AM(:,i) = getam(Family);
end
setpv(SP0, 0);

clear i 


if ArchiveFlag
    DirStart = pwd;
    
    FileName = appendtimestamp(['SR_', Family,'_Linearity']);
    DirectoryName = [getfamilydata('Directory','DataRoot'), 'Magnets', filesep, 'Meas_Linearity', filesep];
    %FileName = [DirectoryName, FileName];

    [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
    save(FileName);
    
    cd(DirStart);
end


pause(0);
plotamlinearity([DirectoryName, FileName]);




