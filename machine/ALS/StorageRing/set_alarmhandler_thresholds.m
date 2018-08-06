function set_alarmhandler_thresholds
% set_alarmhandler_thresholds
%
% This function changes some EPICS PV limit fields (.LOLO, .LOW, .HIGH, .HIHI)
% so that the alarm handler behaves properly (read: does not incessantly alarm!)
%
% 2006-03-24 created by T.Scarvie

% Chris Timossi incorporated most of these into his own limit setting script 4-18-06

% modified for new middle layer 

sr_mode_title=getfamilydata('OperationalMode');

if strcmp(sr_mode_title, '1.9 GeV, Two Bunch')

    try
        disp('   Setting IVID downstream bellows TC limits to HIGH = 42 C, HIHI = 43 C');
        scaput('SR06W___TCWAGO_AM01.HIGH', 42); scaput('SR06W___TCWAGO_AM01.HIHI', 43);
    catch
        disp('   Trouble Setting SR06W___TCWAGO_AM01 limits!');
    end

elseif strcmp(sr_mode_title, '1.9 GeV, High Tune') || strcmp(sr_mode_title, '1.9 GeV, Inject at 1.23')

    try
        disp('   Setting SR06W___TCWAGO_AM05 limits to HIGH = 40, HIHI = 41');
        scaput('SR06W___TCWAGO_AM05.HIGH', 40); scaput('SR06W___TCWAGO_AM05.HIHI', 41);
    catch
        disp('   Trouble Setting SR06W___TCWAGO_AM05 limits!');
    end

    try
        disp('   Setting SR01W___TCWAGO_AM05 limits to HIGH = 36, HIHI = 40');
        scaput('SR01W___TCWAGO_AM05.HIGH', 36); scaput('SR01W___TCWAGO_AM05.HIHI', 40);
    catch
        disp('   Trouble Setting SR01W___TCWAGO_AM05 limits!');
    end

    try
        disp('   Setting SR02W___TCWAGO_AM02 limits to HIGH = 37, HIHI = 40');
        scaput('SR02W___TCWAGO_AM02.HIGH', 37); scaput('SR02W___TCWAGO_AM02.HIHI', 40);
    catch
        disp('   Trouble Setting SR02W___TCWAGO_AM02 limits!');
    end

else
    error('  Storage Ring mode not known!');
end


% the following levels are independent of storage ring mode

% SR RF vacuum
try
    disp('   Setting SR03S IG3 limits to HIGH = 1.5e-8, (HIHI = 1e-7 already)');
    scaput('SR03S___IG3____AM05.HIGH', 1.5e-8);
catch
    disp('   Trouble Setting SR03S IG3 limits!');
end

% other SR vacuum
try
    disp('   Setting SR11C IG2 limit to HIGH = 1.5e-8, (HIHI = 1e-7 already)');
    scaput('SR11C___IG2____AM00.HIGH', 1.5e-8);
catch
    disp('   Trouble Setting SR11C IG2 limits!');
end

%AHU Temps
try
    disp('   Setting AHU Temperature limits to HIGH = 21 C, HIHI = 22 C (SR01&SR03 = 22/23 C)');
    scaput('SR01C___AHUT___AM00.HIGH', 22); scaput('SR01C___AHUT___AM00.HIHI', 23);
    scaput('SR03C___AHUT___AM00.HIGH', 22); scaput('SR03C___AHUT___AM00.HIHI', 23);
    scaput('SR04C___AHUT___AM00.HIGH', 21); scaput('SR04C___AHUT___AM00.HIHI', 22);
    scaput('SR06C___AHUT___AM00.HIGH', 21); scaput('SR06C___AHUT___AM00.HIHI', 22);
    scaput('SR07C___AHUT___AM00.HIGH', 21); scaput('SR07C___AHUT___AM00.HIHI', 22);
    scaput('SR08C___AHUT___AM00.HIGH', 21); scaput('SR08C___AHUT___AM00.HIHI', 22);
    scaput('SR09C___AHUT___AM00.HIGH', 21); scaput('SR09C___AHUT___AM00.HIHI', 22);
    scaput('SR11C___AHUT___AM00.HIGH', 21); scaput('SR11C___AHUT___AM00.HIHI', 22);
catch
    disp('   Trouble Setting AHU temp limits!');
end
