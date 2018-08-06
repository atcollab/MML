function clsinit(OperationalMode)
%CLSINIT - Initializes parameters for CLS control using the MML

if nargin < 1
    OperationalMode = 1;
end

%%%%%%%%%%%%%%%%
% Build the AO %
%%%%%%%%%%%%%%%%
setao([]);
setad([]);


ToleranceInCountsVCM = inf;  % 20000
ToleranceInCountsHCM = inf;
ToleranceInCountsQFA = 20000;
ToleranceInCountsQFB = 20000;
ToleranceInCountsQFC = 20000;
ToleranceInCountsSF = 200000;  % Due to DC offset when the off
ToleranceInCountsSD = 10000 * 5;
ToleranceInCountsBEND = 20000;
ToleranceInCountsBTS = inf;  % 100000

%create an enumerated list of family index's

%SR family index's
famindex = 1;
SR_BPMX_FAM = famindex;

famindex = famindex + 1;
SR_BPMY_FAM = famindex;

famindex = famindex + 1;
SR_HCM_FAM = famindex;

famindex = famindex + 1;
SR_VCM_FAM = famindex;

famindex = famindex + 1;
SR_BEND_FAM = famindex;

famindex = famindex + 1;
SR_QFA_FAM = famindex;

famindex = famindex + 1;
SR_QFB_FAM = famindex;

famindex = famindex + 1;
SR_QFC_FAM = famindex;

famindex = famindex + 1;
SR_SF_FAM = famindex;

famindex = famindex + 1;
SR_SD_FAM = famindex;

famindex = famindex + 1;
SR_RF_FAM = famindex;

famindex = famindex + 1;
SR_TUNE_FAM = famindex;

famindex = famindex + 1;
SR_DCCT_FAM = famindex;


%BTS family index's
famindex = famindex + 1;
BTS_QUAD_FAM = famindex;

famindex = famindex + 1;
BTS_STEER_FAM = famindex;

famindex = famindex + 1;
BTS_BEND_FAM = famindex;

famindex = famindex + 1;
BTS_SEPTUM_FAM = famindex;

famindex = famindex + 1;
BTS_KICK_FAM = famindex;

famindex = famindex + 1;
BTS_SCRAPERS_FAM = famindex;

famindex = famindex + 1;
SR_CHICANES_FAM = famindex;


%=============================================
%BPM data: status field designates if BPM in use
%=============================================
AO{SR_BPMX_FAM}.FamilyName               = 'BPMx';
AO{SR_BPMX_FAM}.FamilyType               = 'BPM';
AO{SR_BPMX_FAM}.MemberOf                 = {'BPM'; 'HBPM'; 'BPMx'; 'Diagnostics'};
AO{SR_BPMX_FAM}.Monitor.Mode             = 'SIMULATOR';
%AO{SR_BPMX_FAM}.Monitor.DataType         = 'Vector';
AO{SR_BPMX_FAM}.Monitor.DataType         = 'Scalar';
%AO{SR_BPMX_FAM}.Monitor.DataTypeIndex    = [1:48];
%AO{SR_BPMX_FAM}.Monitor.DataTypeIndex    = [1:40,42:49];
%AO{SR_BPMX_FAM}.Monitor.DataTypeIndex    = [1:8,10:13,15:18,20:23,24:27,29:32,34:37,39:42,44:47,49:52,53:56];
AO{SR_BPMX_FAM}.Monitor.Units            = 'Hardware';
AO{SR_BPMX_FAM}.Monitor.HWUnits          = 'm';
AO{SR_BPMX_FAM}.Monitor.PhysicsUnits     = 'm';

AO{SR_BPMY_FAM}.FamilyName               = 'BPMy';
AO{SR_BPMY_FAM}.MemberOf                 = {'BPM'; 'VBPM'; 'BPMy'; 'Diagnostics'};
AO{SR_BPMY_FAM}.FamilyType               = 'BPM';
AO{SR_BPMY_FAM}.Monitor.Mode             = 'SIMULATOR';
%AO{SR_BPMY_FAM}.Monitor.DataType         = 'Vector';
AO{SR_BPMY_FAM}.Monitor.DataType         = 'Scalar';
%AO{SR_BPMY_FAM}.Monitor.DataTypeIndex    = [49:96];
%AO{SR_BPMY_FAM}.Monitor.DataTypeIndex    = [50:89,91:98];
%AO{SR_BPMY_FAM}.Monitor.DataTypeIndex    = [57:64,66:69,71:74,76:83,85:88,90:93,95:98,100:103,105:112];
AO{SR_BPMY_FAM}.Monitor.Units            = 'Hardware';
AO{SR_BPMY_FAM}.Monitor.HWUnits          = 'm';
AO{SR_BPMY_FAM}.Monitor.PhysicsUnits     = 'm';

bpm={
 '1401-01:BPMx:val   '    'BPMx     '  1   '1401-01:BPMy:val   '    'BPMy     '  1  [1 ,1]  1      ; ...
 '1401-02:BPMx:val   '    'BPMx     '  1   '1401-02:BPMy:val   '    'BPMy     '  1  [1 ,2]  2      ; ...
 '1401-03:BPMx:val   '    'BPMx     '  1   '1401-03:BPMy:val   '    'BPMy     '  1  [1 ,3]  3      ; ...
 '1401-04:BPMx:val   '    'BPMx     '  1   '1401-04:BPMy:val   '    'BPMy     '  1  [1 ,4]  4      ; ...
                                                      
 '1402-07:BPMx:val   '    'BPMx     '  1   '1402-07:BPMy:val   '    'BPMy     '  1  [2 ,1]  5      ; ...
 '1402-08:BPMx:val   '    'BPMx     '  1   '1402-08:BPMy:val   '    'BPMy     '  1  [2 ,2]  6      ; ...
 '1402-09:BPMx:val   '    'BPMx     '  1   '1402-09:BPMy:val   '    'BPMy     '  1  [2 ,3]  7      ; ...
 '1402-10:BPMx:val   '    'BPMx     '  1   '1402-10:BPMy:val   '    'BPMy     '  1  [2 ,4]  8      ; ...
                                                      
 '1403-02:BPMx:val   '    'BPMx     '  1   '1403-02:BPMy:val   '    'BPMy     '  1  [3 ,1]  9      ; ...
 '1403-03:BPMx:val   '    'BPMx     '  1   '1403-03:BPMy:val   '    'BPMy     '  1  [3 ,2]  10     ; ...
 '1403-04:BPMx:val   '    'BPMx     '  1   '1403-04:BPMy:val   '    'BPMy     '  1  [3 ,3]  11     ; ...
 '1403-05:BPMx:val   '    'BPMx     '  1   '1403-05:BPMy:val   '    'BPMy     '  1  [3 ,4]  12     ; ...
                                                      
 '1404-02:BPMx:val   '    'BPMx     '  1   '1404-02:BPMy:val   '    'BPMy     '  1  [4 ,1]  13     ; ...
 '1404-03:BPMx:val   '    'BPMx     '  1   '1404-03:BPMy:val   '    'BPMy     '  1  [4 ,2]  14     ; ...
 '1404-04:BPMx:val   '    'BPMx     '  1   '1404-04:BPMy:val   '    'BPMy     '  1  [4 ,3]  15     ; ...
 '1404-05:BPMx:val   '    'BPMx     '  1   '1404-05:BPMy:val   '    'BPMy     '  1  [4 ,4]  16     ; ...
                                                      
 '1405-02:BPMx:val   '    'BPMx     '  1   '1405-02:BPMy:val   '    'BPMy     '  1  [5 ,1]  17     ; ...
 '1405-03:BPMx:val   '    'BPMx     '  1   '1405-03:BPMy:val   '    'BPMy     '  1  [5 ,2]  18     ; ...
 '1405-04:BPMx:val   '    'BPMx     '  1   '1405-04:BPMy:val   '    'BPMy     '  1  [5 ,3]  19     ; ...
 '1405-05:BPMx:val   '    'BPMx     '  1   '1405-05:BPMy:val   '    'BPMy     '  1  [5 ,4]  20     ; ...
                                                      
 '1406-02:BPMx:val   '    'BPMx     '  1   '1406-02:BPMy:val   '    'BPMy     '  1  [6 ,1]  21     ; ...
 '1406-03:BPMx:val   '    'BPMx     '  1   '1406-03:BPMy:val   '    'BPMy     '  1  [6 ,2]  22     ; ...
 '1406-04:BPMx:val   '    'BPMx     '  1   '1406-04:BPMy:val   '    'BPMy     '  1  [6 ,3]  23     ; ...
 '1406-05:BPMx:val   '    'BPMx     '  1   '1406-05:BPMy:val   '    'BPMy     '  1  [6 ,4]  24     ; ...
                                                      
 '1407-03:BPMx:val   '    'BPMx     '  1   '1407-03:BPMy:val   '    'BPMy     '  1  [7 ,1]  25     ; ...
 '1407-04:BPMx:val   '    'BPMx     '  1   '1407-04:BPMy:val   '    'BPMy     '  1  [7 ,2]  26     ; ...
 '1407-05:BPMx:val   '    'BPMx     '  1   '1407-05:BPMy:val   '    'BPMy     '  1  [7 ,3]  27     ; ...
 '1407-06:BPMx:val   '    'BPMx     '  1   '1407-06:BPMy:val   '    'BPMy     '  1  [7 ,4]  28     ; ...
                                                      
 '1408-02:BPMx:val   '    'BPMx     '  1   '1408-02:BPMy:val   '    'BPMy     '  1  [8 ,1]  29     ; ...
 '1408-03:BPMx:val   '    'BPMx     '  1   '1408-03:BPMy:val   '    'BPMy     '  1  [8 ,2]  30     ; ...
 '1408-04:BPMx:val   '    'BPMx     '  1   '1408-04:BPMy:val   '    'BPMy     '  1  [8 ,3]  31     ; ...
 '1408-05:BPMx:val   '    'BPMx     '  1   '1408-05:BPMy:val   '    'BPMy     '  1  [8 ,4]  32     ; ...
                                                      
 '1409-02:BPMx:val   '    'BPMx     '  1   '1409-02:BPMy:val   '    'BPMy     '  1  [9 ,1]  33     ; ...
 '1409-03:BPMx:val   '    'BPMx     '  1   '1409-03:BPMy:val   '    'BPMy     '  1  [9 ,2]  34     ; ...
 '1409-04:BPMx:val   '    'BPMx     '  1   '1409-04:BPMy:val   '    'BPMy     '  1  [9 ,3]  35     ; ...
 '1409-05:BPMx:val   '    'BPMx     '  1   '1409-05:BPMy:val   '    'BPMy     '  1  [9 ,4]  36     ; ...
                                                      
 '1410-02:BPMx:val   '    'BPMx     '  1   '1410-02:BPMy:val   '   'BPMy     '  1  [10,1]  37     ; ...
 '1410-03:BPMx:val   '    'BPMx     '  1   '1410-03:BPMy:val   '   'BPMy     '  1  [10,2]  38     ; ...
 '1410-04:BPMx:val   '    'BPMx     '  1   '1410-04:BPMy:val   '   'BPMy     '  1  [10,3]  39     ; ...
 '1410-05:BPMx:val   '    'BPMx     '  1   '1410-05:BPMy:val   '   'BPMy     '  1  [10,4]  40     ; ...
                                                      
 '1411-02:BPMx:val   '    'BPMx     '  1   '1411-02:BPMy:val   '   'BPMy     '  1  [11,1]  41     ; ...
 '1411-03:BPMx:val   '    'BPMx     '  1   '1411-03:BPMy:val   '   'BPMy     '  1  [11,2]  42     ; ...
 '1411-04:BPMx:val   '    'BPMx     '  1   '1411-04:BPMy:val   '   'BPMy     '  1  [11,3]  43     ; ...
 '1411-05:BPMx:val   '    'BPMx     '  1   '1411-05:BPMy:val   '   'BPMy     '  1  [11,4]  44     ; ...
                                                      
 '1412-02:BPMx:val   '    'BPMx     '  1   '1412-02:BPMy:val   '   'BPMy     '  1  [12,1]  45     ; ...
 '1412-03:BPMx:val   '    'BPMx     '  1   '1412-03:BPMy:val   '   'BPMy     '  1  [12,2]  46     ; ...
 '1412-04:BPMx:val   '    'BPMx     '  1   '1412-04:BPMy:val   '   'BPMy     '  1  [12,3]  47     ; ...
 '1412-05:BPMx:val   '    'BPMx     '  1   '1412-05:BPMy:val   '   'BPMy     '  1  [12,4]  48     ; ...
};
%x-name     x-chname    xstat y-name       y-chname   ystat  DevList Elem
% bpm={
%  '1BPM1   '    'BPMx     '  1  '1BPM1   '    'BPMy     '  1  [1 ,1]  1      ; ...
%  '1BPM2   '    'BPMx     '  1  '1BPM2   '    'BPMy     '  1  [1 ,2]  2      ; ...
%  '1BPM3   '    'BPMx     '  1  '1BPM3   '    'BPMy     '  1  [1 ,3]  3      ; ...
%  '1BPM4   '    'BPMx     '  1  '1BPM4   '    'BPMy     '  1  [1 ,4]  4      ; ...
%  '2BPM1   '    'BPMx     '  1  '2BPM1   '    'BPMy     '  1  [2 ,1]  5      ; ...
%  '2BPM2   '    'BPMx     '  1  '2BPM2   '    'BPMy     '  1  [2 ,2]  6      ; ...
%  '2BPM3   '    'BPMx     '  1  '2BPM3   '    'BPMy     '  1  [2 ,3]  7      ; ...
%  '2BPM4   '    'BPMx     '  1  '2BPM4   '    'BPMy     '  1  [2 ,4]  8      ; ...
%  '3BPM1   '    'BPMx     '  1  '3BPM1   '    'BPMy     '  1  [3 ,1]  9      ; ...
%  '3BPM2   '    'BPMx     '  1  '3BPM2   '    'BPMy     '  1  [3 ,2]  10     ; ...
%  '3BPM3   '    'BPMx     '  1  '3BPM3   '    'BPMy     '  1  [3 ,3]  11     ; ...
%  '3BPM4   '    'BPMx     '  1  '3BPM4   '    'BPMy     '  1  [3 ,4]  12     ; ...
%  '4BPM1   '    'BPMx     '  1  '4BPM1   '    'BPMy     '  1  [4 ,1]  13     ; ...
%  '4BPM2   '    'BPMx     '  1  '4BPM2   '    'BPMy     '  1  [4 ,2]  14     ; ...
%  '4BPM3   '    'BPMx     '  1  '4BPM3   '    'BPMy     '  1  [4 ,3]  15     ; ...
%  '4BPM4   '    'BPMx     '  1  '4BPM4   '    'BPMy     '  1  [4 ,4]  16     ; ...
%  '5BPM1   '    'BPMx     '  1  '5BPM1   '    'BPMy     '  1  [5 ,1]  17     ; ...
%  '5BPM2   '    'BPMx     '  1  '5BPM2   '    'BPMy     '  1  [5 ,2]  18     ; ...
%  '5BPM3   '    'BPMx     '  1  '5BPM3   '    'BPMy     '  1  [5 ,3]  19     ; ...
%  '5BPM4   '    'BPMx     '  1  '5BPM4   '    'BPMy     '  1  [5 ,4]  20     ; ...
%  
%  '6BPM1   '    'BPMx     '  1  '6BPM1   '    'BPMy     '  1  [6 ,1]  21     ; ...
%  '6BPM2   '    'BPMx     '  1  '6BPM2   '    'BPMy     '  1  [6 ,2]  22     ; ...
%  '6BPM3   '    'BPMx     '  1  '6BPM3   '    'BPMy     '  1  [6 ,3]  23     ; ...
%  '6BPM4   '    'BPMx     '  1  '6BPM4   '    'BPMy     '  1  [6 ,4]  24     ; ...
%  '7BPM1   '    'BPMx     '  1  '7BPM1   '    'BPMy     '  1  [7 ,1]  25     ; ...
%  '7BPM2   '    'BPMx     '  1  '7BPM2   '    'BPMy     '  1  [7 ,2]  26     ; ...
%  '7BPM3   '    'BPMx     '  1  '7BPM3   '    'BPMy     '  1  [7 ,3]  27     ; ...
%  '7BPM4   '    'BPMx     '  1  '7BPM4   '    'BPMy     '  1  [7 ,4]  28     ; ...
% 
%  '8BPM1   '    'BPMx     '  1  '8BPM1   '    'BPMy     '  1  [8 ,1]  29     ; ...
%  '8BPM2   '    'BPMx     '  1  '8BPM2   '    'BPMy     '  1  [8 ,2]  30     ; ...
%  '8BPM3   '    'BPMx     '  1  '8BPM3   '    'BPMy     '  1  [8 ,3]  31     ; ...
%  '8BPM4   '    'BPMx     '  1  '8BPM4   '    'BPMy     '  1  [8 ,4]  32     ; ...
%  '9BPM1   '    'BPMx     '  1  '9BPM1   '    'BPMy     '  1  [9 ,1]  33     ; ...
%  '9BPM2   '    'BPMx     '  1  '9BPM2   '    'BPMy     '  1  [9 ,2]  34     ; ...
%  '9BPM3   '    'BPMx     '  1  '9BPM3   '    'BPMy     '  1  [9 ,3]  35     ; ...
%  '9BPM4   '    'BPMx     '  1  '9BPM4   '    'BPMy     '  1  [9 ,4]  36     ; ...
%  '10BPM1  '    'BPMx     '  1  '10BPM1  '    'BPMy     '  1  [10,1]  37     ; ...
%  '10BPM2  '    'BPMx     '  1  '10BPM2  '    'BPMy     '  1  [10,2]  38     ; ...
%  '10BPM3  '    'BPMx     '  1  '10BPM3  '    'BPMy     '  1  [10,3]  39     ; ...
%  '10BPM4  '    'BPMx     '  1  '10BPM4  '    'BPMy     '  1  [10,4]  40     ; ...
%  '11BPM1  '    'BPMx     '  1  '11BPM1  '    'BPMy     '  1  [11,1]  41     ; ...
%  '11BPM2  '    'BPMx     '  1  '11BPM2  '    'BPMy     '  1  [11,2]  42     ; ...
%  '11BPM3  '    'BPMx     '  1  '11BPM3  '    'BPMy     '  1  [11,3]  43     ; ...
%  '11BPM4  '    'BPMx     '  1  '11BPM4  '    'BPMy     '  1  [11,4]  44     ; ...
% 
%  '12BPM1  '    'BPMx     '  1  '12BPM1  '    'BPMy     '  1  [12,1]  45     ; ...
%  '12BPM2  '    'BPMx     '  1  '12BPM2  '    'BPMy     '  1  [12,2]  46     ; ...
%  '12BPM3  '    'BPMx     '  1  '12BPM3  '    'BPMy     '  1  [12,3]  47     ; ...
%  '12BPM4  '    'BPMx     '  1  '12BPM4  '    'BPMy     '  1  [12,4]  48     ; ...
% };

