function AM = getquad(QMS)
% AM = getquad(QMS)


if nargin < 1
    QuadFamily = 'QF';
    QuadDev = [1 1];
else
    QuadFamily = QMS.QuadFamily;
    QuadDev = QMS.QuadDev;
end

Mode = getfamilydata(QuadFamily, 'Setpoint', 'Mode', QuadDev);
Machine = getfamilydata('Machine'); 

if strcmpi(Mode,'Simulator')
    AM = getam(QuadFamily, QuadDev);
    
elseif strcmpi(Machine,'SPEAR3') || strcmpi(Machine,'SPEAR')

    % 
    % TblRowMatch = find(QMSChannelSelect==cell2mat(FamilyDeviceChannelTbl(:,3)));
    % TblRowMatch = TblRowMatch(1);
    % Family = FamilyDeviceChannelTbl{TblRowMatch,1};
    % Device = FamilyDeviceChannelTbl{TblRowMatch,2};
    % 
    % if ~strcmpi(QuadFamily, Family)
    %     error('Required quad does not match the presenly selected quad (use setquad first).');
    % end
    % if any(QuadDev ~= Device)
    %     error('Required quad device does not match the presenly selected quad device (use setquad first).');
    % end
    if strcmpi(QuadFamily,'Q9S') && (QuadDev(2)==1) || (QuadDev(2)==3)   %quads in 9S straight
    AM = getam(QuadFamily, QuadDev);
    else
    AM = getpv('118-QMS1:CurrSetpt');
    end
    AM = AM(1);
    
else
    
    AM = getam(QuadFamily, QuadDev);

end