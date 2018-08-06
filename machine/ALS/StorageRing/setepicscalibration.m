function setepicscalibration(Family, Field, DeviceList, DisplayFlag)


if nargin < 1
    Family = 'QF';
end

if nargin < 2
    Field = 'Monitor';
end

if nargin < 3
    DeviceList = [1 1];
end

if nargin < 4
    DisplayFlag = 'Display';
end


ChannelName = family2channel(Family, Field, DeviceList);

VAL  = getpv(ChannelName, 'VAL');
RVAL = getpv(ChannelName, 'RVAL');
ASLO = getpv(ChannelName, 'ASLO');
AOFF = getpv(ChannelName, 'AOFF');
LINR = getpv(ChannelName, 'LINR');
ESLO = getpv(ChannelName, 'ESLO');
EOFF = getpv(ChannelName, 'EOFF');

EGUL = getpv(ChannelName, 'EGUL');
EGUF = getpv(ChannelName, 'EGUF');

fprintf('   %s\n', ChannelName);
fprintf('   VAL  = %f\n', VAL);
fprintf('   RVAL = %f\n', RVAL);
fprintf('   ASLO = %f\n', ASLO);
fprintf('   AOFF = %f\n', AOFF);
fprintf('   LINR = %d\n', LINR);
fprintf('   ESLO = %f\n', ESLO);
fprintf('   EOFF = %f\n', EOFF);
fprintf('   EGUL = %f\n', EGUL);
fprintf('   EGUF = %f\n', EGUF);

if strcmpi(Field, 'Monitor')
    SMOO = getpv(ChannelName, 'SMOO');
    fprintf('   SMOO = %d\n', SMOO);
end
fprintf('\n');


VAL = RVAL;
fprintf('   VAL1 = RVAL = %f\n', VAL);

VAL = VAL * ASLO + AOFF;
fprintf('   VAL2 = VAL1 * ASLO + AOFF = %f\n', VAL);

if LINR 
%VAL = VAL * ESLO + EOFF;
VAL = VAL * ESLO + EGUL;  % Seems like it should be EOFF
fprintf('   VAL3 = VAL2 * ESLO + EGUL = %f\n', VAL);
end

%VAL = VAL * (EGUF - EGUL) + EGUL;
%fprintf('   VAL4 = VAL3 * (EGUF - EGUL) + EGUL = %f\n', VAL);