%Load fields from data block
for ii=1:size(bpm,1)
    
    name=bpm{ii,1};      AO{SR_BPMX_FAM}.CommonNames(ii,:)         = name;
    %NEW
    AO{SR_BPMX_FAM}.Monitor.ChannelNames(ii,:) = name;
    AO{SR_BPMX_FAM}.Monitor.Handles(ii,:) = NaN;
  
    %end NEW

    name=bpm{ii,4};      AO{SR_BPMY_FAM}.CommonNames(ii,:)         = name;
    AO{SR_BPMY_FAM}.Monitor.Handles(ii,:) = NaN;
    %new
    AO{SR_BPMY_FAM}.Monitor.ChannelNames(ii,:) = name;
    %end new
    AO{SR_BPMX_FAM}.Status(ii,:) = bpm{ii,3};  
    AO{SR_BPMY_FAM}.Status(ii,:) = bpm{ii,6};  
    
    AO{SR_BPMX_FAM}.DeviceList(ii,:) = bpm{ii,7};   
    AO{SR_BPMY_FAM}.DeviceList(ii,:) = bpm{ii,7};  
    AO{SR_BPMX_FAM}.ElementList(ii,:) = bpm{ii,8};   
    AO{SR_BPMY_FAM}.ElementList(ii,:) = bpm{ii,8};   

    AO{SR_BPMX_FAM}.Monitor.HW2PhysicsParams(ii,:) = 1;
    AO{SR_BPMX_FAM}.Monitor.Physics2HWParams(ii,:) = 1;
    AO{SR_BPMY_FAM}.Monitor.HW2PhysicsParams(ii,:) = 1;
    AO{SR_BPMY_FAM}.Monitor.Physics2HWParams(ii,:) = 1;
end

%AO{SR_BPMX_FAM}.Monitor.ChannelNames = 'SrBPMs:ArrayData';
%AO{SR_BPMY_FAM}.Monitor.ChannelNames = 'SrBPMs:ArrayData';

% AO{SR_BPMX_FAM}.Monitor.Handles=NaN;
% AO{SR_BPMY_FAM}.Monitor.Handles=NaN;


% Gain, Golden, and Offset orbits
AO{SR_BPMX_FAM}.Gain   = ones(size(AO{SR_BPMX_FAM}.ElementList));
AO{SR_BPMY_FAM}.Gain   = ones(size(AO{SR_BPMY_FAM}.ElementList));
AO{SR_BPMX_FAM}.Offset = zeros(size(AO{SR_BPMX_FAM}.ElementList));
AO{SR_BPMY_FAM}.Offset = zeros(size(AO{SR_BPMY_FAM}.ElementList));
%JC May 25, 2006   load values in Golden Orbit file into AO field

try
    ad=getad;
    load([ad.Directory.OpsData ad.OpsData.BPMGoldenFile '.mat']);
    AO{SR_BPMX_FAM}.Golden=BPMxData.Data;
    AO{SR_BPMY_FAM}.Golden=BPMyData.Data;
catch
    AO{SR_BPMX_FAM}.Golden = zeros(size(AO{SR_BPMX_FAM}.ElementList));
    AO{SR_BPMY_FAM}.Golden = zeros(size(AO{SR_BPMY_FAM}.ElementList));
end


%===========================================================
%Corrector data: status field designates if corrector in use
%===========================================================

AO{SR_HCM_FAM}.FamilyName               = 'HCM';
AO{SR_HCM_FAM}.FamilyType               = 'COR';
AO{SR_HCM_FAM}.MemberOf                 = {'MachineConfig'; 'COR'; 'HCM'; 'Magnet'};

AO{SR_HCM_FAM}.Monitor.Mode             = 'SIMULATOR';
AO{SR_HCM_FAM}.Monitor.DataType         = 'Scalar';
AO{SR_HCM_FAM}.Monitor.Units            = 'Hardware';
AO{SR_HCM_FAM}.Monitor.HWUnits          = 'Counts';           
AO{SR_HCM_FAM}.Monitor.PhysicsUnits     = 'Radian';

AO{SR_HCM_FAM}.Setpoint.Mode            = 'SIMULATOR';
AO{SR_HCM_FAM}.Setpoint.DataType        = 'Scalar';
AO{SR_HCM_FAM}.Setpoint.Units           = 'Hardware';
AO{SR_HCM_FAM}.Setpoint.HWUnits         = 'Counts';           
AO{SR_HCM_FAM}.Setpoint.PhysicsUnits    = 'Radian';


AO{SR_VCM_FAM}.FamilyName               = 'VCM';
AO{SR_VCM_FAM}.FamilyType               = 'COR';
AO{SR_VCM_FAM}.MemberOf                 = {'MachineConfig'; 'COR'; 'MCOR'; 'VCM'; 'Magnet'};

AO{SR_VCM_FAM}.Monitor.Mode             = 'SIMULATOR';
AO{SR_VCM_FAM}.Monitor.DataType         = 'Scalar';
AO{SR_VCM_FAM}.Monitor.Units            = 'Hardware';
AO{SR_VCM_FAM}.Monitor.HWUnits          = 'Counts';           
AO{SR_VCM_FAM}.Monitor.PhysicsUnits     = 'Radian';

AO{SR_VCM_FAM}.Setpoint.Mode            = 'SIMULATOR';
AO{SR_VCM_FAM}.Setpoint.DataType        = 'Scalar';
AO{SR_VCM_FAM}.Setpoint.Units           = 'Hardware';
AO{SR_VCM_FAM}.Setpoint.HWUnits         = 'Counts';           
AO{SR_VCM_FAM}.Setpoint.PhysicsUnits    = 'Radian';

AO{SR_HCM_FAM}.DeviceList  = [];
AO{SR_VCM_FAM}.DeviceList  = [];
for i = 1:12
    % Horizontal
    AO{SR_HCM_FAM}.Monitor.ChannelNames (4*(i-1)+1,:) = sprintf('OCH14%02d-01:adc  ', i);
    AO{SR_HCM_FAM}.Setpoint.ChannelNames(4*(i-1)+1,:) = sprintf('OCH14%02d-01:dac  ', i);
    
    AO{SR_HCM_FAM}.Monitor.ChannelNames (4*(i-1)+2,:) = sprintf('SOA14%02d-01:X:adc', i);
    AO{SR_HCM_FAM}.Setpoint.ChannelNames(4*(i-1)+2,:) = sprintf('SOA14%02d-01:X:dac', i);
    
    AO{SR_HCM_FAM}.Monitor.ChannelNames (4*(i-1)+3,:) = sprintf('SOA14%02d-02:X:adc', i);
    AO{SR_HCM_FAM}.Setpoint.ChannelNames(4*(i-1)+3,:) = sprintf('SOA14%02d-02:X:dac', i);

    AO{SR_HCM_FAM}.Monitor.ChannelNames (4*(i-1)+4,:) = sprintf('OCH14%02d-02:adc  ', i);
    AO{SR_HCM_FAM}.Setpoint.ChannelNames(4*(i-1)+4,:) = sprintf('OCH14%02d-02:dac  ', i);
    
    AO{SR_HCM_FAM}.DeviceList  = [AO{SR_HCM_FAM}.DeviceList; [i 1;i 2;i 3;i 4]];

    % AO{SR_HCM_FAM}.Monitor.HW2PhysicsParams(4*(i-1)+1,:) = HCMGain1;
    % AO{SR_HCM_FAM}.Monitor.Physics2HWParams(4*(i-1)+1,:) = HCMGain1;
    % AO{SR_HCM_FAM}.Setpoint.HW2PhysicsParams(4*(i-1)+1,:) = HCMGain2;         
    % AO{SR_HCM_FAM}.Setpoint.Physics2HWParams(4*(i-1)+1,:) = HCMGain2; 
    % AO{SR_HCM_FAM}.Monitor.HW2PhysicsParams(4*(i-1)+2,:) = HCMGain1;
    % AO{SR_HCM_FAM}.Monitor.Physics2HWParams(4*(i-1)+2,:) = HCMGain1;
    % AO{SR_HCM_FAM}.Setpoint.HW2PhysicsParams(4*(i-1)+2,:) = HCMGain2;         
    % AO{SR_HCM_FAM}.Setpoint.Physics2HWParams(4*(i-1)+2,:) = HCMGain2; 
    % AO{SR_HCM_FAM}.Monitor.HW2PhysicsParams(4*(i-1)+3,:) = HCMGain1;
    % AO{SR_HCM_FAM}.Monitor.Physics2HWParams(4*(i-1)+3,:) = HCMGain1;
    % AO{SR_HCM_FAM}.Setpoint.HW2PhysicsParams(4*(i-1)+3,:) = HCMGain2;         
    % AO{SR_HCM_FAM}.Setpoint.Physics2HWParams(4*(i-1)+3,:) = HCMGain2; 
    % AO{SR_HCM_FAM}.Monitor.HW2PhysicsParams(4*(i-1)+4,:) = HCMGain1;
    % AO{SR_HCM_FAM}.Monitor.Physics2HWParams(4*(i-1)+4,:) = HCMGain1;
    % AO{SR_HCM_FAM}.Setpoint.HW2PhysicsParams(4*(i-1)+4,:) = HCMGain2;         
    % AO{SR_HCM_FAM}.Setpoint.Physics2HWParams(4*(i-1)+4,:) = HCMGain2; 

    AO{SR_HCM_FAM}.Setpoint.Range(4*(i-1)+1:4*(i-1)+4,1) = -7602176;
    AO{SR_HCM_FAM}.Setpoint.Range(4*(i-1)+1:4*(i-1)+4,2) =  7602176;
    AO{SR_HCM_FAM}.Setpoint.Tolerance(4*(i-1)+1:4*(i-1)+4,1) = ToleranceInCountsHCM;

    
    % Vertical
    AO{SR_VCM_FAM}.Monitor.ChannelNames (4*(i-1)+1,:) = sprintf('OCV14%02d-01:adc  ', i);
    AO{SR_VCM_FAM}.Setpoint.ChannelNames(4*(i-1)+1,:) = sprintf('OCV14%02d-01:dac  ', i);
    
    AO{SR_VCM_FAM}.Monitor.ChannelNames (4*(i-1)+2,:) = sprintf('SOA14%02d-01:Y:adc', i);
    AO{SR_VCM_FAM}.Setpoint.ChannelNames(4*(i-1)+2,:) = sprintf('SOA14%02d-01:Y:dac', i);
    
    AO{SR_VCM_FAM}.Monitor.ChannelNames (4*(i-1)+3,:) = sprintf('SOA14%02d-02:Y:adc', i);
    AO{SR_VCM_FAM}.Setpoint.ChannelNames(4*(i-1)+3,:) = sprintf('SOA14%02d-02:Y:dac', i);

    AO{SR_VCM_FAM}.Monitor.ChannelNames (4*(i-1)+4,:) = sprintf('OCV14%02d-02:adc  ', i);
    AO{SR_VCM_FAM}.Setpoint.ChannelNames(4*(i-1)+4,:) = sprintf('OCV14%02d-02:dac  ', i);
    
    AO{SR_VCM_FAM}.DeviceList  = [AO{SR_VCM_FAM}.DeviceList; [i 1;i 2;i 3;i 4]];
    
    % AO{SR_VCM_FAM}.Monitor.HW2PhysicsParams(4*(i-1)+1,:) = HCMGain1;
    % AO{SR_VCM_FAM}.Monitor.Physics2HWParams(4*(i-1)+1,:) = HCMGain1;
    % AO{SR_VCM_FAM}.Setpoint.HW2PhysicsParams(4*(i-1)+1,:) = HCMGain2;         
    % AO{SR_VCM_FAM}.Setpoint.Physics2HWParams(4*(i-1)+1,:) = HCMGain2; 
    % AO{SR_VCM_FAM}.Monitor.HW2PhysicsParams(4*(i-1)+2,:) = HCMGain1;
    % AO{SR_VCM_FAM}.Monitor.Physics2HWParams(4*(i-1)+2,:) = HCMGain1;
    % AO{SR_VCM_FAM}.Setpoint.HW2PhysicsParams(4*(i-1)+2,:) = HCMGain2;         
    % AO{SR_VCM_FAM}.Setpoint.Physics2HWParams(4*(i-1)+2,:) = HCMGain2; 
    % AO{SR_VCM_FAM}.Monitor.HW2PhysicsParams(4*(i-1)+3,:) = HCMGain1;
    % AO{SR_VCM_FAM}.Monitor.Physics2HWParams(4*(i-1)+3,:) = HCMGain1;
    % AO{SR_VCM_FAM}.Setpoint.HW2PhysicsParams(4*(i-1)+3,:) = HCMGain2;         
    % AO{SR_VCM_FAM}.Setpoint.Physics2HWParams(4*(i-1)+3,:) = HCMGain2; 
    % AO{SR_VCM_FAM}.Monitor.HW2PhysicsParams(4*(i-1)+4,:) = HCMGain1;
    % AO{SR_VCM_FAM}.Monitor.Physics2HWParams(4*(i-1)+4,:) = HCMGain1;
    % AO{SR_VCM_FAM}.Setpoint.HW2PhysicsParams(4*(i-1)+4,:) = HCMGain2;         
    % AO{SR_VCM_FAM}.Setpoint.Physics2HWParams(4*(i-1)+4,:) = HCMGain2; 
    

    AO{SR_VCM_FAM}.Setpoint.Range(4*(i-1)+1:4*(i-1)+4,1) = -7602176;
    AO{SR_VCM_FAM}.Setpoint.Range(4*(i-1)+1:4*(i-1)+4,2) =  7602176;
    AO{SR_VCM_FAM}.Setpoint.Tolerance(4*(i-1)+1:4*(i-1)+4,1) = ToleranceInCountsVCM;
end

AO{SR_HCM_FAM}.ElementList = (1:4*12)';
AO{SR_VCM_FAM}.ElementList = (1:4*12)';

AO{SR_HCM_FAM}.Monitor.Handles  = NaN * AO{SR_HCM_FAM}.ElementList;
AO{SR_HCM_FAM}.Setpoint.Handles = NaN * AO{SR_HCM_FAM}.ElementList;
AO{SR_HCM_FAM}.On.Handles = NaN * AO{SR_HCM_FAM}.ElementList;


AO{SR_VCM_FAM}.Monitor.Handles  = NaN * AO{SR_VCM_FAM}.ElementList;
AO{SR_VCM_FAM}.Setpoint.Handles = NaN * AO{SR_VCM_FAM}.ElementList;
AO{SR_VCM_FAM}.On.Handles = NaN * AO{SR_VCM_FAM}.ElementList;

AO{SR_HCM_FAM}.Status = ones(4*12,1);
AO{SR_VCM_FAM}.Status = ones(4*12,1);


% Hardware to physics conversions
% ----------- added 2003-11-15 mjb
% conversion for HCM and VCM
CM_Amps = 110;       % Amps read from power supply
CM_Counts = 4724448; % Counts read from control system computer
CM_Counts2Amps = CM_Amps / CM_Counts;
% conversion for sextupole correctors
SCM_Amps = 30.5;       % Amps read from power supply
SCM_Counts = 1327660; % Counts read from control system computer
SCM_Counts2Amps = SCM_Amps / SCM_Counts;
% ----------- 
% Counts2Amps = 1/438843;                %...dac/amp for corrector supplies  (42234.31111111)
HCM_Amp2Rad     = -1.40e-3/162;          %...radian/Amp
VCM_Amp2Rad     = -1.27e-3/165;          %...radian/Amp
HCMsext_Amp2Rad = -1.46e-3/111;          %...radian/Amp on sextupole cores
VCMsext_Amp2Rad = -1.70e-3/111;          %...radian/Amp on sextupole cores

HCMGain1 =  CM_Counts2Amps * HCM_Amp2Rad;      %...HCM radian/dac on corrector core
HCMGain2 = SCM_Counts2Amps * HCMsext_Amp2Rad;  %...HCM radian/dac on sextupole core
VCMGain1 =  CM_Counts2Amps * VCM_Amp2Rad;      %...VCM radian/dac on corrector core
VCMGain2 = SCM_Counts2Amps * HCMsext_Amp2Rad;  %...VCM on radian/dac on sextupole core


