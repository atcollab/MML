function [BPM, CM, Flags, EVectors] = setorbitsetup(varargin)
%SETORBITSETUP - BPM & CM setup function for setorbitgui
%  [BPM, CM, Flags, EVectors] = setorbitsetup
%
%  See also setorbit, setorbitgui, setorbitdefault  

%  Written by Greg Portmann



[HBPMTOTF, VBPMTOTF, HCMTOTF, VCMTOTF, HSVTOTF, VSVTOTF] = ocsinit('TopOfFill');
TOTFString = 'Top-Of-The-Fill';

[HBPMSOFB, VBPMSOFB, HCMSOFB, VCMSOFB, HSVSOFB, VSVSOFB] = ocsinit('SOFB');
SOFBString = 'Slow Orbit Feedback';

[HBPMFOFB, VBPMFOFB, HCMFOFB, VCMFOFB, HSVFOFB, VSVFOFB] = ocsinit('FOFB');
FOFBString = 'Fast Orbit Feedback';

[HBPMINJ, VBPMINJ, HCMINJ, VCMINJ, HSVINJ, VSVINJ] = ocsinit('Injection');
INJString = 'Injection BPMs';

[HBPMINJB, VBPMINJB, HCMINJB, VCMINJB, HSVINJB, VSVINJB] = ocsinit('Injection_TopOfFill');
INJBString = 'Injection BPMs (Bergoz Only)';

[HBPMOFFSET, VBPMOFFSET, HCMOFFSET, VCMOFFSET, HSVOFFSET, VSVOFFSET] = ocsinit('Measured Offsets');
OFFSETString = 'Measured Offsets';


BPM.BPMxString = {
    'All BPMs';
    'All Bergoz BPMs';
    TOTFString;
    SOFBString;
    FOFBString;
    INJString;
    INJBString;
    OFFSETString;
    '[1  3  4  5  6  7  8  10] with [1 2],[2 9],[3 2],[12 9]';
    '[2  3  4  5  6  7  8  9]';
    '[1  2  3  4  5  6  7  8  9 10]';
    '[2  3  4  5  6  7  8  9] QF QD QFA BEND';
    '[2  3  4y  5BSC  6BSC  7y  8  9]  QF QD QFAy SBEND';
    '[2  3  8  9] QF and QD correction';
    };

BPM.BPMyString = BPM.BPMxString;


BPMxList = getbpmlist('1 3 4 5 6 7 8 10');
BPMxList = [BPMxList; 1 2;2 9;3 2;12 9];
DeviceListAll = family2dev('BPMx',0);
IndexDeviceList = findrowindex(BPMxList, DeviceListAll);
IndexDeviceList = sort(IndexDeviceList);
BPMList2 = DeviceListAll(IndexDeviceList, 1:2);


BPM.BPMx = {
    family2datastruct('BPMx', getbpmlist('All'));
    family2datastruct('BPMx', getbpmlist('Bergoz'));
    HBPMTOTF;
    HBPMSOFB;
    HBPMFOFB;
    HBPMINJ;
    HBPMINJB;
    HBPMOFFSET;
    family2datastruct('BPMx', BPMList2);
    family2datastruct('BPMx', getbpmlist('2 3 4 5 6 7 8 9'));
    family2datastruct('BPMx', getbpmlist('1 2 3 4 5 6 7 8 9 10'));
    family2datastruct('BPMx', getbpmlist('2 3 4 5 6 7 8 9'));
    family2datastruct('BPMx', getbpmlist('2 3 5BSC 6BSC 8 9'));
    family2datastruct('BPMx', getbpmlist('2 3 8 9'));
    };

BPM.BPMy = {
    family2datastruct('BPMy', getbpmlist('All'));
    family2datastruct('BPMy', getbpmlist('Bergoz'));
    VBPMTOTF;
    VBPMSOFB;
    VBPMFOFB;
    VBPMINJ;
    VBPMINJB;
    VBPMOFFSET;
    family2datastruct('BPMy', BPMList2);
    family2datastruct('BPMy', getbpmlist('2 3 4 5 6 7 8 9'));
    family2datastruct('BPMy', getbpmlist('1 2 3 4 5 6 7 8 9 10'));
    family2datastruct('BPMy', getbpmlist('2 3 4 5 6 7 8 9'));
    family2datastruct('BPMy', getbpmlist('2 3 4 5BSC 6BSC 7 8 9'));
    family2datastruct('BPMy', getbpmlist('2 3 8 9'));
    };


CM.HCMString = {
    'All Corrector Magnets';
    TOTFString;
    SOFBString;
    FOFBString;
    '[1 2 3 4 5 6 7 8]';
    '[1  2  7  8]';
    '[3 4 5 6]';
    '[3 6]';
    '[4 5]';
    };

CM.HCM = {
    family2datastruct('HCM', 'Setpoint', getcmlist('Horizontal'));
    HCMTOTF;
    HCMSOFB;
    HCMFOFB;
    family2datastruct('HCM', 'Setpoint', getcmlist('Horizontal', '1 2 3 4 5 6 7 8'));
    family2datastruct('HCM', 'Setpoint', getcmlist('Horizontal', '1 2 7 8'));
    family2datastruct('HCM', 'Setpoint', getcmlist('Horizontal', '3 4 5 6'));
    family2datastruct('HCM', 'Setpoint', getcmlist('Horizontal', '3 6'));
    family2datastruct('HCM', 'Setpoint', getcmlist('Horizontal', '4 5'));
    };


CM.VCMString = {
    'All Corrector Magnets';
    TOTFString;
    SOFBString;
    FOFBString;
    '[1 2 4 5 7 8]';
    '[1  2  7  8]';
    '[4  5]';
    };

CM.VCM = {
    family2datastruct('VCM', 'Setpoint', getcmlist('Vertical'));
    VCMTOTF;
    VCMSOFB;
    VCMFOFB;
    family2datastruct('VCM', 'Setpoint', getcmlist('Vertical', '1 2 4 5 7 8'));
    family2datastruct('VCM', 'Setpoint', getcmlist('Vertical', '1 2 7 8'));
    family2datastruct('VCM', 'Setpoint', getcmlist('Vertical', '4 5'));
    };



EVectors.BPMx = zeros(length(BPM.BPMx),1);
EVectors.BPMy = zeros(length(BPM.BPMy),1);

EVectors.HCM = [
    47;
    HSVTOTF;
    HSVSOFB;
    HSVFOFB;
    48;
    24;
    24;
    11;
    12;
    ];

EVectors.VCM = [
    24;
    VSVTOTF;
    VSVSOFB;
    VSVFOFB;
    48;
    24;
    12;
    ];


% Defaults
for i = 1:length(BPM.BPMxString)
    Flags{i}.NIter = 3;
    Flags{i}.GoalOrbit = 'Golden';
    Flags{i}.PlaneFlag = 0;
end
Flags{3}.NIter = Inf;
Flags{4}.NIter = Inf;




% RemoveBPMDeviceList = [3 12; 5 4; 8 7; 9 7; 11 4;];  % used to remove [4 4; 7 9; 9 2;]
% RemoveHCMDeviceList = [];
% RemoveVCMDeviceList = []; 


