
%[HBPM, VBPM, HCM, VCM, HSV, VSV] = ocsinit('FOFB');


% Golden orbit in the cell controller
% The waveform record contains 64 LONG data values in units of nanometers.  
% The first array entry is the desired x position of the BPM whose least significant 
% five bits of fast orbit feedback index are equal to 0, the second array entry the 
% desired y position of the that BPM, the third array entry the desired x position of the 
% BPM whose least significant five bits of fast orbit feedback index are equal to 1, and so on.
%
% Golden BPM difference is applied in the cell controller
% BPMsetpoint: wavefrom x1,y1, x2,y2,   ... up to 32 BPMs (x,y pairs) per cell controller
% Note: 300 tap filter for the BPM data going to the cell controller is applied in the BPM.
%


% Fast Orbit Feedback List
% The waveform record (NAME="$(P)$(R)FOFBlist") specifies the BPMs whose values will be multicast 
% to the old cPCI-based fast orbit feedback system by this cell controller.  DTYP=asynInt32ArrayOut 
% and OUT="@asyn($(PORT) 1)", where $(PORT) expands to the port name in the bpmccConfigure command.  
% The waveform record contains up to 16 LONG values between 0 and 511.  The number of values contained 
% in the fast orbit feedback SECTOR packets multicast by this cell controller is equal to the number 
% of values written to this record.  The first value in this record specifies the fast orbit feedback 
% index of the BPM whose values will be placed in the first entry in the fast orbit feedback SECTOR 
% packet, the second value (if present) specifies the index of the BPM whose values will be sent second, 
% and so on.   Since all cell controllers contain position offset information from all BPMs there is no 
% restriction on which BPMs can be multicast by any particular cell controller.  To inhibit multicasts 
% from a cell controller set all 16 entries to values outside the range [0, 511].

% Zero all FOFB setpoint
    PV = [
        'SR01:CC:BPMsetpoints'
        'SR02:CC:BPMsetpoints'
        'SR03:CC:BPMsetpoints'
        'SR04:CC:BPMsetpoints'
        'SR05:CC:BPMsetpoints'
        'SR06:CC:BPMsetpoints'
        'SR07:CC:BPMsetpoints'
        'SR08:CC:BPMsetpoints'
        'SR09:CC:BPMsetpoints'
        'SR10:CC:BPMsetpoints'
        'SR11:CC:BPMsetpoints'
        'SR12:CC:BPMsetpoints'
        ];
    for i = 1:12
        a = getpvonline(PV(i,:));
        setpvonline(PV(i,:), 0*a);
    end

    % MML family BPM (fields XGoldenSetpoint & YGoldenSetpoint) is setup to hide the details.
% Changing this field will change the "Golden Setpoint" in the cell controller
Dev = family2dev('BPM');
setpv('BPM', 'XGoldenSetpoint', getgolden('BPMx',Dev), Dev);
setpv('BPM', 'YGoldenSetpoint', getgolden('BPMy',Dev), Dev);

if 1
    % The following puts all the new BPMs in that sector in the cell controller for that sector
    % (Make sure .NORD isn't larger than the number in index list)
    for i = 1:12
        FOFBIndex = getpv('BPM','FOFBIndex', getbpmlist(i, 'nonBergoz'));
        %fprintf('SR%02d:CC:FOFBlist\n', i);
        setpv(sprintf('SR%02d:CC:FOFBlist', i), FOFBIndex(:)');
    end
    
elseif 0
    % Since any cell controller can send any BPM to the cPCI, it's best to minimize the number of cell controllers used.
    % The following puts all 12 [s 3] BPMs in CC sector 1 and all [s 8] in CC sector 2
    % (Make sure .NORD isn't larger than the number in index list)
    FOFBIndex3 = getpv('BPM','FOFBIndex', getbpmlist('3', 'nonBergoz'));
    FOFBIndex8 = getpv('BPM','FOFBIndex', getbpmlist('8', 'nonBergoz'));
    setpv('SR01:CC:FOFBlist', FOFBIndex3(:)');
    setpv('SR02:CC:FOFBlist', FOFBIndex8(:)');
    
else
    fprintf('   No change to CC setup\n');
end



%