% % HW in amps, Physics in rad
% %x-common          x-monitor           x-setpoint   xstat y-common          y-monitor        y-setpoint      ystat devlist elem range tol   x-kick y-kick y-phot   H2P_X          P2H_X          H2P_Y        P2H_Y 
cor={
 '1CX1    '    'OCH1401-01:adc'    'OCH1401-01:dac'  1  '1CY1    '    'OCV1401-01:adc'   'OCV1401-01:dac'  1   [1 ,1]  1  [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain1 0]  [1/HCMGain1 0]  [VCMGain1 0]  [1/VCMGain1 0]; ...
 '1CX2    '    'OCH1401-02:adc'    'OCH1401-02:dac'  1  '1CY2    '    'OCV1401-02:adc'   'OCV1401-02:dac'  1   [1 ,2]  2  [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain2 0]  [1/HCMGain2 0]  [VCMGain2 0]  [1/VCMGain2 0]; ...
 '1CX3    '    'OCH1401-03:adc'    'OCH1401-03:dac'  1  '1CY3    '    'OCV1401-03:adc'   'OCV1401-03:dac'  1   [1 ,3]  3  [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain2 0]  [1/HCMGain2 0]  [VCMGain2 0]  [1/VCMGain2 0]; ...
 '1CX4    '    'OCH1401-04:adc'    'OCH1401-04:dac'  1  '1CY4    '    'OCV1401-04:adc'   'OCV1401-04:dac'  1   [1 ,4]  4  [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain1 0]  [1/HCMGain1 0]  [VCMGain1 0]  [1/VCMGain1 0]; ...
 '2CX1    '    'OCH1402-01:adc'    'OCH1402-01:dac'  1  '2CY1    '    'OCV1402-01:adc'   'OCV1402-01:dac'  1   [2 ,1]  5  [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain1 0]  [1/HCMGain1 0]  [VCMGain1 0]  [1/VCMGain1 0]; ...
 '2CX2    '    'OCH1402-02:adc'    'OCH1402-02:dac'  1  '2CY2    '    'OCV1402-02:adc'   'OCV1402-02:dac'  1   [2 ,2]  6  [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain2 0]  [1/HCMGain2 0]  [VCMGain2 0]  [1/VCMGain2 0]; ...
 '2CX3    '    'OCH1402-03:adc'    'OCH1402-03:dac'  1  '2CY3    '    'OCV1402-03:adc'   'OCV1402-03:dac'  1   [2 ,3]  7  [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain2 0]  [1/HCMGain2 0]  [VCMGain2 0]  [1/VCMGain2 0]; ...
 '2CX4    '    'OCH1402-04:adc'    'OCH1402-04:dac'  1  '2CY4    '    'OCV1402-04:adc'   'OCV1402-04:dac'  1   [2 ,4]  8  [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain1 0]  [1/HCMGain1 0]  [VCMGain1 0]  [1/VCMGain1 0]; ...
 '3CX1    '    'OCH1403-01:adc'    'OCH1403-01:dac'  1  '3CY1    '    'OCV1403-01:adc'   'OCV1403-01:dac'  1   [3 ,1]  9  [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain1 0]  [1/HCMGain1 0]  [VCMGain1 0]  [1/VCMGain1 0]; ...
 '3CX2    '    'OCH1403-02:adc'    'OCH1403-02:dac'  1  '3CY2    '    'OCV1403-02:adc'   'OCV1403-02:dac'  1   [3 ,2]  10 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain2 0]  [1/HCMGain2 0]  [VCMGain2 0]  [1/VCMGain2 0]; ...
 '3CX3    '    'OCH1403-03:adc'    'OCH1403-03:dac'  1  '3CY3    '    'OCV1403-03:adc'   'OCV1403-03:dac'  1   [3 ,3]  11 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain2 0]  [1/HCMGain2 0]  [VCMGain2 0]  [1/VCMGain2 0]; ...
 '3CX4    '    'OCH1403-04:adc'    'OCH1403-04:dac'  1  '3CY4    '    'OCV1403-04:adc'   'OCV1403-04:dac'  1   [3 ,4]  12 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain1 0]  [1/HCMGain1 0]  [VCMGain1 0]  [1/VCMGain1 0]; ...
 '4CX1    '    'OCH1404-01:adc'    'OCH1404-01:dac'  1  '4CY1    '    'OCV1404-01:adc'   'OCV1404-01:dac'  1   [4 ,1]  13 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain1 0]  [1/HCMGain1 0]  [VCMGain1 0]  [1/VCMGain1 0]; ...
 '4CX2    '    'OCH1404-02:adc'    'OCH1404-02:dac'  1  '4CY2    '    'OCV1404-02:adc'   'OCV1404-02:dac'  1   [4 ,2]  14 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain2 0]  [1/HCMGain2 0]  [VCMGain2 0]  [1/VCMGain2 0]; ...
 '4CX3    '    'OCH1404-03:adc'    'OCH1404-03:dac'  1  '4CY3    '    'OCV1404-03:adc'   'OCV1404-03:dac'  1   [4 ,3]  15 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain2 0]  [1/HCMGain2 0]  [VCMGain2 0]  [1/VCMGain2 0]; ...
 '4CX4    '    'OCH1404-04:adc'    'OCH1404-04:dac'  1  '4CY4    '    'OCV1404-04:adc'   'OCV1404-04:dac'  1   [4 ,4]  16 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain1 0]  [1/HCMGain1 0]  [VCMGain1 0]  [1/VCMGain1 0]; ...
 '5CX1    '    'OCH1405-01:adc'    'OCH1405-01:dac'  1  '5CY1    '    'OCV1405-01:adc'   'OCV1405-01:dac'  1   [5 ,1]  17 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain1 0]  [1/HCMGain1 0]  [VCMGain1 0]  [1/VCMGain1 0]; ...
 '5CX2    '    'OCH1405-02:adc'    'OCH1405-02:dac'  1  '5CY2    '    'OCV1405-02:adc'   'OCV1405-02:dac'  1   [5 ,2]  18 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain2 0]  [1/HCMGain2 0]  [VCMGain2 0]  [1/VCMGain2 0]; ...
 '5CX3    '    'OCH1405-03:adc'    'OCH1405-03:dac'  1  '5CY3    '    'OCV1405-03:adc'   'OCV1405-03:dac'  1   [5 ,3]  19 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain2 0]  [1/HCMGain2 0]  [VCMGain2 0]  [1/VCMGain2 0]; ...
 '5CX4    '    'OCH1405-04:adc'    'OCH1405-04:dac'  1  '5CY4    '    'OCV1405-04:adc'   'OCV1405-04:dac'  1   [5 ,4]  20 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain1 0]  [1/HCMGain1 0]  [VCMGain1 0]  [1/VCMGain1 0]; ...
 '6CX1    '    'OCH1406-01:adc'    'OCH1406-01:dac'  1  '6CY1    '    'OCV1406-01:adc'   'OCV1406-01:dac'  1   [6 ,1]  21 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain1 0]  [1/HCMGain1 0]  [VCMGain1 0]  [1/VCMGain1 0]; ...
 '6CX2    '    'OCH1406-02:adc'    'OCH1406-02:dac'  1  '6CY2    '    'OCV1406-02:adc'   'OCV1406-02:dac'  1   [6 ,2]  22 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain2 0]  [1/HCMGain2 0]  [VCMGain2 0]  [1/VCMGain2 0]; ...
 '6CX3    '    'OCH1406-03:adc'    'OCH1406-03:dac'  1  '6CY3    '    'OCV1406-03:adc'   'OCV1406-03:dac'  1   [6 ,3]  23 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain2 0]  [1/HCMGain2 0]  [VCMGain2 0]  [1/VCMGain2 0]; ...
 '6CX4    '    'OCH1406-04:adc'    'OCH1406-04:dac'  1  '6CY4    '    'OCV1406-04:adc'   'OCV1406-04:dac'  1   [6 ,4]  24 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain1 0]  [1/HCMGain1 0]  [VCMGain1 0]  [1/VCMGain1 0]; ...
 '7CX1    '    'OCH1407-01:adc'    'OCH1407-01:dac'  1  '7CY1    '    'OCV1407-01:adc'   'OCV1407-01:dac'  1   [7 ,1]  25 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain1 0]  [1/HCMGain1 0]  [VCMGain1 0]  [1/VCMGain1 0]; ...
 '7CX2    '    'OCH1407-02:adc'    'OCH1407-02:dac'  1  '7CY2    '    'OCV1407-02:adc'   'OCV1407-02:dac'  1   [7 ,2]  26 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain2 0]  [1/HCMGain2 0]  [VCMGain2 0]  [1/VCMGain2 0]; ...
 '7CX3    '    'OCH1407-03:adc'    'OCH1407-03:dac'  1  '7CY3    '    'OCV1407-03:adc'   'OCV1407-03:dac'  1   [7 ,3]  27 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain2 0]  [1/HCMGain2 0]  [VCMGain2 0]  [1/VCMGain2 0]; ...
 '7CX4    '    'OCH1407-04:adc'    'OCH1407-04:dac'  1  '7CY4    '    'OCV1407-04:adc'   'OCV1407-04:dac'  1   [7 ,4]  28 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain1 0]  [1/HCMGain1 0]  [VCMGain1 0]  [1/VCMGain1 0]; ...
 '8CX1    '    'OCH1408-01:adc'    'OCH1408-01:dac'  1  '8CY1    '    'OCV1408-01:adc'   'OCV1408-01:dac'  1   [8 ,1]  29 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain1 0]  [1/HCMGain1 0]  [VCMGain1 0]  [1/VCMGain1 0]; ...
 '8CX2    '    'OCH1408-02:adc'    'OCH1408-02:dac'  1  '8CY2    '    'OCV1408-02:adc'   'OCV1408-02:dac'  1   [8 ,2]  30 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain2 0]  [1/HCMGain2 0]  [VCMGain2 0]  [1/VCMGain2 0]; ...
 '8CX3    '    'OCH1408-03:adc'    'OCH1408-03:dac'  1  '8CY3    '    'OCV1408-03:adc'   'OCV1408-03:dac'  1   [8 ,3]  31 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain2 0]  [1/HCMGain2 0]  [VCMGain2 0]  [1/VCMGain2 0]; ...
 '8CX4    '    'OCH1408-04:adc'    'OCH1408-04:dac'  1  '8CY4    '    'OCV1408-04:adc'   'OCV1408-04:dac'  1   [8 ,4]  32 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain1 0]  [1/HCMGain1 0]  [VCMGain1 0]  [1/VCMGain1 0]; ...
 '9CX1    '    'OCH1409-01:adc'    'OCH1409-01:dac'  1  '9CY1    '    'OCV1409-01:adc'   'OCV1409-01:dac'  1   [9 ,1]  33 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain1 0]  [1/HCMGain1 0]  [VCMGain1 0]  [1/VCMGain1 0]; ...
 '9CX2    '    'OCH1409-02:adc'    'OCH1409-02:dac'  1  '9CY2    '    'OCV1409-02:adc'   'OCV1409-02:dac'  1   [9 ,2]  34 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain2 0]  [1/HCMGain2 0]  [VCMGain2 0]  [1/VCMGain2 0]; ...
 '9CX3    '    'OCH1409-03:adc'    'OCH1409-03:dac'  1  '9CY3    '    'OCV1409-03:adc'   'OCV1409-03:dac'  1   [9 ,3]  35 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain2 0]  [1/HCMGain2 0]  [VCMGain2 0]  [1/VCMGain2 0]; ...
 '9CX4    '    'OCH1409-04:adc'    'OCH1409-04:dac'  1  '9CY4    '    'OCV1409-04:adc'   'OCV1409-04:dac'  1   [9 ,4]  36 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain1 0]  [1/HCMGain1 0]  [VCMGain1 0]  [1/VCMGain1 0]; ...
 '10CX1   '    'OCH1410-01:adc'    'OCH1410-01:dac'  1  '10CY1   '    'OCV1410-01:adc'   'OCV1410-01:dac'  1   [10,1]  37 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain1 0]  [1/HCMGain1 0]  [VCMGain1 0]  [1/VCMGain1 0]; ...
 '10CX2   '    'OCH1410-02:adc'    'OCH1410-02:dac'  1  '10CY2   '    'OCV1410-02:adc'   'OCV1410-02:dac'  1   [10,2]  38 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain2 0]  [1/HCMGain2 0]  [VCMGain2 0]  [1/VCMGain2 0]; ...
 '10CX3   '    'OCH1410-03:adc'    'OCH1410-03:dac'  1  '10CY3   '    'OCV1410-03:adc'   'OCV1410-03:dac'  1   [10,3]  39 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain2 0]  [1/HCMGain2 0]  [VCMGain2 0]  [1/VCMGain2 0]; ...
 '10CX4   '    'OCH1410-04:adc'    'OCH1410-04:dac'  1  '10CY4   '    'OCV1410-04:adc'   'OCV1410-04:dac'  1   [10,4]  40 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain1 0]  [1/HCMGain1 0]  [VCMGain1 0]  [1/VCMGain1 0]; ...
 '11CX1   '    'OCH1411-01:adc'    'OCH1411-01:dac'  1  '11CY1   '    'OCV1411-01:adc'   'OCV1411-01:dac'  1   [11,1]  41 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain1 0]  [1/HCMGain1 0]  [VCMGain1 0]  [1/VCMGain1 0]; ...
 '11CX2   '    'OCH1411-02:adc'    'OCH1411-02:dac'  1  '11CY2   '    'OCV1411-02:adc'   'OCV1411-02:dac'  1   [11,2]  42 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain2 0]  [1/HCMGain2 0]  [VCMGain2 0]  [1/VCMGain2 0]; ...
 '11CX3   '    'OCH1411-03:adc'    'OCH1411-03:dac'  1  '11CY3   '    'OCV1411-03:adc'   'OCV1411-03:dac'  1   [11,3]  43 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain2 0]  [1/HCMGain2 0]  [VCMGain2 0]  [1/VCMGain2 0]; ...
 '11CX4   '    'OCH1411-04:adc'    'OCH1411-04:dac'  1  '11CY4   '    'OCV1411-04:adc'   'OCV1411-04:dac'  1   [11,4]  44 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain1 0]  [1/HCMGain1 0]  [VCMGain1 0]  [1/VCMGain1 0]; ...
 '12CX1   '    'OCH1412-01:adc'    'OCH1412-01:dac'  1  '12CY1   '    'OCV1412-01:adc'   'OCV1412-01:dac'  1   [12,1]  45 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain1 0]  [1/HCMGain1 0]  [VCMGain1 0]  [1/VCMGain1 0]; ...
 '12CX2   '    'OCH1401-02:adc'    'OCH1401-02:dac'  1  '12CY2   '    'OCV1412-02:adc'   'OCV1412-02:dac'  1   [12,2]  46 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain2 0]  [1/HCMGain2 0]  [VCMGain2 0]  [1/VCMGain2 0]; ...
 '12CX3   '    'OCH1401-03:adc'    'OCH1401-03:dac'  1  '12CY3   '    'OCV1412-03:adc'   'OCV1412-03:dac'  1   [12,3]  47 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain2 0]  [1/HCMGain2 0]  [VCMGain2 0]  [1/VCMGain2 0]; ...
 '12CX4   '    'OCH1401-04:adc'    'OCH1401-04:dac'  1  '12CY4   '    'OCV1412-04:adc'   'OCV1412-04:dac'  1   [12,4]  48 [-30.0 +30.0]  0.010  0.2    0.1    0.01  [HCMGain1 0]  [1/HCMGain1 0]  [VCMGain1 0]  [1/VCMGain1 0]; ...
};

% Load fields from datablock
for ii=1:size(cor,1)
    name=cor{ii,1};     AO{SR_HCM_FAM}.CommonNames(ii,:)       = name;            
    val =cor{ii,4};     AO{SR_HCM_FAM}.Status(ii,1)            = val;
    name=cor{ii,5};     AO{SR_VCM_FAM}.CommonNames(ii,:)       = name;            
    val =cor{ii,8};     AO{SR_VCM_FAM}.Status(ii,1)            = val;

    AO{SR_HCM_FAM}.Setpoint.HW2PhysicsParams(ii,1) = cor{ii,16}(1);
    AO{SR_HCM_FAM}.Setpoint.Physics2HWParams(ii,1) = 1 / cor{ii,16}(1);
    AO{SR_HCM_FAM}.Monitor.HW2PhysicsParams(ii,1)  = cor{ii,16}(1);
    AO{SR_HCM_FAM}.Monitor.Physics2HWParams(ii,1) = 1 / cor{ii,16}(1);

    AO{SR_VCM_FAM}.Setpoint.HW2PhysicsParams(ii,1) = cor{ii,18}(1);
    AO{SR_VCM_FAM}.Setpoint.Physics2HWParams(ii,1) = 1 / cor{ii,18}(1);
    AO{SR_VCM_FAM}.Monitor.HW2PhysicsParams(ii,1)  = cor{ii,18}(1);
    AO{SR_VCM_FAM}.Monitor.Physics2HWParams(ii,1) = 1 / cor{ii,18}(1);

    %val =cor{ii,15};    AO{SR_VCM_FAM}.Setpoint.PhotResp(ii,1) = val/1000;
end

% Response matrix kicks (in HWUnits)
setao(cell2field(AO));   %required to make physics2hw function
%KickInRadians = .025e-3;
KickInRadians = .015e-3;
AO{SR_HCM_FAM}.Setpoint.DeltaRespMat = physics2hw('HCM','Setpoint', KickInRadians);
AO{SR_VCM_FAM}.Setpoint.DeltaRespMat = physics2hw('VCM','Setpoint', KickInRadians);
AO{SR_VCM_FAM}.Setpoint.PhotResp     = physics2hw('VCM','Setpoint', KickInRadians);   %required to boot orbitgui


% Russ, to add a power supply on/off field for the HCM and VCM 
% you need to add all the channel names.  Then you can get and set with
% setpv('HCM','On', ???); 
% OnFlag = getpv('HCM','On'); 
%HCM on 
AO{SR_HCM_FAM}.On.Mode = 'Online';
AO{SR_HCM_FAM}.On.DataType         = 'Scalar';
AO{SR_HCM_FAM}.On.Units            = 'Hardware';
AO{SR_HCM_FAM}.On.HWUnits          = '';           
AO{SR_HCM_FAM}.On.PhysicsUnits     = '';
AO{SR_HCM_FAM}.On.HW2PhysicsParams = 1;
AO{SR_HCM_FAM}.On.Physics2HWParams = 1;


for i = 1:12
    % Horizontal
    AO{SR_HCM_FAM}.On.ChannelNames(4*(i-1)+1,:) = sprintf('OCH14%02d-01:on  ', i);
    AO{SR_HCM_FAM}.On.ChannelNames(4*(i-1)+2,:) = sprintf('OCH14%02d-02:on  ', i);
    AO{SR_HCM_FAM}.On.ChannelNames(4*(i-1)+3,:) = sprintf('SOA14%02d-01:X:on', i);
    AO{SR_HCM_FAM}.On.ChannelNames(4*(i-1)+4,:) = sprintf('SOA14%02d-02:X:on', i);
end    

%VCM on 
AO{SR_VCM_FAM}.On.Mode = 'Online';
AO{SR_VCM_FAM}.On.DataType         = 'Scalar';
AO{SR_VCM_FAM}.On.Units            = 'Hardware';
AO{SR_VCM_FAM}.On.HWUnits          = '';           
AO{SR_VCM_FAM}.On.PhysicsUnits     = '';
AO{SR_VCM_FAM}.On.HW2PhysicsParams = 1;
AO{SR_VCM_FAM}.On.Physics2HWParams = 1;


for i = 1:12
    % Vertical
    AO{SR_VCM_FAM}.On.ChannelNames(4*(i-1)+1,:) = sprintf('OCV14%02d-01:on  ', i);
    AO{SR_VCM_FAM}.On.ChannelNames(4*(i-1)+2,:) = sprintf('OCV14%02d-02:on  ', i);
    AO{SR_VCM_FAM}.On.ChannelNames(4*(i-1)+3,:) = sprintf('SOA14%02d-01:Y:on', i);
    AO{SR_VCM_FAM}.On.ChannelNames(4*(i-1)+4,:) = sprintf('SOA14%02d-02:Y:on', i);
