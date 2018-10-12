afamily = [
    0.95
    0.9
    0.85
    0.8
    0.75
    0.7
    0.6
    0.5
    0.45
    0.4
    0.35
    0.3
    0.25
    0.2
    0.15
    0.10
    0];
bfamily = [
    0.95
    0.9
    0.85
    0.8
    0.75
    0.7
    0.65
    0.6
    0.55
    0.5
    0.45
    0.4
    0.35
    0.3
    0.25
    0.2
    0.0];

sfa_init = getsp('SFA');
sda_init = getsp('SDA');
sfb_init = getsp('SFB');
sdb_init = getsp('SDB');

for i=1:length(afamily)
    % The [] means all devices in that family and -1 means that it will
    % also monitor the readback and only return when the readback reaches
    % the setpoint.
    setsp('SFA',sfa_init*afamily,[],-1);
    setsp('SDA',sda_init*afamily,[],-1);
    setsp('SFB',sfb_init*bfamily,[],-1);
    setsp('SDB',sdb_init*bfamily,[],-1);
end