end    


%===========
%Dipole data
%===========

AO{SR_BEND_FAM}.FamilyName               = 'BEND';
AO{SR_BEND_FAM}.FamilyType               = 'BEND';
AO{SR_BEND_FAM}.MemberOf                 = {'MachineConfig'; 'BEND'; 'Magnet'};

AO{SR_BEND_FAM}.Monitor.Mode             = 'SIMULATOR';
AO{SR_BEND_FAM}.Monitor.DataType         = 'Scalar';
AO{SR_BEND_FAM}.Monitor.Units            = 'Hardware';
AO{SR_BEND_FAM}.Monitor.HWUnits          = 'Counts';           
AO{SR_BEND_FAM}.Monitor.PhysicsUnits     = 'rad';

AO{SR_BEND_FAM}.Setpoint.Mode            = 'SIMULATOR';
AO{SR_BEND_FAM}.Setpoint.DataType        = 'Scalar';
AO{SR_BEND_FAM}.Setpoint.Units           = 'Hardware';
AO{SR_BEND_FAM}.Setpoint.HWUnits         = 'Counts';           
AO{SR_BEND_FAM}.Setpoint.PhysicsUnits    = 'rad';

%BEND on 
AO{SR_BEND_FAM}.On.Mode = 'Online';
AO{SR_BEND_FAM}.On.DataType         = 'Scalar';
AO{SR_BEND_FAM}.On.Units            = 'Hardware';
AO{SR_BEND_FAM}.On.HWUnits          = '';           
AO{SR_BEND_FAM}.On.PhysicsUnits     = '';
AO{SR_BEND_FAM}.On.HW2PhysicsParams = 1;
AO{SR_BEND_FAM}.On.Physics2HWParams = 1;


%common            monitor            setpoint     stat devlist elem   range    tol
bnd={
 '1BND1    '    'B1400-00:adc'    'B1400-00:dac'  1   [1 ,1]  1     [0, 500] 2.00  ; ...
 '1BND2    '    'B1400-00:adc'    'B1400-00:dac'  1   [1 ,2]  2     [0, 500] 2.00  ; ...
 '2BND1    '    'B1400-00:adc'    'B1400-00:dac'  1   [2 ,1]  3     [0, 500] 2.00  ; ...
 '2BND2    '    'B1400-00:adc'    'B1400-00:dac'  1   [2 ,2]  4     [0, 500] 2.00  ; ...
 '3BND1    '    'B1400-00:adc'    'B1400-00:dac'  1   [3 ,1]  5     [0, 500] 2.00  ; ...
 '3BND2    '    'B1400-00:adc'    'B1400-00:dac'  1   [3 ,2]  6     [0, 500] 2.00  ; ...
 '4BND1    '    'B1400-00:adc'    'B1400-00:dac'  1   [4 ,1]  7     [0, 500] 2.00  ; ...
 '4BND2    '    'B1400-00:adc'    'B1400-00:dac'  1   [4 ,2]  8     [0, 500] 2.00  ; ...
 '5BND1    '    'B1400-00:adc'    'B1400-00:dac'  1   [5 ,1]  9     [0, 500] 2.00  ; ...
 '5BND2    '    'B1400-00:adc'    'B1400-00:dac'  1   [5 ,2]  10    [0, 500] 2.00  ; ...
 '6BND1    '    'B1400-00:adc'    'B1400-00:dac'  1   [6 ,1]  11    [0, 500] 2.00  ; ...
 '6BND2    '    'B1400-00:adc'    'B1400-00:dac'  1   [6 ,2]  12    [0, 500] 2.00  ; ...
 '7BND1    '    'B1400-00:adc'    'B1400-00:dac'  1   [7 ,1]  13    [0, 500] 2.00  ; ...
 '7BND2    '    'B1400-00:adc'    'B1400-00:dac'  1   [7 ,2]  14    [0, 500] 2.00  ; ...
 '8BND1    '    'B1400-00:adc'    'B1400-00:dac'  1   [8 ,1]  15    [0, 500] 2.00  ; ...
 '8BND2    '    'B1400-00:adc'    'B1400-00:dac'  1   [8 ,2]  16    [0, 500] 2.00  ; ...
 '9BND2    '    'B1400-00:adc'    'B1400-00:dac'  1   [9 ,1]  17    [0, 500] 2.00  ; ...
 '9BND2    '    'B1400-00:adc'    'B1400-00:dac'  1   [9 ,2]  18    [0, 500] 2.00  ; ...
 '10BND1   '    'B1400-00:adc'    'B1400-00:dac'  1   [10,1]  19    [0, 500] 2.00  ; ...
 '10BND2   '    'B1400-00:adc'    'B1400-00:dac'  1   [10,2]  20    [0, 500] 2.00  ; ...
 '11BND1   '    'B1400-00:adc'    'B1400-00:dac'  1   [11,1]  21    [0, 500] 2.00  ; ...
 '11BND2   '    'B1400-00:adc'    'B1400-00:dac'  1   [11,2]  22    [0, 500] 2.00  ; ...
 '12BND1   '    'B1400-00:adc'    'B1400-00:dac'  1   [12,1]  23    [0, 500] 2.00  ; ...
 '12BND2   '    'B1400-00:adc'    'B1400-00:dac'  1   [12,2]  24    [0, 500] 2.00  ; ...
};

HW2Physics =  -0.3972 / 5112170.7522;

for ii=1:size(bnd,1)
name=bnd{ii,1};      AO{SR_BEND_FAM}.CommonNames(ii,:)           = name;            
name=bnd{ii,2};      AO{SR_BEND_FAM}.Monitor.ChannelNames(ii,:)  = name;
name=bnd{ii,3};      AO{SR_BEND_FAM}.Setpoint.ChannelNames(ii,:) = name;     
val =bnd{ii,4};      AO{SR_BEND_FAM}.Status(ii,1)                  = val;
val =bnd{ii,5};      AO{SR_BEND_FAM}.DeviceList(ii,:)            = val;
val =bnd{ii,6};      AO{SR_BEND_FAM}.ElementList(ii,1)           = val;
val =bnd{ii,7};      AO{SR_BEND_FAM}.Setpoint.Range(ii,:)        = [0 16777215];
val =bnd{ii,8};      AO{SR_BEND_FAM}.Setpoint.Tolerance(ii,1)    = ToleranceInCountsBEND;

AO{SR_BEND_FAM}.Monitor.HW2PhysicsParams(ii,:)  = HW2Physics;          
AO{SR_BEND_FAM}.Monitor.Physics2HWParams(ii,:)  = 1 / HW2Physics;

AO{SR_BEND_FAM}.Setpoint.HW2PhysicsParams(ii,:) = HW2Physics;           
AO{SR_BEND_FAM}.Setpoint.Physics2HWParams(ii,:) = 1 / HW2Physics;

AO{SR_BEND_FAM}.Monitor.Handles(ii,1)  = NaN;
AO{SR_BEND_FAM}.Setpoint.Handles(ii,1) = NaN;

AO{SR_BEND_FAM}.On.ChannelNames(ii,:) = sprintf('B1400-00:on');

AO{SR_BEND_FAM}.On.Handles(ii,1) = NaN;
end

%===============
%Quadrupole data
%===============

% *** QFA ***

AO{SR_QFA_FAM}.FamilyName               = 'QFA';
AO{SR_QFA_FAM}.FamilyType               = 'QUAD';
AO{SR_QFA_FAM}.MemberOf                 = {'MachineConfig'; 'QFA'; 'QUAD'; 'Magnet'; 'Tune Corrector'};

AO{SR_QFA_FAM}.Monitor.Mode             = 'SIMULATOR';
AO{SR_QFA_FAM}.Monitor.DataType         = 'Scalar';
AO{SR_QFA_FAM}.Monitor.Units            = 'Hardware';
AO{SR_QFA_FAM}.Monitor.HWUnits          = 'Counts';           
AO{SR_QFA_FAM}.Monitor.PhysicsUnits     = 'K';

AO{SR_QFA_FAM}.Setpoint.Mode            = 'SIMULATOR';
AO{SR_QFA_FAM}.Setpoint.DataType        = 'Scalar';
AO{SR_QFA_FAM}.Setpoint.Units           = 'Hardware';
AO{SR_QFA_FAM}.Setpoint.HWUnits         = 'Counts';           
AO{SR_QFA_FAM}.Setpoint.PhysicsUnits    = 'K';

%common              monitor             setpoint    stat devlist elem  ScaleFact   range   tol
QFA={
 '1QFA1    '    'QFA1401-01:adc'     'QFA1401-01:dac'  1   [1 ,1]  1     1.0       [0, 500] 2.00  ; ...
 '1QFA2    '    'QFA1401-02:adc'     'QFA1401-02:dac'  1   [1 ,2]  2     1.0       [0, 500] 2.00  ; ...
 '2QFA1    '    'QFA1402-01:adc'     'QFA1402-01:dac'  1   [2 ,1]  3     1.0       [0, 500] 2.00  ; ...
 '2QFA2    '    'QFA1402-02:adc'     'QFA1402-02:dac'  1   [2 ,2]  4     1.0       [0, 500] 2.00  ; ...
 '3QFA1    '    'QFA1403-01:adc'     'QFA1403-01:dac'  1   [3 ,1]  5     1.0       [0, 500] 2.00  ; ...
 '3QFA2    '    'QFA1403-02:adc'     'QFA1403-02:dac'  1   [3 ,2]  6     1.0       [0, 500] 2.00  ; ...
 '4QFA1    '    'QFA1404-01:adc'     'QFA1404-01:dac'  1   [4 ,1]  7     1.0       [0, 500] 2.00  ; ...
 '4QFA2    '    'QFA1404-02:adc'     'QFA1404-02:dac'  1   [4 ,2]  8     1.0       [0, 500] 2.00  ; ...
 '5QFA1    '    'QFA1405-01:adc'     'QFA1405-01:dac'  1   [5 ,1]  9     1.0       [0, 500] 2.00  ; ...
 '5QFA2    '    'QFA1405-02:adc'     'QFA1405-02:dac'  1   [5 ,2]  10    1.0       [0, 500] 2.00  ; ...
 '6QFA1    '    'QFA1406-01:adc'     'QFA1406-01:dac'  1   [6 ,1]  11    1.0       [0, 500] 2.00  ; ...
 '6QFA2    '    'QFA1406-02:adc'     'QFA1406-02:dac'  1   [6 ,2]  12    1.0       [0, 500] 2.00  ; ...
 '7QFA1    '    'QFA1407-01:adc'     'QFA1407-01:dac'  1   [7 ,1]  13    1.0       [0, 500] 2.00  ; ...
 '7QFA2    '    'QFA1407-02:adc'     'QFA1407-02:dac'  1   [7 ,2]  14    1.0       [0, 500] 2.00  ; ...
 '8QFA1    '    'QFA1408-01:adc'     'QFA1408-01:dac'  1   [8 ,1]  15    1.0       [0, 500] 2.00  ; ...
 '8QFA2    '    'QFA1408-02:adc'     'QFA1408-02:dac'  1   [8 ,2]  16    1.0       [0, 500] 2.00  ; ...
 '9QFA1    '    'QFA1409-01:adc'     'QFA1409-01:dac'  1   [9 ,1]  17    1.0       [0, 500] 2.00  ; ...
 '9QFA2    '    'QFA1409-02:adc'     'QFA1409-02:dac'  1   [9 ,2]  18    1.0       [0, 500] 2.00  ; ...
 '10QFA1   '    'QFA1410-01:adc'     'QFA1410-01:dac'  1   [10,1]  19    1.0       [0, 500] 2.00  ; ...
 '10QFA2   '    'QFA1410-02:adc'     'QFA1410-02:dac'  1   [10,2]  20    1.0       [0, 500] 2.00  ; ...
 '11QFA2   '    'QFA1411-01:adc'     'QFA1411-01:dac'  1   [11,1]  21    1.0       [0, 500] 2.00  ; ...
 '11QFA2   '    'QFA1411-02:adc'     'QFA1411-02:dac'  1   [11,2]  22    1.0       [0, 500] 2.00  ; ...
 '12QFA1   '    'QFA1412-01:adc'     'QFA1412-01:dac'  1   [12,1]  23    1.0       [0, 500] 2.00  ; ...
 '12QFA2   '    'QFA1412-02:adc'     'QFA1412-02:dac'  1   [12,2]  24    1.0       [0, 500] 2.00  ; ...
};

for ii=1:size(QFA,1)
name=QFA{ii,1};      AO{SR_QFA_FAM}.CommonNames(ii,:)           = name;            
name=QFA{ii,2};      AO{SR_QFA_FAM}.Monitor.ChannelNames(ii,:)  = name;
name=QFA{ii,3};      AO{SR_QFA_FAM}.Setpoint.ChannelNames(ii,:) = name;     
val =QFA{ii,4};      AO{SR_QFA_FAM}.Status(ii,1)                = val;
val =QFA{ii,5};      AO{SR_QFA_FAM}.DeviceList(ii,:)            = val;
val =QFA{ii,6};      AO{SR_QFA_FAM}.ElementList(ii,1)           = val;
val =QFA{ii,7};      AO{SR_QFA_FAM}.Monitor.HW2PhysicsParams(ii,:) =val;
                     AO{SR_QFA_FAM}.Setpoint.HW2PhysicsParams(ii,:)=val;
                     AO{SR_QFA_FAM}.Monitor.Physics2HWParams(ii,:) =val;
                     AO{SR_QFA_FAM}.Setpoint.Physics2HWParams(ii,:)=val;
val =QFA{ii,8};      AO{SR_QFA_FAM}.Setpoint.Range(ii,:)        = [0 8388607];
val =QFA{ii,9};      AO{SR_QFA_FAM}.Setpoint.Tolerance(ii,1)    = ToleranceInCountsQFA;

AO{SR_QFA_FAM}.Monitor.Handles(ii,1)    = NaN;
AO{SR_QFA_FAM}.Setpoint.Handles(ii,1)   = NaN;
AO{SR_QFA_FAM}.On.Handles(ii,1) = NaN;
end

%QFA on 
AO{SR_QFA_FAM}.On.Mode = 'Online';
AO{SR_QFA_FAM}.On.DataType         = 'Scalar';
AO{SR_QFA_FAM}.On.Units            = 'Hardware';
AO{SR_QFA_FAM}.On.HWUnits          = '';           
AO{SR_QFA_FAM}.On.PhysicsUnits     = '';
AO{SR_QFA_FAM}.On.HW2PhysicsParams = 1;
AO{SR_QFA_FAM}.On.Physics2HWParams = 1;


for i = 1:12
    % QFA'a
    AO{SR_QFA_FAM}.On.ChannelNames(2*(i-1)+1,:) = sprintf('QFA14%02d-01:on  ', i);
    AO{SR_QFA_FAM}.On.ChannelNames(2*(i-1)+2,:) = sprintf('QFA14%02d-02:on  ', i);
end    





% *** QFB ***

AO{SR_QFB_FAM}.FamilyName               = 'QFB';
AO{SR_QFB_FAM}.FamilyType               = 'QUAD';
AO{SR_QFB_FAM}.MemberOf                 = {'MachineConfig'; 'QFB'; 'QUAD'; 'Magnet'; 'Tune Corrector'};

AO{SR_QFB_FAM}.Monitor.Mode             = 'SIMULATOR';
AO{SR_QFB_FAM}.Monitor.DataType         = 'Scalar';
AO{SR_QFB_FAM}.Monitor.Units            = 'Hardware';
AO{SR_QFB_FAM}.Monitor.HWUnits          = 'Counts';           
AO{SR_QFB_FAM}.Monitor.PhysicsUnits     = 'K';

AO{SR_QFB_FAM}.Setpoint.Mode            = 'SIMULATOR';
AO{SR_QFB_FAM}.Setpoint.DataType        = 'Scalar';
AO{SR_QFB_FAM}.Setpoint.Units           = 'Hardware';
AO{SR_QFB_FAM}.Setpoint.HWUnits         = 'Counts';           
AO{SR_QFB_FAM}.Setpoint.PhysicsUnits    = 'K';


%common              monitor             setpoint    stat devlist elem  ScaleFact   range   tol
QFB={
 '1QFB1    '    'QFB1401-01:adc'     'QFB1401-01:dac'  1   [1 ,1]  1     1.0       [0, 500] 2.00  ; ...
 '1QFB2    '    'QFB1401-02:adc'     'QFB1401-02:dac'  1   [1 ,2]  2     1.0       [0, 500] 2.00  ; ...
 '2QFB1    '    'QFB1402-01:adc'     'QFB1402-01:dac'  1   [2 ,1]  3     1.0       [0, 500] 2.00  ; ...
 '2QFB2    '    'QFB1402-02:adc'     'QFB1402-02:dac'  1   [2 ,2]  4     1.0       [0, 500] 2.00  ; ...
 '3QFB1    '    'QFB1403-01:adc'     'QFB1403-01:dac'  1   [3 ,1]  5     1.0       [0, 500] 2.00  ; ...
 '3QFB2    '    'QFB1403-02:adc'     'QFB1403-02:dac'  1   [3 ,2]  6     1.0       [0, 500] 2.00  ; ...
 '4QFB1    '    'QFB1404-01:adc'     'QFB1404-01:dac'  1   [4 ,1]  7     1.0       [0, 500] 2.00  ; ...
 '4QFB2    '    'QFB1404-02:adc'     'QFB1404-02:dac'  1   [4 ,2]  8     1.0       [0, 500] 2.00  ; ...
 '5QFB1    '    'QFB1405-01:adc'     'QFB1405-01:dac'  1   [5 ,1]  9     1.0       [0, 500] 2.00  ; ...
 '5QFB2    '    'QFB1405-02:adc'     'QFB1405-02:dac'  1   [5 ,2]  10    1.0       [0, 500] 2.00  ; ...
 '6QFB1    '    'QFB1406-01:adc'     'QFB1406-01:dac'  1   [6 ,1]  11    1.0       [0, 500] 2.00  ; ...
 '6QFB2    '    'QFB1406-02:adc'     'QFB1406-02:dac'  1   [6 ,2]  12    1.0       [0, 500] 2.00  ; ...
 '7QFB1    '    'QFB1407-01:adc'     'QFB1407-01:dac'  1   [7 ,1]  13    1.0       [0, 500] 2.00  ; ...
 '7QFB2    '    'QFB1407-02:adc'     'QFB1407-02:dac'  1   [7 ,2]  14    1.0       [0, 500] 2.00  ; ...
 '8QFB1    '    'QFB1408-01:adc'     'QFB1408-01:dac'  1   [8 ,1]  15    1.0       [0, 500] 2.00  ; ...
 '8QFB2    '    'QFB1408-02:adc'     'QFB1408-02:dac'  1   [8 ,2]  16    1.0       [0, 500] 2.00  ; ...
 '9QFB1    '    'QFB1409-01:adc'     'QFB1409-01:dac'  1   [9 ,1]  17    1.0       [0, 500] 2.00  ; ...
 '9QFB2    '    'QFB1409-02:adc'     'QFB1409-02:dac'  1   [9 ,2]  18    1.0       [0, 500] 2.00  ; ...
 '10QFB1   '    'QFB1410-01:adc'     'QFB1410-01:dac'  1   [10,1]  19    1.0       [0, 500] 2.00  ; ...
 '10QFB2   '    'QFB1410-02:adc'     'QFB1410-02:dac'  1   [10,2]  20    1.0       [0, 500] 2.00  ; ...
 '11QFB2   '    'QFB1411-01:adc'     'QFB1411-01:dac'  1   [11,1]  21    1.0       [0, 500] 2.00  ; ...
 '11QFB2   '    'QFB1411-02:adc'     'QFB1411-02:dac'  1   [11,2]  22    1.0       [0, 500] 2.00  ; ...
 '12QFB1   '    'QFB1412-01:adc'     'QFB1412-01:dac'  1   [12,1]  23    1.0       [0, 500] 2.00  ; ...
 '12QFB2   '    'QFB1412-02:adc'     'QFB1412-02:dac'  1   [12,2]  24    1.0       [0, 500] 2.00  ; ...
};

for ii=1:size(QFB,1)
name=QFB{ii,1};      AO{SR_QFB_FAM}.CommonNames(ii,:)           = name;            
name=QFB{ii,2};      AO{SR_QFB_FAM}.Monitor.ChannelNames(ii,:)  = name;
name=QFB{ii,3};      AO{SR_QFB_FAM}.Setpoint.ChannelNames(ii,:) = name;     
val =QFB{ii,4};      AO{SR_QFB_FAM}.Status(ii,1)                = val;
val =QFB{ii,5};      AO{SR_QFB_FAM}.DeviceList(ii,:)            = val;
val =QFB{ii,6};      AO{SR_QFB_FAM}.ElementList(ii,1)           = val;
val =QFB{ii,7};      AO{SR_QFB_FAM}.Monitor.HW2PhysicsParams(ii,:) =val;
                     AO{SR_QFB_FAM}.Setpoint.HW2PhysicsParams(ii,:)=val;
                     AO{SR_QFB_FAM}.Monitor.Physics2HWParams(ii,:) =val;
                     AO{SR_QFB_FAM}.Setpoint.Physics2HWParams(ii,:)=val;
val =QFB{ii,8};      AO{SR_QFB_FAM}.Setpoint.Range(ii,:)        = [0 8388607];
val =QFB{ii,9};      AO{SR_QFB_FAM}.Setpoint.Tolerance(ii,1)    = ToleranceInCountsQFB;


AO{SR_QFB_FAM}.Monitor.Handles(ii,1)  = NaN;
AO{SR_QFB_FAM}.Setpoint.Handles(ii,1) = NaN;
AO{SR_QFB_FAM}.On.Handles(ii,1)       = NaN;
end

%QFB on 
AO{SR_QFB_FAM}.On.Mode             = 'Online';
AO{SR_QFB_FAM}.On.DataType         = 'Scalar';
AO{SR_QFB_FAM}.On.Units            = 'Hardware';
AO{SR_QFB_FAM}.On.HWUnits          = '';           
AO{SR_QFB_FAM}.On.PhysicsUnits     = '';
AO{SR_QFB_FAM}.On.HW2PhysicsParams = 1;
AO{SR_QFB_FAM}.On.Physics2HWParams = 1;


for i = 1:12
    % QFB'a
    AO{SR_QFB_FAM}.On.ChannelNames(2*(i-1)+1,:) = sprintf('QFB14%02d-01:on  ', i);
    AO{SR_QFB_FAM}.On.ChannelNames(2*(i-1)+2,:) = sprintf('QFB14%02d-02:on  ', i);
end    


% *** QFC ***
AO{SR_QFC_FAM}.FamilyName              = 'QFC';
AO{SR_QFC_FAM}.FamilyType              = 'QUAD';
AO{SR_QFC_FAM}.MemberOf                 = {'MachineConfig'; 'QFC'; 'QUAD'; 'Dispersion Corrector'; 'Magnet'};

AO{SR_QFC_FAM}.Monitor.Mode            = 'SIMULATOR';
AO{SR_QFC_FAM}.Monitor.DataType        = 'Scalar';
AO{SR_QFC_FAM}.Monitor.Units           = 'Hardware';
AO{SR_QFC_FAM}.Monitor.HWUnits         = 'Counts';           
AO{SR_QFC_FAM}.Monitor.PhysicsUnits    = 'K';

AO{SR_QFC_FAM}.Setpoint.Mode           = 'SIMULATOR';
AO{SR_QFC_FAM}.Setpoint.DataType       = 'Scalar';
AO{SR_QFC_FAM}.Setpoint.Units          = 'Hardware';
AO{SR_QFC_FAM}.Setpoint.HWUnits        = 'Counts';           
AO{SR_QFC_FAM}.Setpoint.PhysicsUnits   = 'K';
 
%common              monitor             setpoint    stat devlist elem  ScaleFact   range   tol
QFC={
 '1QFC1    '    'QFC1401-01:adc'    'QFC1401-01:dac'  1   [1 ,1]  1     1.0       [0, 500] 2.00  ; ...
 '1QFC2    '    'QFC1401-02:adc'    'QFC1401-02:dac'  1   [1 ,2]  2     1.0       [0, 500] 2.00  ; ...
 '2QFC1    '    'QFC1402-01:adc'    'QFC1402-01:dac'  1   [2 ,1]  3     1.0       [0, 500] 2.00  ; ...
 '2QFC2    '    'QFC1402-02:adc'    'QFC1402-02:dac'  1   [2 ,2]  4     1.0       [0, 500] 2.00  ; ...
 '3QFC1    '    'QFC1403-01:adc'    'QFC1403-01:dac'  1   [3 ,1]  5     1.0       [0, 500] 2.00  ; ...
 '3QFC2    '    'QFC1403-02:adc'    'QFC1403-02:dac'  1   [3 ,2]  6     1.0       [0, 500] 2.00  ; ...
 '4QFC1    '    'QFC1404-01:adc'    'QFC1404-01:dac'  1   [4 ,1]  7     1.0       [0, 500] 2.00  ; ...
 '4QFC2    '    'QFC1404-02:adc'    'QFC1404-02:dac'  1   [4 ,2]  8     1.0       [0, 500] 2.00  ; ...
 '5QFC1    '    'QFC1405-01:adc'    'QFC1405-01:dac'  1   [5 ,1]  9     1.0       [0, 500] 2.00  ; ...
 '5QFC2    '    'QFC1405-02:adc'    'QFC1405-02:dac'  1   [5 ,2]  10    1.0       [0, 500] 2.00  ; ...
 '6QFC1    '    'QFC1406-01:adc'    'QFC1406-01:dac'  1   [6 ,1]  11    1.0       [0, 500] 2.00  ; ...
 '6QFC2    '    'QFC1406-02:adc'    'QFC1406-02:dac'  1   [6 ,2]  12    1.0       [0, 500] 2.00  ; ...
 '7QFC1    '    'QFC1407-01:adc'    'QFC1407-01:dac'  1   [7 ,1]  13    1.0       [0, 500] 2.00  ; ...
 '7QFC2    '    'QFC1407-02:adc'    'QFC1407-02:dac'  1   [7 ,2]  14    1.0       [0, 500] 2.00  ; ...
 '8QFC1    '    'QFC1408-01:adc'    'QFC1408-01:dac'  1   [8 ,1]  15    1.0       [0, 500] 2.00  ; ...
 '8QFC2    '    'QFC1408-02:adc'    'QFC1408-02:dac'  1   [8 ,2]  16    1.0       [0, 500] 2.00  ; ...
 '9QFC1    '    'QFC1409-01:adc'    'QFC1409-01:dac'  1   [9 ,1]  17    1.0       [0, 500] 2.00  ; ...
 '9QFC2    '    'QFC1409-02:adc'    'QFC1409-02:dac'  1   [9 ,2]  18    1.0       [0, 500] 2.00  ; ...
 '10QFC1   '    'QFC1410-01:adc'    'QFC1410-01:dac'  1   [10,1]  19    1.0       [0, 500] 2.00  ; ...
 '10QFC2   '    'QFC1410-02:adc'    'QFC1410-02:dac'  1   [10,2]  20    1.0       [0, 500] 2.00  ; ...
 '11QFC1   '    'QFC1411-01:adc'    'QFC1411-01:dac'  1   [11,1]  21    1.0       [0, 500] 2.00  ; ...
 '11QFC2   '    'QFC1411-02:adc'    'QFC1411-02:dac'  1   [11,2]  22    1.0       [0, 500] 2.00  ; ...
 '12QFC1   '    'QFC1412-01:adc'    'QFC1412-01:dac'  1   [12,1]  23    1.0       [0, 500] 2.00  ; ...
 '12QFC2   '    'QFC1412-02:adc'    'QFC1412-02:dac'  1   [12,2]  24    1.0       [0, 500] 2.00  ; ...
};

for ii=1:size(QFC,1)
    name=QFC{ii,1};      AO{SR_QFC_FAM}.CommonNames(ii,:)           = name;            
    name=QFC{ii,2};      AO{SR_QFC_FAM}.Monitor.ChannelNames(ii,:)  = name;
    name=QFC{ii,3};      AO{SR_QFC_FAM}.Setpoint.ChannelNames(ii,:) = name;     
    val =QFC{ii,4};      AO{SR_QFC_FAM}.Status(ii,1)                  = val;
    val =QFC{ii,5};      AO{SR_QFC_FAM}.DeviceList(ii,:)            = val;
    val =QFC{ii,6};      AO{SR_QFC_FAM}.ElementList(ii,1)           = val;
    val =QFC{ii,7};      AO{SR_QFC_FAM}.Monitor.HW2PhysicsParams(ii,:) =val;
                         AO{SR_QFC_FAM}.Setpoint.HW2PhysicsParams(ii,:)=val;
                         AO{SR_QFC_FAM}.Monitor.Physics2HWParams(ii,:) =val;
                         AO{SR_QFC_FAM}.Setpoint.Physics2HWParams(ii,:)=val;
    val =QFC{ii,8};      AO{SR_QFC_FAM}.Setpoint.Range(ii,:)        = [0 4500000];
    val =QFC{ii,9};      AO{SR_QFC_FAM}.Setpoint.Tolerance(ii,1)    = ToleranceInCountsQFC;
    
    AO{SR_QFC_FAM}.Monitor.Handles(ii,1)    = NaN;
    AO{SR_QFC_FAM}.Setpoint.Handles(ii,1)   = NaN;
    AO{SR_QFC_FAM}.On.Handles(ii,1) = NaN;
end

%QFC on 
AO{SR_QFC_FAM}.On.Mode = 'Online';
AO{SR_QFC_FAM}.On.DataType         = 'Scalar';
AO{SR_QFC_FAM}.On.Units            = 'Hardware';
AO{SR_QFC_FAM}.On.HWUnits          = '';           
AO{SR_QFC_FAM}.On.PhysicsUnits     = '';
AO{SR_QFC_FAM}.On.HW2PhysicsParams = 1;
AO{SR_QFC_FAM}.On.Physics2HWParams = 1;


for i = 1:12
    % QFC'a
    AO{SR_QFC_FAM}.On.ChannelNames(2*(i-1)+1,:) = sprintf('QFC14%02d-01:on  ', i);
    AO{SR_QFC_FAM}.On.ChannelNames(2*(i-1)+2,:) = sprintf('QFC14%02d-02:on  ', i);
end    


%%-------------- START conversions update 2003-11-12
% Read the quad to K gains and amp channels names
%[QUADpv, QUADAmps] = textread('quadgains.txt','%s %f');
QFACell = {
'QFA1401-01:Amp'	65.587
'QFA1401-02:Amp'	65.658
'QFA1402-01:Amp'	65.750
'QFA1402-02:Amp'	65.575
'QFA1403-01:Amp'	65.606
'QFA1403-02:Amp'	65.687
'QFA1404-01:Amp'	65.631
'QFA1404-02:Amp'	65.631
'QFA1405-01:Amp'	65.801
'QFA1405-02:Amp'	65.670
'QFA1406-01:Amp'	65.518
'QFA1406-02:Amp'	65.585
'QFA1407-01:Amp'	65.656
'QFA1407-02:Amp'	65.358
'QFA1408-01:Amp'	65.384
'QFA1408-02:Amp'	65.635
'QFA1409-01:Amp'	65.601
'QFA1409-02:Amp'	65.763
'QFA1410-01:Amp'	65.613
'QFA1410-02:Amp'	65.591
'QFA1411-01:Amp'	65.530
'QFA1411-02:Amp'	65.520
'QFA1412-01:Amp'	65.626
'QFA1412-02:Amp'	65.625

};

QFBCell = {
'QFB1401-01:Amp'	73.93276115
'QFB1401-02:Amp'	73.84672824
'QFB1402-01:Amp'	73.81666955
'QFB1402-02:Amp'	73.81946452
'QFB1403-01:Amp'	73.72627543
'QFB1403-02:Amp'	73.84872212
'QFB1404-01:Amp'	74.08521829
'QFB1404-02:Amp'	73.77194144
'QFB1405-01:Amp'	73.49051974
'QFB1405-02:Amp'	73.78315443
'QFB1406-01:Amp'	73.76564882
'QFB1406-02:Amp'	73.77392508
'QFB1407-01:Amp'	73.71067948
'QFB1407-02:Amp'	73.47729802
'QFB1408-01:Amp'	73.60070004
'QFB1408-02:Amp'	73.94115187
'QFB1409-01:Amp'	73.87061913
'QFB1409-02:Amp'	73.8751987
'QFB1410-01:Amp'	73.83801422
'QFB1410-02:Amp'	73.9794849
'QFB1411-01:Amp'	73.64852176
'QFB1411-02:Amp'	73.65587534
'QFB1412-01:Amp'	73.54315578
'QFB1412-02:Amp'	73.7437212
};

QFCCell = {
'QFC1401-01:Amp'	79.65470685
'QFC1401-02:Amp'	79.54711543
'QFC1402-01:Amp'	79.41455477
'QFC1402-02:Amp'	79.49415261
'QFC1403-01:Amp'	79.61605303
'QFC1403-02:Amp'	79.51485404
'QFC1404-01:Amp'	79.66156636
'QFC1404-02:Amp'	79.66908698
'QFC1405-01:Amp'	79.49067034
'QFC1405-02:Amp'	79.26925702
'QFC1406-01:Amp'	79.54259395
'QFC1406-02:Amp'	79.52744215
'QFC1407-01:Amp'	79.24314769
'QFC1407-02:Amp'	79.51323176
'QFC1408-01:Amp'	79.46912082
'QFC1408-02:Amp'	79.51862341
'QFC1409-01:Amp'	79.52012192
'QFC1409-02:Amp'	79.53860153
'QFC1410-01:Amp'	79.68593522
'QFC1410-02:Amp'	79.53709015
'QFC1411-01:Amp'	79.28670153
'QFC1411-02:Amp'	79.57514209
'QFC1412-01:Amp'	79.62129547
'QFC1412-02:Amp'	79.3754109
};

QFA_Amp2K = 1.67899 ./ cell2mat(QFACell(:,2));
QFB_Amp2K = 1.88264 ./ cell2mat(QFBCell(:,2));
QFC_Amp2K = 2.03992 ./ cell2mat(QFCCell(:,2));

AO{SR_QFA_FAM}.Amps.HW2PhysicsParams = QFA_Amp2K;
AO{SR_QFA_FAM}.Amps.Physics2HWParams = 1 ./ AO{SR_QFA_FAM}.Amps.HW2PhysicsParams;

AO{SR_QFB_FAM}.Amps.HW2PhysicsParams = QFB_Amp2K;
AO{SR_QFB_FAM}.Amps.Physics2HWParams = 1 ./ AO{SR_QFB_FAM}.Amps.HW2PhysicsParams;

AO{SR_QFC_FAM}.Amps.HW2PhysicsParams = QFC_Amp2K;
AO{SR_QFC_FAM}.Amps.Physics2HWParams = 1 ./ AO{SR_QFC_FAM}.Amps.HW2PhysicsParams;

% DAC to Amps for the quads.  values obtained from Amp/DAC calibration
% obtained from Mark S.  2003-11-10
QFA_DAC2Amp = 1.1795e-5;
QFB_DAC2Amp = 1.1738e-5;
QFC_DAC2Amp = 2.3392e-5;

% QFB and QFC should have the same DAC/Amps and QFA is twice as large
AO{SR_QFA_FAM}.Monitor.HW2PhysicsParams = QFA_Amp2K .* QFA_DAC2Amp; 
AO{SR_QFA_FAM}.Monitor.Physics2HWParams = 1 ./ AO{SR_QFA_FAM}.Monitor.HW2PhysicsParams;
AO{SR_QFA_FAM}.Setpoint.HW2PhysicsParams = QFA_Amp2K * QFA_DAC2Amp;
AO{SR_QFA_FAM}.Setpoint.Physics2HWParams = 1 ./ AO{SR_QFA_FAM}.Setpoint.HW2PhysicsParams;

AO{SR_QFB_FAM}.Monitor.HW2PhysicsParams = QFB_Amp2K * QFB_DAC2Amp;
AO{SR_QFB_FAM}.Monitor.Physics2HWParams = 1 ./ AO{SR_QFB_FAM}.Monitor.HW2PhysicsParams;
AO{SR_QFB_FAM}.Setpoint.HW2PhysicsParams = QFB_Amp2K * QFB_DAC2Amp;
AO{SR_QFB_FAM}.Setpoint.Physics2HWParams = 1 ./ AO{SR_QFB_FAM}.Setpoint.HW2PhysicsParams;

AO{SR_QFC_FAM}.Monitor.HW2PhysicsParams = QFC_Amp2K * QFC_DAC2Amp;
AO{SR_QFC_FAM}.Monitor.Physics2HWParams = 1 ./ AO{SR_QFC_FAM}.Monitor.HW2PhysicsParams;
AO{SR_QFC_FAM}.Setpoint.HW2PhysicsParams = QFC_Amp2K * QFC_DAC2Amp;
AO{SR_QFC_FAM}.Setpoint.Physics2HWParams = 1 ./ AO{SR_QFC_FAM}.Setpoint.HW2PhysicsParams;
%%-------------- END conversions update 2003-11-12

AO{SR_QFA_FAM}.Amps.ChannelNames = cell2mat(QFACell(:,1));
AO{SR_QFB_FAM}.Amps.ChannelNames = cell2mat(QFBCell(:,1));
AO{SR_QFC_FAM}.Amps.ChannelNames = cell2mat(QFCCell(:,1));

AO{SR_QFA_FAM}.Amps.Handles = NaN * ones(24,1);
AO{SR_QFB_FAM}.Amps.Handles = NaN * ones(24,1);
AO{SR_QFC_FAM}.Amps.Handles = NaN * ones(24,1);

AO{SR_QFA_FAM}.Amps.Mode            = 'ONLINE';
AO{SR_QFA_FAM}.Amps.DataType        = 'Scalar';
AO{SR_QFA_FAM}.Amps.Units           = 'Hardware';
AO{SR_QFA_FAM}.Amps.HWUnits         = 'Amps';           
AO{SR_QFA_FAM}.Amps.PhysicsUnits    = 'K';

AO{SR_QFB_FAM}.Amps.Mode            = 'ONLINE';
AO{SR_QFB_FAM}.Amps.DataType        = 'Scalar';
AO{SR_QFB_FAM}.Amps.Units           = 'Hardware';
AO{SR_QFB_FAM}.Amps.HWUnits         = 'Amps';           
AO{SR_QFB_FAM}.Amps.PhysicsUnits    = 'K';

AO{SR_QFC_FAM}.Amps.Mode            = 'ONLINE';
AO{SR_QFC_FAM}.Amps.DataType        = 'Scalar';
AO{SR_QFC_FAM}.Amps.Units           = 'Hardware';
AO{SR_QFC_FAM}.Amps.HWUnits         = 'Amps';           
AO{SR_QFC_FAM}.Amps.PhysicsUnits    = 'K';


% Response matrix kicks (in HWUnits)
setao(cell2field(AO));   %required to make physics2hw function
KickInK = .05;
AO{SR_QFA_FAM}.Setpoint.DeltaRespMat = physics2hw('QFA','Setpoint', KickInK);
AO{SR_QFB_FAM}.Setpoint.DeltaRespMat = physics2hw('QFB','Setpoint', KickInK);
AO{SR_QFC_FAM}.Setpoint.DeltaRespMat = physics2hw('QFC','Setpoint', KickInK);


%===============
%Sextupole data
%===============

% *** SF ***
AO{SR_SF_FAM}.FamilyName              = 'SF';
AO{SR_SF_FAM}.FamilyType              = 'SEXT';
AO{SR_SF_FAM}.MemberOf                = {'MachineConfig'; 'SF'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector'};

AO{SR_SF_FAM}.Monitor.Mode            = 'SIMULATOR';
AO{SR_SF_FAM}.Monitor.DataType        = 'Scalar';
AO{SR_SF_FAM}.Monitor.Units           = 'Hardware';
AO{SR_SF_FAM}.Monitor.HWUnits         = 'Counts';           
AO{SR_SF_FAM}.Monitor.PhysicsUnits    = 'K2';

AO{SR_SF_FAM}.Setpoint.Mode           = 'SIMULATOR';
AO{SR_SF_FAM}.Setpoint.DataType       = 'Scalar';
AO{SR_SF_FAM}.Setpoint.Units          = 'Hardware';
AO{SR_SF_FAM}.Setpoint.HWUnits        = 'Counts';           
AO{SR_SF_FAM}.Setpoint.PhysicsUnits   = 'K2';

%SF on 
AO{SR_SF_FAM}.On.Mode = 'Online';
AO{SR_SF_FAM}.On.DataType         = 'Scalar';
AO{SR_SF_FAM}.On.Units            = 'Hardware';
AO{SR_SF_FAM}.On.HWUnits          = '';           
AO{SR_SF_FAM}.On.PhysicsUnits     = '';
AO{SR_SF_FAM}.On.HW2PhysicsParams = 1;
AO{SR_SF_FAM}.On.Physics2HWParams = 1;
           
% common           monitor             setpoint    stat devlist elem     range   tol
SF={
 '1SF    '    'SB1400-00:adc'     'SB1400-00:dac'  1   [1 ,1]  1     [0, 500] 2.00  ; ...
 '2SF    '    'SB1400-00:adc'     'SB1400-00:dac'  1   [2 ,1]  2     [0, 500] 2.00  ; ...
 '3SF    '    'SB1400-00:adc'     'SB1400-00:dac'  1   [3 ,1]  3     [0, 500] 2.00  ; ...
 '4SF    '    'SB1400-00:adc'     'SB1400-00:dac'  1   [4 ,1]  4     [0, 500] 2.00  ; ...
 '5SF    '    'SB1400-00:adc'     'SB1400-00:dac'  1   [5 ,1]  5     [0, 500] 2.00  ; ...
 '6SF    '    'SB1400-00:adc'     'SB1400-00:dac'  1   [6 ,1]  6     [0, 500] 2.00  ; ...
 '7SF    '    'SB1400-00:adc'     'SB1400-00:dac'  1   [7 ,1]  7     [0, 500] 2.00  ; ...
 '8SF    '    'SB1400-00:adc'     'SB1400-00:dac'  1   [8 ,1]  8     [0, 500] 2.00  ; ...
 '9SF    '    'SB1400-00:adc'     'SB1400-00:dac'  1   [9 ,1]  9     [0, 500] 2.00  ; ...
 '10SF   '    'SB1400-00:adc'     'SB1400-00:dac'  1   [10,1]  10    [0, 500] 2.00  ; ...
 '11SF   '    'SB1400-00:adc'     'SB1400-00:dac'  1   [11,1]  11    [0, 500] 2.00  ; ...
 '12SF   '    'SB1400-00:adc'     'SB1400-00:dac'  1   [12,1]  12    [0, 500] 2.00  ; ...
};

HW2Physics =  -24.793 / 5112170;    % Dimad / DAC (DAC value of 5112170 is wrong!!!  Dimad value may be wrong too!!!) 

for ii=1:size(SF,1)
name=SF{ii,1};      AO{SR_SF_FAM}.CommonNames(ii,:)           = name;            
name=SF{ii,2};      AO{SR_SF_FAM}.Monitor.ChannelNames(ii,:)  = name;
name=SF{ii,3};      AO{SR_SF_FAM}.Setpoint.ChannelNames(ii,:) = name;     
val =SF{ii,4};      AO{SR_SF_FAM}.Status(ii,1)                  = val;
val =SF{ii,5};      AO{SR_SF_FAM}.DeviceList(ii,:)            = val;
val =SF{ii,6};      AO{SR_SF_FAM}.ElementList(ii,1)           = val;
val =SF{ii,7};      AO{SR_SF_FAM}.Setpoint.Range(ii,:)        = [0 8388607];
val =SF{ii,8};      AO{SR_SF_FAM}.Setpoint.Tolerance(ii,1)    = ToleranceInCountsSF;

AO{SR_SF_FAM}.Monitor.HW2PhysicsParams(ii,:)  = HW2Physics;          
AO{SR_SF_FAM}.Monitor.Physics2HWParams(ii,:)  = 1 / HW2Physics;

AO{SR_SF_FAM}.Setpoint.HW2PhysicsParams(ii,:) = HW2Physics;           
AO{SR_SF_FAM}.Setpoint.Physics2HWParams(ii,:) = 1 / HW2Physics;

AO{SR_SF_FAM}.Monitor.Handles(ii,1)    = NaN;
AO{SR_SF_FAM}.Setpoint.Handles(ii,1)   = NaN;

AO{SR_SF_FAM}.On.ChannelNames(ii,:) = sprintf('SB1400-00:on  ');

AO{SR_SF_FAM}.On.Handles(ii,1) = NaN;

end


% *** SD ***
AO{SR_SD_FAM}.FamilyName              = 'SD';
AO{SR_SD_FAM}.FamilyType              = 'SEXT';
AO{SR_SD_FAM}.MemberOf                = {'MachineConfig'; 'SD'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector'};

AO{SR_SD_FAM}.Monitor.Mode            = 'SIMULATOR';
AO{SR_SD_FAM}.Monitor.DataType        = 'Scalar';
AO{SR_SD_FAM}.Monitor.Units           = 'Hardware';
AO{SR_SD_FAM}.Monitor.HWUnits         = 'Counts';           
AO{SR_SD_FAM}.Monitor.PhysicsUnits    = 'K2';

AO{SR_SD_FAM}.Setpoint.Mode           = 'SIMULATOR';
AO{SR_SD_FAM}.Setpoint.DataType       = 'Scalar';
AO{SR_SD_FAM}.Setpoint.Units          = 'Hardware';
AO{SR_SD_FAM}.Setpoint.HWUnits        = 'Counts';           
AO{SR_SD_FAM}.Setpoint.PhysicsUnits   = 'K2';

%SD on 
AO{SR_SD_FAM}.On.Mode = 'Online';
AO{SR_SD_FAM}.On.DataType         = 'Scalar';
AO{SR_SD_FAM}.On.Units            = 'Hardware';
AO{SR_SD_FAM}.On.HWUnits          = '';           
AO{SR_SD_FAM}.On.PhysicsUnits     = '';
AO{SR_SD_FAM}.On.HW2PhysicsParams = 1;
AO{SR_SD_FAM}.On.Physics2HWParams = 1;

% common           monitor             setpoint        stat devlist elem  range    tol
SD={
 '1SD1    '    'SOA1400-00:adc'     'SOA1400-00:dac'  1   [1 ,1]  1     [0, 500] 2.00  ; ...
 '1SD2    '    'SOA1400-00:adc'     'SOA1400-00:dac'  1   [1 ,2]  2     [0, 500] 2.00  ; ...
 '2SD1    '    'SOA1400-00:adc'     'SOA1400-00:dac'  1   [2 ,1]  3     [0, 500] 2.00  ; ...
 '2SD2    '    'SOA1400-00:adc'     'SOA1400-00:dac'  1   [2 ,2]  4     [0, 500] 2.00  ; ...
 '3SD1    '    'SOA1400-00:adc'     'SOA1400-00:dac'  1   [3 ,1]  5     [0, 500] 2.00  ; ...
 '3SD2    '    'SOA1400-00:adc'     'SOA1400-00:dac'  1   [3 ,2]  6     [0, 500] 2.00  ; ...
 '4SD1    '    'SOA1400-00:adc'     'SOA1400-00:dac'  1   [4 ,1]  7     [0, 500] 2.00  ; ...
 '4SD2    '    'SOA1400-00:adc'     'SOA1400-00:dac'  1   [4 ,2]  8     [0, 500] 2.00  ; ...
 '5SD1    '    'SOA1400-00:adc'     'SOA1400-00:dac'  1   [5 ,1]  9     [0, 500] 2.00  ; ...
 '5SD2    '    'SOA1400-00:adc'     'SOA1400-00:dac'  1   [5 ,2]  10    [0, 500] 2.00  ; ...
 '6SD1    '    'SOA1400-00:adc'     'SOA1400-00:dac'  1   [6 ,1]  11    [0, 500] 2.00  ; ...
 '6SD2    '    'SOA1400-00:adc'     'SOA1400-00:dac'  1   [6 ,2]  12    [0, 500] 2.00  ; ...
 '7SD1    '    'SOA1400-00:adc'     'SOA1400-00:dac'  1   [7 ,1]  13    [0, 500] 2.00  ; ...
 '7SD2    '    'SOA1400-00:adc'     'SOA1400-00:dac'  1   [7 ,2]  14    [0, 500] 2.00  ; ...
 '8SD1    '    'SOA1400-00:adc'     'SOA1400-00:dac'  1   [8 ,1]  15    [0, 500] 2.00  ; ...
 '8SD2    '    'SOA1400-00:adc'     'SOA1400-00:dac'  1   [8 ,2]  16    [0, 500] 2.00  ; ...
 '9SD1    '    'SOA1400-00:adc'     'SOA1400-00:dac'  1   [9 ,1]  17    [0, 500] 2.00  ; ...
 '9SD2    '    'SOA1400-00:adc'     'SOA1400-00:dac'  1   [9 ,2]  18    [0, 500] 2.00  ; ...
 '10SD1   '    'SOA1400-00:adc'     'SOA1400-00:dac'  1   [10,1]  19    [0, 500] 2.00  ; ...
 '10SD2   '    'SOA1400-00:adc'     'SOA1400-00:dac'  1   [10,2]  20    [0, 500] 2.00  ; ...
 '11SD1   '    'SOA1400-00:adc'     'SOA1400-00:dac'  1   [11,1]  21    [0, 500] 2.00  ; ...
 '11SD2   '    'SOA1400-00:adc'     'SOA1400-00:dac'  1   [11,2]  22    [0, 500] 2.00  ; ...
 '12SD1   '    'SOA1400-00:adc'     'SOA1400-00:dac'  1   [12,1]  23    [0, 500] 2.00  ; ...
 '12SD2   '    'SOA1400-00:adc'     'SOA1400-00:dac'  1   [12,2]  24    [0, 500] 2.00  ; ...
};
 

HW2Physics =  42.9572 / 5112170;  % Dimad / DAC (DAC value of 5112170 is wrong!!!)   Dimad value may be wrong too!!!) 

for ii=1:size(SD,1)
name=SD{ii,1};      AO{SR_SD_FAM}.CommonNames(ii,:)           = name;            
name=SD{ii,2};      AO{SR_SD_FAM}.Monitor.ChannelNames(ii,:)  = name;
name=SD{ii,3};      AO{SR_SD_FAM}.Setpoint.ChannelNames(ii,:) = name;     
val =SD{ii,4};      AO{SR_SD_FAM}.Status(ii,1)                  = val;
val =SD{ii,5};      AO{SR_SD_FAM}.DeviceList(ii,:)            = val;
val =SD{ii,6};      AO{SR_SD_FAM}.ElementList(ii,1)           = val;
val =SD{ii,7};      AO{SR_SD_FAM}.Setpoint.Range(ii,:)        = [0 8388607];
val =SD{ii,8};      AO{SR_SD_FAM}.Setpoint.Tolerance(ii,1)    = ToleranceInCountsSD;

AO{SR_SD_FAM}.Monitor.HW2PhysicsParams(ii,:)  = HW2Physics;          
AO{SR_SD_FAM}.Monitor.Physics2HWParams(ii,:)  = 1 / HW2Physics;

AO{SR_SD_FAM}.Setpoint.HW2PhysicsParams(ii,:) = HW2Physics;           
AO{SR_SD_FAM}.Setpoint.Physics2HWParams(ii,:) = 1 / HW2Physics;

AO{SR_SD_FAM}.On.ChannelNames(ii,:) = sprintf('SOA1400-00:on  ');

AO{SR_SD_FAM}.Monitor.Handles(ii,1)  = NaN;
AO{SR_SD_FAM}.Setpoint.Handles(ii,1) = NaN;
AO{SR_SD_FAM}.On.Handles(ii,1) = NaN;
end


% Response matrix kicks (in HWUnits)
setao(cell2field(AO));   %required to make physics2hw function
KickInKprime = 1;
AO{SR_SF_FAM}.Setpoint.DeltaRespMat = physics2hw('SF','Setpoint', KickInKprime);
AO{SR_SD_FAM}.Setpoint.DeltaRespMat = physics2hw('SD','Setpoint', KickInKprime);



%===================================RF Cavity
fprintf('   RF frequency in manual mode\n');
AO{SR_RF_FAM}.FamilyName = 'RF';
AO{SR_RF_FAM}.FamilyType = 'CAVITY';
AO{SR_RF_FAM}.MemberOf   = {'RF';};  % 'MachineConfig';
AO{SR_RF_FAM}.CommonNames = 'RF1';
AO{SR_RF_FAM}.DeviceList  = [1 1];
AO{SR_RF_FAM}.ElementList = 1;
AO{SR_RF_FAM}.Status = 1;

AO{SR_RF_FAM}.Monitor.Mode = 'Manual';
AO{SR_RF_FAM}.Monitor.DataType = 'Scalar';
AO{SR_RF_FAM}.Monitor.ChannelNames = 'RFFrequency';
AO{SR_RF_FAM}.Monitor.Units = 'Hardware';
AO{SR_RF_FAM}.Monitor.PhysicsUnits  = 'Hz';
AO{SR_RF_FAM}.Monitor.HWUnits = 'MHz';
AO{SR_RF_FAM}.Monitor.HW2PhysicsParams = 1e6;          
AO{SR_RF_FAM}.Monitor.Physics2HWParams = 1/1e6;
AO{SR_RF_FAM}.Monitor.Handles = NaN;

AO{SR_RF_FAM}.Setpoint.PhysicsUnits = 'Hz';
AO{SR_RF_FAM}.Setpoint.HWUnits = 'MHz';
AO{SR_RF_FAM}.Setpoint.Mode = 'Manual';
AO{SR_RF_FAM}.Setpoint.DataType = 'Scalar';
AO{SR_RF_FAM}.Setpoint.ChannelNames = 'RFFrequency';
AO{SR_RF_FAM}.Setpoint.Units = 'Hardware';
AO{SR_RF_FAM}.Setpoint.Range = [0 550e6];
AO{SR_RF_FAM}.Setpoint.Tolerance = 100;
AO{SR_RF_FAM}.Setpoint.HW2PhysicsParams = 1e6;         
AO{SR_RF_FAM}.Setpoint.Physics2HWParams = 1/1e6;
AO{SR_RF_FAM}.Setpoint.Handles = NaN;

%=================================================TUNE

AO{SR_TUNE_FAM}.FamilyName = 'TUNE';
AO{SR_TUNE_FAM}.FamilyType = 'Diagnostic';
AO{SR_TUNE_FAM}.MemberOf   = {'TUNE'; 'Diagnostic'};
AO{SR_TUNE_FAM}.CommonNames ='xtune';'ytune';'stune';
AO{SR_TUNE_FAM}.DeviceList = [1 1; 1 2; 1 3];
AO{SR_TUNE_FAM}.ElementList = [1 2 3]';
AO{SR_TUNE_FAM}.Status = [1 1 0]';
AO{SR_TUNE_FAM}.Golden = [10.22; 3.26; 0.008];

AO{SR_TUNE_FAM}.Monitor.Mode     = 'Manual';
AO{SR_TUNE_FAM}.Monitor.DataType = 'Vector';
AO{SR_TUNE_FAM}.Monitor.DataTypeIndex = [1 2 3];
AO{SR_TUNE_FAM}.Monitor.ChannelNames =  'MeasTune';
AO{SR_TUNE_FAM}.Monitor.Units = 'Hardware';
AO{SR_TUNE_FAM}.Monitor.HW2PhysicsParams = 1;
AO{SR_TUNE_FAM}.Monitor.Physics2HWParams = 1;
AO{SR_TUNE_FAM}.Monitor.HWUnits          = 'fractional tune';           
AO{SR_TUNE_FAM}.Monitor.PhysicsUnits     = 'fractional tune';
 
 
%===============================
%DCCT
%===============================

AO{SR_DCCT_FAM}.FamilyName                     = 'DCCT';
AO{SR_DCCT_FAM}.FamilyType                     = 'Diagnostic';
AO{SR_DCCT_FAM}.MemberOf                       = {'DCCT'; 'Diagnostic'};

AO{SR_DCCT_FAM}.CommonNames                    = 'DCCT';
AO{SR_DCCT_FAM}.DeviceList                     = [1 1];
AO{SR_DCCT_FAM}.ElementList                    = 1';
AO{SR_DCCT_FAM}.Status                         = AO{SR_DCCT_FAM}.ElementList;

AO{SR_DCCT_FAM}.Monitor.Mode                   = 'SIMULATOR';
AO{SR_DCCT_FAM}.Monitor.DataType               = 'Scalar';
AO{SR_DCCT_FAM}.Monitor.ChannelNames           = 'PCT1402-01:mA:fbk';    
AO{SR_DCCT_FAM}.Monitor.Units                  = 'Hardware';
AO{SR_DCCT_FAM}.Monitor.Handles                = NaN;
AO{SR_DCCT_FAM}.Monitor.HWUnits                = 'milli-ampere';           
AO{SR_DCCT_FAM}.Monitor.PhysicsUnits           = 'ampere';
AO{SR_DCCT_FAM}.Monitor.HW2PhysicsParams       = 1;          
AO{SR_DCCT_FAM}.Monitor.Physics2HWParams       = 1;




% START TEST RJB
%===============
%BTS Quad data, I am storing them in a family so that I can use
%getmachineconfig and setmachineconfig to keep track of the machine
% is there a better way?
%===============
% *** BTS QF and QD data ***
AO{BTS_QUAD_FAM}.FamilyName              = 'BTSQUADS';
AO{BTS_QUAD_FAM}.FamilyType              = 'QUAD';
AO{BTS_QUAD_FAM}.MemberOf                = {'MachineConfig'; 'BTSQUAD'; 'BTS'};

AO{BTS_QUAD_FAM}.Monitor.Mode            = 'SIMULATOR';
AO{BTS_QUAD_FAM}.Monitor.DataType        = 'Scalar';
AO{BTS_QUAD_FAM}.Monitor.Units           = 'Hardware';
AO{BTS_QUAD_FAM}.Monitor.HWUnits         = 'Counts';           
AO{BTS_QUAD_FAM}.Monitor.PhysicsUnits    = 'K2';

AO{BTS_QUAD_FAM}.Setpoint.Mode           = 'SIMULATOR';
AO{BTS_QUAD_FAM}.Setpoint.DataType       = 'Scalar';
AO{BTS_QUAD_FAM}.Setpoint.Units          = 'Hardware';
AO{BTS_QUAD_FAM}.Setpoint.HWUnits        = 'Counts';           
AO{BTS_QUAD_FAM}.Setpoint.PhysicsUnits   = 'K2';

AO{BTS_QUAD_FAM}.On.Mode = 'Online';
AO{BTS_QUAD_FAM}.On.DataType         = 'Scalar';
AO{BTS_QUAD_FAM}.On.Units            = 'Hardware';
AO{BTS_QUAD_FAM}.On.HWUnits          = '';           
AO{BTS_QUAD_FAM}.On.PhysicsUnits     = '';
AO{BTS_QUAD_FAM}.On.HW2PhysicsParams = 1;
AO{BTS_QUAD_FAM}.On.Physics2HWParams = 1;

%common      base PVname   stat devlist elem  ScaleFact   range   tol
btsQuads={
 'QD1    '    'QD1305-01:'  1   [1 ,1]  1     1.0       [0, 500] 2.00  ; ...
 'QD2    '    'QD1305-02:'  1   [2 ,1]  2     1.0       [0, 500] 2.00  ; ...
 'QD3    '    'QD1400-01:'  1   [3 ,1]  3     1.0       [0, 500] 2.00  ; ...
 'QD4    '    'QD1400-02:'  1   [4 ,1]  4     1.0       [0, 500] 2.00  ; ...
 'QD5    '    'QD1400-03:'  1   [5 ,1]  5     1.0       [0, 500] 2.00  ; ...
 'QF1    '    'QF1305-01:'  1   [1 ,2]  6     1.0       [0, 500] 2.00  ; ...
 'QF2    '    'QF1305-02:'  1   [2 ,2]  7     1.0       [0, 500] 2.00  ; ...
 'QF3    '    'QF1400-01:'  1   [3 ,2]  8     1.0       [0, 500] 2.00  ; ...
 'QF4    '    'QF1400-02:'  1   [4 ,2]  9     1.0       [0, 500] 2.00  ; ...
 'QF5    '    'QF1400-03:'  1   [5 ,2]  10    1.0       [0, 500] 2.00  ; ...
 
};
 

HW2Physics =  42.9572 / 5112170;  % Dimad / DAC (DAC value of 5112170 is wrong!!!)   Dimad value may be wrong too!!!) 

for ii=1:size(btsQuads,1)
    name=btsQuads{ii,1};      AO{BTS_QUAD_FAM}.CommonNames(ii,:)           = name;            
    name=btsQuads{ii,2};      
    AO{BTS_QUAD_FAM}.Monitor.ChannelNames(ii,:)  = strcat(name,'adc');
    %name=btsQuads{ii,3};      
    AO{BTS_QUAD_FAM}.Setpoint.ChannelNames(ii,:)  = strcat(name,'dac');
    
    %name=btsQuads{ii,4};      
    AO{BTS_QUAD_FAM}.On.ChannelNames(ii,:)  = strcat(name,'on');
    %name=btsQuads{ii,3};      AO{BTS_QUAD_FAM}.Setpoint.ChannelNames(ii,:) = name;     
    val =btsQuads{ii,3};      AO{BTS_QUAD_FAM}.Status(ii,1)                  = val;
    val =btsQuads{ii,4};      AO{BTS_QUAD_FAM}.DeviceList(ii,:)            = val;
    val =btsQuads{ii,5};      AO{BTS_QUAD_FAM}.ElementList(ii,1)           = val;
    val =btsQuads{ii,6};      AO{BTS_QUAD_FAM}.Setpoint.Range(ii,:)        = [-0 65535];
    val =btsQuads{ii,7};      AO{BTS_QUAD_FAM}.Setpoint.Tolerance(ii,1)    = ToleranceInCountsBTS;
    
    AO{BTS_QUAD_FAM}.Monitor.HW2PhysicsParams(ii,:)  = HW2Physics;          
    AO{BTS_QUAD_FAM}.Monitor.Physics2HWParams(ii,:)  = 1 / HW2Physics;
    
    AO{BTS_QUAD_FAM}.Setpoint.HW2PhysicsParams(ii,:) = HW2Physics;           
    AO{BTS_QUAD_FAM}.Setpoint.Physics2HWParams(ii,:) = 1 / HW2Physics;
    
    AO{BTS_QUAD_FAM}.Monitor.Handles(ii,1)  = NaN;
    AO{BTS_QUAD_FAM}.Setpoint.Handles(ii,1) = NaN;
    AO{BTS_QUAD_FAM}.On.Handles(ii,1) = NaN;
end


% *** BTS STEERING data ***
AO{BTS_STEER_FAM}.FamilyName              = 'BTSSTEER';
AO{BTS_STEER_FAM}.FamilyType              = 'STEER';
AO{BTS_STEER_FAM}.MemberOf                = {'MachineConfig'; 'BTSSTEER'; 'BTS'};

AO{BTS_STEER_FAM}.Monitor.Mode            = 'SIMULATOR';
AO{BTS_STEER_FAM}.Monitor.DataType        = 'Scalar';
AO{BTS_STEER_FAM}.Monitor.Units           = 'Hardware';
AO{BTS_STEER_FAM}.Monitor.HWUnits         = 'Counts';           
AO{BTS_STEER_FAM}.Monitor.PhysicsUnits    = 'K2';

AO{BTS_STEER_FAM}.Setpoint.Mode           = 'SIMULATOR';
AO{BTS_STEER_FAM}.Setpoint.DataType       = 'Scalar';
AO{BTS_STEER_FAM}.Setpoint.Units          = 'Hardware';
AO{BTS_STEER_FAM}.Setpoint.HWUnits        = 'Counts';           
AO{BTS_STEER_FAM}.Setpoint.PhysicsUnits   = 'K2';

AO{BTS_STEER_FAM}.On.Mode = 'Online';
AO{BTS_STEER_FAM}.On.DataType         = 'Scalar';
AO{BTS_STEER_FAM}.On.Units            = 'Hardware';
AO{BTS_STEER_FAM}.On.HWUnits          = '';           
AO{BTS_STEER_FAM}.On.PhysicsUnits     = '';
AO{BTS_STEER_FAM}.On.HW2PhysicsParams = 1;
AO{BTS_STEER_FAM}.On.Physics2HWParams = 1;


%common              monitor             setpoint    stat devlist elem  ScaleFact   range   tol
btsSteer={
 'STV1    '    'STV1305-01:'     1   [1 ,1]  1     1.0       [0, 500] 2.00  ; ...
 'STV2    '    'STV1305-02:'     1   [2 ,1]  2     1.0       [0, 500] 2.00  ; ...     
 'STV3    '    'STV1400-01:'     1   [3 ,1]  3     1.0       [0, 500] 2.00  ; ...
 'STV4    '    'STV1400-02:'     1   [4 ,1]  4     1.0       [0, 500] 2.00  ; ... 
 'STV5    '    'STV1400-03:'     1   [5 ,1]  5     1.0       [0, 500] 2.00  ; ... 
 
 'STH1    '    'STH1305-01:'     1   [1 ,2]  6     1.0       [0, 500] 2.00  ; ...
 'STH2    '    'STH1305-02:'     1   [2 ,2]  7     1.0       [0, 500] 2.00  ; ...     
 'STH3    '    'STH1400-01:'     1   [3 ,2]  8     1.0       [0, 500] 2.00  ; ...
 'STH4    '    'STH1400-02:'     1   [4 ,2]  9     1.0       [0, 500] 2.00  ; ... 
 'STH5    '    'STH1400-03:'     1   [5 ,2]  10    1.0       [0, 500] 2.00  ; ... 
};
 

HW2Physics =  42.9572 / 5112170;  % Dimad / DAC (DAC value of 5112170 is wrong!!!)   Dimad value may be wrong too!!!) 

for ii=1:size(btsSteer,1)
    name=btsSteer{ii,1};      AO{BTS_STEER_FAM}.CommonNames(ii,:)           = name;
    
    name=btsSteer{ii,2};      
    AO{BTS_STEER_FAM}.Monitor.ChannelNames(ii,:)  = strcat(name,'adc');
    %name=btsSteer{ii,3};      
    AO{BTS_STEER_FAM}.Setpoint.ChannelNames(ii,:)  = strcat(name,'dac');
    %name=btsSteer{ii,4};      
    AO{BTS_STEER_FAM}.On.ChannelNames(ii,:)  = strcat(name,'on');
    
    %name=btsSteer{ii,2};      AO{BTS_STEER_FAM}.Monitor.ChannelNames(ii,:)  = name;
    %name=btsSteer{ii,3};      AO{BTS_STEER_FAM}.Setpoint.ChannelNames(ii,:) = name;     
    val =btsSteer{ii,3};      AO{BTS_STEER_FAM}.Status(ii,1)                  = val;
    val =btsSteer{ii,4};      AO{BTS_STEER_FAM}.DeviceList(ii,:)            = val;
    val =btsSteer{ii,5};      AO{BTS_STEER_FAM}.ElementList(ii,1)           = val;
    val =btsSteer{ii,6};      AO{BTS_STEER_FAM}.Setpoint.Range(ii,:)        = [-inf inf];
    val =btsSteer{ii,7};      AO{BTS_STEER_FAM}.Setpoint.Tolerance(ii,1)    = ToleranceInCountsBTS;
    
    AO{BTS_STEER_FAM}.Monitor.HW2PhysicsParams(ii,:)  = HW2Physics;          
    AO{BTS_STEER_FAM}.Monitor.Physics2HWParams(ii,:)  = 1 / HW2Physics;
    
    AO{BTS_STEER_FAM}.Setpoint.HW2PhysicsParams(ii,:) = HW2Physics;           
    AO{BTS_STEER_FAM}.Setpoint.Physics2HWParams(ii,:) = 1 / HW2Physics;
    
    AO{BTS_STEER_FAM}.Monitor.Handles(ii,1)  = NaN;
    AO{BTS_STEER_FAM}.Setpoint.Handles(ii,1) = NaN;
    AO{BTS_STEER_FAM}.On.Handles(ii,1) = NaN;

end

%BTS Bend 
AO{BTS_BEND_FAM}.FamilyName              = 'BTSBEND';
AO{BTS_BEND_FAM}.FamilyType              = 'BEND';
AO{BTS_BEND_FAM}.MemberOf                = {'MachineConfig'; 'BTSBEND'; 'BTS'};

AO{BTS_BEND_FAM}.Monitor.Mode            = 'SIMULATOR';
AO{BTS_BEND_FAM}.Monitor.DataType        = 'Scalar';
AO{BTS_BEND_FAM}.Monitor.Units           = 'Hardware';
AO{BTS_BEND_FAM}.Monitor.HWUnits         = 'Counts';           
AO{BTS_BEND_FAM}.Monitor.PhysicsUnits    = 'K2';

AO{BTS_BEND_FAM}.Setpoint.Mode           = 'SIMULATOR';
AO{BTS_BEND_FAM}.Setpoint.DataType       = 'Scalar';
AO{BTS_BEND_FAM}.Setpoint.Units          = 'Hardware';
AO{BTS_BEND_FAM}.Setpoint.HWUnits        = 'Counts';           
AO{BTS_BEND_FAM}.Setpoint.PhysicsUnits   = 'K2';

AO{BTS_BEND_FAM}.On.Mode = 'Online';
AO{BTS_BEND_FAM}.On.DataType         = 'Scalar';
AO{BTS_BEND_FAM}.On.Units            = 'Hardware';
AO{BTS_BEND_FAM}.On.HWUnits          = '';           
AO{BTS_BEND_FAM}.On.PhysicsUnits     = '';
AO{BTS_BEND_FAM}.On.HW2PhysicsParams = 1;
AO{BTS_BEND_FAM}.On.Physics2HWParams = 1;

%common              monitor             setpoint    stat devlist elem  ScaleFact   range   tol
btsBend={
 'B1    '    'B1305-01:'    1   [1 ,1]  1     1.0       [0, 500] 2.00  ; ...
};
 

HW2Physics =  42.9572 / 5112170;  % Dimad / DAC (DAC value of 5112170 is wrong!!!)   Dimad value may be wrong too!!!) 

for ii=1:size(btsBend,1)
name=btsBend{ii,1};      AO{BTS_BEND_FAM}.CommonNames(ii,:)           = name;

name=btsBend{ii,2};      AO{BTS_BEND_FAM}.Monitor.ChannelNames(ii,:)  = strcat(name,'adc');
%name=btsBend{ii,3};      
AO{BTS_BEND_FAM}.Setpoint.ChannelNames(ii,:)  = strcat(name,'dac');
%name=btsBend{ii,4};      
AO{BTS_BEND_FAM}.On.ChannelNames(ii,:)  = strcat(name,'on');

%name=btsBend{ii,2};      AO{BTS_BEND_FAM}.Monitor.ChannelNames(ii,:)  = name;
%name=btsBend{ii,3};      AO{BTS_BEND_FAM}.Setpoint.ChannelNames(ii,:) = name;     
val =btsBend{ii,3};      AO{BTS_BEND_FAM}.Status(ii,1)                  = val;
val =btsBend{ii,4};      AO{BTS_BEND_FAM}.DeviceList(ii,:)            = val;
val =btsBend{ii,5};      AO{BTS_BEND_FAM}.ElementList(ii,1)           = val;
val =btsBend{ii,6};      AO{BTS_BEND_FAM}.Setpoint.Range(ii,:)        = [-inf inf];
val =btsBend{ii,7};      AO{BTS_BEND_FAM}.Setpoint.Tolerance(ii,1)    = ToleranceInCountsBTS;

AO{BTS_BEND_FAM}.Monitor.HW2PhysicsParams(ii,:)  = HW2Physics;          
AO{BTS_BEND_FAM}.Monitor.Physics2HWParams(ii,:)  = 1 / HW2Physics;

AO{BTS_BEND_FAM}.Setpoint.HW2PhysicsParams(ii,:) = HW2Physics;           
AO{BTS_BEND_FAM}.Setpoint.Physics2HWParams(ii,:) = 1 / HW2Physics;

AO{BTS_BEND_FAM}.Monitor.Handles(ii,1)  = NaN;
AO{BTS_BEND_FAM}.Setpoint.Handles(ii,1) = NaN;
AO{BTS_BEND_FAM}.On.Handles(ii,1) = NaN;

end

%BTS Septum
AO{BTS_SEPTUM_FAM}.FamilyName              = 'BTSSEPT';
AO{BTS_SEPTUM_FAM}.FamilyType              = 'SEPT';
AO{BTS_SEPTUM_FAM}.MemberOf                = {'MachineConfig'; 'SEPTUM'; 'BTS'};

AO{BTS_SEPTUM_FAM}.Monitor.Mode            = 'SIMULATOR';
AO{BTS_SEPTUM_FAM}.Monitor.DataType        = 'Scalar';
AO{BTS_SEPTUM_FAM}.Monitor.Units           = 'Hardware';
AO{BTS_SEPTUM_FAM}.Monitor.HWUnits         = 'Counts';           
AO{BTS_SEPTUM_FAM}.Monitor.PhysicsUnits    = 'K2';

AO{BTS_SEPTUM_FAM}.Setpoint.Mode           = 'SIMULATOR';
AO{BTS_SEPTUM_FAM}.Setpoint.DataType       = 'Scalar';
AO{BTS_SEPTUM_FAM}.Setpoint.Units          = 'Hardware';
AO{BTS_SEPTUM_FAM}.Setpoint.HWUnits        = 'Counts';           
AO{BTS_SEPTUM_FAM}.Setpoint.PhysicsUnits   = 'K2';


%common              monitor             setpoint    stat devlist elem  ScaleFact   range   tol
btsSept={
 'SEP1        '    'SEP1400-01:adc      ' 'SEP1400-01:dac      '  1   [1 ,1]  1     1.0       [0, 16777215] 2.00  ; ...
 'SEP1Time    '    'SEP1400-01:delay:ns ' 'SEP1400-01:delay:ns '  1   [1 ,2]  2     1.0       [0, 16777215] 2.00  ; ...     
 'SEP2        '    'SEP1401-01:adc      ' 'SEP1401-01:dac      '  1   [2 ,1]  3     1.0       [0, 16777215] 2.00  ; ...
};
 

HW2Physics =  42.9572 / 5112170;  % Dimad / DAC (DAC value of 5112170 is wrong!!!)   Dimad value may be wrong too!!!) 

for ii=1:size(btsSept,1)
name=btsSept{ii,1};      AO{BTS_SEPTUM_FAM}.CommonNames(ii,:)           = name;            
name=btsSept{ii,2};      AO{BTS_SEPTUM_FAM}.Monitor.ChannelNames(ii,:)  = name;
name=btsSept{ii,3};      AO{BTS_SEPTUM_FAM}.Setpoint.ChannelNames(ii,:) = name;     
val =btsSept{ii,4};      AO{BTS_SEPTUM_FAM}.Status(ii,1)                  = val;
val =btsSept{ii,5};      AO{BTS_SEPTUM_FAM}.DeviceList(ii,:)            = val;
val =btsSept{ii,6};      AO{BTS_SEPTUM_FAM}.ElementList(ii,1)           = val;
val =btsSept{ii,7};      AO{BTS_SEPTUM_FAM}.Setpoint.Range(ii,:)        = [-inf inf];
val =btsSept{ii,8};      AO{BTS_SEPTUM_FAM}.Setpoint.Tolerance(ii,1)    = ToleranceInCountsBTS;

AO{BTS_SEPTUM_FAM}.Monitor.HW2PhysicsParams(ii,:)  = HW2Physics;          
AO{BTS_SEPTUM_FAM}.Monitor.Physics2HWParams(ii,:)  = 1 / HW2Physics;

AO{BTS_SEPTUM_FAM}.Setpoint.HW2PhysicsParams(ii,:) = HW2Physics;           
AO{BTS_SEPTUM_FAM}.Setpoint.Physics2HWParams(ii,:) = 1 / HW2Physics;

AO{BTS_SEPTUM_FAM}.Monitor.Handles(ii,1)  = NaN;
AO{BTS_SEPTUM_FAM}.Setpoint.Handles(ii,1) = NaN;
AO{BTS_SEPTUM_FAM}.On.Handles(ii,1) = NaN;
AO{BTS_SEPTUM_FAM}.On.Handles(ii,1) = NaN;
end

%SEPT on 
AO{BTS_SEPTUM_FAM}.On.Mode = 'Online';
AO{BTS_SEPTUM_FAM}.On.DataType         = 'Scalar';
AO{BTS_SEPTUM_FAM}.On.Units            = 'Hardware';
AO{BTS_SEPTUM_FAM}.On.HWUnits          = '';           
AO{BTS_SEPTUM_FAM}.On.PhysicsUnits     = '';
AO{BTS_SEPTUM_FAM}.On.HW2PhysicsParams = 1;
AO{BTS_SEPTUM_FAM}.On.Physics2HWParams = 1;
AO{BTS_SEPTUM_FAM}.On.ChannelNames(1,:) = sprintf('SEP1400-01:on  ');



%BTS Kickers
AO{BTS_KICK_FAM}.FamilyName              = 'BTSKICK';
AO{BTS_KICK_FAM}.FamilyType              = 'KICK';
AO{BTS_KICK_FAM}.MemberOf                = {'MachineConfig'; 'KICKER'; 'BTS'};

AO{BTS_KICK_FAM}.Monitor.Mode            = 'SIMULATOR';
AO{BTS_KICK_FAM}.Monitor.DataType        = 'Scalar';
AO{BTS_KICK_FAM}.Monitor.Units           = 'Hardware';
AO{BTS_KICK_FAM}.Monitor.HWUnits         = 'Counts';           
AO{BTS_KICK_FAM}.Monitor.PhysicsUnits    = 'K2';

AO{BTS_KICK_FAM}.Setpoint.Mode           = 'SIMULATOR';
AO{BTS_KICK_FAM}.Setpoint.DataType       = 'Scalar';
AO{BTS_KICK_FAM}.Setpoint.Units          = 'Hardware';
AO{BTS_KICK_FAM}.Setpoint.HWUnits        = 'Counts';           
AO{BTS_KICK_FAM}.Setpoint.PhysicsUnits   = 'K2';

%common              monitor             setpoint    stat devlist elem  ScaleFact   range   tol
btsKick={
 'KS1       '    'KS1412-01:HV        '     'KS1412-01:HV        '  1   [1 ,1]  1     1.0       [0, 4.0]        2.00  ; ...
 'KS1Time   '    'K1412-01:delay:ns   '     'K1412-01:delay:ns   '  1   [1 ,2]  2     1.0       [0, 16777215] 2.00  ; ...
 'KS1OnOff  '    'KS1412-01:onoff     '     'KS1412-01:onoff     '  1   [1 ,3]  3     1.0       [0, 1]        2.00  ; ...
 'KS1Thyra  '    'KS1412-01:thyratron '     'KS1412-01:thyratron '  1   [1 ,4]  4     1.0       [0, 1]        2.00  ; ... 
 'KS2       '    'KS1401-01:HV        '     'KS1401-01:HV        '  1   [2 ,1]  5     1.0       [0, 4.0]        2.00  ; ...
 'KS2Time   '    'K1401-01:delay:ns   '     'K1401-01:delay:ns   '  1   [2 ,2]  6     1.0       [0, 16777215] 2.00  ; ...
 'KS2OnOff  '    'KS1401-01:onoff     '     'KS1401-01:onoff     '  1   [2 ,3]  7     1.0       [0, 1]        2.00  ; ...
 'KS2Thyra  '    'KS1401-01:thyratron '     'KS1401-01:thyratron '  1   [2 ,4]  8     1.0       [0, 1]        2.00  ; ... 
 'KS3       '    'KS1401-02:HV        '     'KS1401-02:HV        '  1   [3 ,1]  9      1.0       [0, 4.0]        2.00  ; ...
 'KS3Time   '    'K1401-02:delay:ns   '     'K1401-02:delay:ns   '  1   [3 ,2]  10     1.0       [0, 16777215] 2.00  ; ...
 'KS3OnOff  '    'KS1401-02:onoff     '     'KS1401-02:onoff     '  1   [3 ,3]  11     1.0       [0, 1]        2.00  ; ...
 'KS3Thyra  '    'KS1401-02:thyratron '     'KS1401-02:thyratron '  1   [3 ,4]  12     1.0       [0, 1]        2.00  ; ... 
 'KS4       '    'KS1402-01:HV        '     'KS1402-01:HV        '  1   [4 ,1]  13     1.0       [0, 4.0]        2.00  ; ...
 'KS4Time   '    'K1402-01:delay:ns   '     'K1402-01:delay:ns   '  1   [4 ,2]  14     1.0       [0, 16777215] 2.00  ; ...
 'KS4OnOff  '    'KS1402-01:onoff     '     'KS1402-01:onoff     '  1   [4 ,3]  15     1.0       [0, 1]        2.00  ; ...
 'KS4Thyra  '    'KS1402-01:thyratron '     'KS1402-01:thyratron '  1   [4 ,4]  16     1.0       [0, 1]        2.00  ; ... 
};
 

HW2Physics =  42.9572 / 5112170;  % Dimad / DAC (DAC value of 5112170 is wrong!!!)   Dimad value may be wrong too!!!) 

for ii=1:size(btsKick,1)
name=btsKick{ii,1};      AO{BTS_KICK_FAM}.CommonNames(ii,:)           = name;            
name=btsKick{ii,2};      AO{BTS_KICK_FAM}.Monitor.ChannelNames(ii,:)  = name;
name=btsKick{ii,3};      AO{BTS_KICK_FAM}.Setpoint.ChannelNames(ii,:) = name;     
val =btsKick{ii,4};      AO{BTS_KICK_FAM}.Status(ii,1)                  = val;
val =btsKick{ii,5};      AO{BTS_KICK_FAM}.DeviceList(ii,:)            = val;
val =btsKick{ii,6};      AO{BTS_KICK_FAM}.ElementList(ii,1)           = val;
val =btsKick{ii,7};      AO{BTS_KICK_FAM}.Setpoint.Range(ii,:)        = [-inf inf];
val =btsKick{ii,8};      AO{BTS_KICK_FAM}.Setpoint.Tolerance(ii,1)    = ToleranceInCountsBTS;

AO{BTS_KICK_FAM}.Monitor.HW2PhysicsParams(ii,:)  = HW2Physics;          
AO{BTS_KICK_FAM}.Monitor.Physics2HWParams(ii,:)  = 1 / HW2Physics;

AO{BTS_KICK_FAM}.Setpoint.HW2PhysicsParams(ii,:) = HW2Physics;           
AO{BTS_KICK_FAM}.Setpoint.Physics2HWParams(ii,:) = 1 / HW2Physics;

AO{BTS_KICK_FAM}.Monitor.Handles(ii,1)  = NaN;
AO{BTS_KICK_FAM}.Setpoint.Handles(ii,1) = NaN;

end

AO{BTS_KICK_FAM}.On.Mode = 'Online';
AO{BTS_KICK_FAM}.On.DataType         = 'Scalar';
AO{BTS_KICK_FAM}.On.Units            = 'Hardware';
AO{BTS_KICK_FAM}.On.HWUnits          = '';           
AO{BTS_KICK_FAM}.On.PhysicsUnits     = '';
AO{BTS_KICK_FAM}.On.HW2PhysicsParams = 1;
AO{BTS_KICK_FAM}.On.Physics2HWParams = 1;

for i=1:4
   AO{BTS_KICK_FAM}.On.Handles(i,1) = NaN;
end
AO{BTS_KICK_FAM}.On.ChannelNames(1,:) = 'KS1412-01:onoff';
AO{BTS_KICK_FAM}.On.ChannelNames(2,:) = 'KS1401-01:onoff';
AO{BTS_KICK_FAM}.On.ChannelNames(3,:) = 'KS1401-02:onoff';
AO{BTS_KICK_FAM}.On.ChannelNames(4,:) = 'KS1402-01:onoff';



%BTS Scrapers
AO{BTS_SCRAPERS_FAM}.FamilyName              = 'BTSSCRAPE';
AO{BTS_SCRAPERS_FAM}.FamilyType              = 'SCRAPE';
AO{BTS_SCRAPERS_FAM}.MemberOf                = {'MachineConfig'; 'SCRAPER';};

AO{BTS_SCRAPERS_FAM}.Monitor.Mode            = 'SIMULATOR';
AO{BTS_SCRAPERS_FAM}.Monitor.DataType        = 'Scalar';
AO{BTS_SCRAPERS_FAM}.Monitor.Units           = 'Hardware';
AO{BTS_SCRAPERS_FAM}.Monitor.HWUnits         = 'Counts';           
AO{BTS_SCRAPERS_FAM}.Monitor.PhysicsUnits    = 'K2';

AO{BTS_SCRAPERS_FAM}.Setpoint.Mode           = 'SIMULATOR';
AO{BTS_SCRAPERS_FAM}.Setpoint.DataType       = 'Scalar';
AO{BTS_SCRAPERS_FAM}.Setpoint.Units          = 'Hardware';
AO{BTS_SCRAPERS_FAM}.Setpoint.HWUnits        = 'Counts';           
AO{BTS_SCRAPERS_FAM}.Setpoint.PhysicsUnits   = 'K2';

%common              monitor             setpoint    stat devlist elem  ScaleFact   range   tol
btsScraper={
 'SCP1       '    'SCP1401-01:mm:fbk  '     'SCP1401-01:mm      '  1   [1 ,1]  1     1.0       [0, 100]        2.00  ; ...
 'SCP2       '    'SCP1401-02:mm:fbk  '     'SCP1401-02:mm      '  1   [2 ,1]  2     1.0       [0, 100]        2.00  ; ...     
 'SCP3       '    'SCP1401-03:mm:fbk  '     'SCP1401-03:mm      '  1   [3 ,1]  3     1.0       [0, 100]        2.00  ; ... 
};
 

HW2Physics =  1;

for ii=1:size(btsScraper,1)
name=btsScraper{ii,1};      AO{BTS_SCRAPERS_FAM}.CommonNames(ii,:)           = name;            
name=btsScraper{ii,2};      AO{BTS_SCRAPERS_FAM}.Monitor.ChannelNames(ii,:)  = name;
name=btsScraper{ii,3};      AO{BTS_SCRAPERS_FAM}.Setpoint.ChannelNames(ii,:) = name;     
val =btsScraper{ii,4};      AO{BTS_SCRAPERS_FAM}.Status(ii,1)                  = val;
val =btsScraper{ii,5};      AO{BTS_SCRAPERS_FAM}.DeviceList(ii,:)            = val;
val =btsScraper{ii,6};      AO{BTS_SCRAPERS_FAM}.ElementList(ii,1)           = val;
val =btsScraper{ii,7};      AO{BTS_SCRAPERS_FAM}.Setpoint.Range(ii,:)        = [-inf inf];
val =btsScraper{ii,8};      AO{BTS_SCRAPERS_FAM}.Setpoint.Tolerance(ii,1)    = ToleranceInCountsBTS;

AO{BTS_SCRAPERS_FAM}.Monitor.HW2PhysicsParams(ii,:)  = HW2Physics;          
AO{BTS_SCRAPERS_FAM}.Monitor.Physics2HWParams(ii,:)  = 1 / HW2Physics;

AO{BTS_SCRAPERS_FAM}.Setpoint.HW2PhysicsParams(ii,:) = HW2Physics;           
AO{BTS_SCRAPERS_FAM}.Setpoint.Physics2HWParams(ii,:) = 1 / HW2Physics;

AO{BTS_SCRAPERS_FAM}.Monitor.Handles(ii,1)  = NaN;
AO{BTS_SCRAPERS_FAM}.Setpoint.Handles(ii,1) = NaN;
end




%SR Chicane magnets
AO{SR_CHICANES_FAM}.FamilyName              = 'CHICANES';
AO{SR_CHICANES_FAM}.FamilyType              = 'CHICANE';
AO{SR_CHICANES_FAM}.MemberOf                = {'MachineConfig'; 'CHICANE';};

AO{SR_CHICANES_FAM}.Monitor.Mode            = 'SIMULATOR';
AO{SR_CHICANES_FAM}.Monitor.DataType        = 'Scalar';
AO{SR_CHICANES_FAM}.Monitor.Units           = 'Hardware';
AO{SR_CHICANES_FAM}.Monitor.HWUnits         = 'Counts';           
AO{SR_CHICANES_FAM}.Monitor.PhysicsUnits    = 'K2';

AO{SR_CHICANES_FAM}.Setpoint.Mode           = 'SIMULATOR';
AO{SR_CHICANES_FAM}.Setpoint.DataType       = 'Scalar';
AO{SR_CHICANES_FAM}.Setpoint.Units          = 'Hardware';
AO{SR_CHICANES_FAM}.Setpoint.HWUnits        = 'Counts';           
AO{SR_CHICANES_FAM}.Setpoint.PhysicsUnits   = 'K2';

%common              monitor             setpoint    stat devlist elem  ScaleFact   range   tol
srChicane={
 'BID1101    '    'BID1411-01:adc  '     'BID1411-01:dac  '  1   [11 ,1]  1     1.0       [0, 8388607]        2.00  ; ...
 'BID1102    '    'BID1411-02:adc  '     'BID1411-02:dac  '  1   [11 ,2]  2     1.0       [0, 8388607]        2.00  ; ...     
 'BID1103    '    'BID1411-03:adc  '     'BID1411-03:dac  '  1   [11 ,3]  3     1.0       [0, 8388607]        2.00  ; ... 
};
 

HW2Physics =  1;

for ii=1:size(srChicane,1)
name=srChicane{ii,1};      AO{SR_CHICANES_FAM}.CommonNames(ii,:)           = name;            
name=srChicane{ii,2};      AO{SR_CHICANES_FAM}.Monitor.ChannelNames(ii,:)  = name;
name=srChicane{ii,3};      AO{SR_CHICANES_FAM}.Setpoint.ChannelNames(ii,:) = name;     
val =srChicane{ii,4};      AO{SR_CHICANES_FAM}.Status(ii,1)                  = val;
val =srChicane{ii,5};      AO{SR_CHICANES_FAM}.DeviceList(ii,:)            = val;
val =srChicane{ii,6};      AO{SR_CHICANES_FAM}.ElementList(ii,1)           = val;
val =srChicane{ii,7};      AO{SR_CHICANES_FAM}.Setpoint.Range(ii,:)        = [-inf inf];
val =srChicane{ii,8};      AO{SR_CHICANES_FAM}.Setpoint.Tolerance(ii,1)    = ToleranceInCountsBTS;

AO{SR_CHICANES_FAM}.Monitor.HW2PhysicsParams(ii,:)  = HW2Physics;          
AO{SR_CHICANES_FAM}.Monitor.Physics2HWParams(ii,:)  = 1 / HW2Physics;

AO{SR_CHICANES_FAM}.Setpoint.HW2PhysicsParams(ii,:) = HW2Physics;           
AO{SR_CHICANES_FAM}.Setpoint.Physics2HWParams(ii,:) = 1 / HW2Physics;

AO{SR_CHICANES_FAM}.Monitor.Handles(ii,1)  = NaN;
AO{SR_CHICANES_FAM}.Setpoint.Handles(ii,1) = NaN;
end
%end chicanes


% save AO
setao(cell2field(AO));


% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
setoperationalmode(OperationalMode);
AO = getao;

