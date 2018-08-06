function [DFE, IP, Prefix, File] = bpm_afeinfo(AFE, Rev)
%BPM_AFEINFO 
%  [DFE, IP, Prefix, File] = bpm_afeinfo(AFE, Rev)
%

% Written by Greg Portmann

if nargin < 2
    error('BPM AFE number and revision number are required inputs.');
end

if Rev == 2
    % Rev2
    %  AFE DFE         IP        EPICS Prefix   Calibration File Name
    AFE_Table = {
        % Test BPM
        0,  0, '131.243.89.117', 'Test:BPM1', 'Attenuation_Unity';
        
        %%%%%%%%%%%%%%%%
        % Booster BPMs %
        %%%%%%%%%%%%%%%%
        
        % Calibrate with an extra 6 db on the NSLS2 PT generator
                
        %0,  0, '131.243.89.117', 'Test:BPM1', 'Attenuation_Unity';
        %0,  0, '131.243.89.117', 'Test:BPM1', 'Attenuation_Unity';
        
        
        %%%%%%%%%%%%%%%%%%%%%%
        % Transport Line BPM %
        %%%%%%%%%%%%%%%%%%%%%%
        
        % Spares
        35, 39, '131.243.89.117', 'Test:BPM1', 'Attenuation_AFE2_Rev2_SN035_2016-01-22_13-48-49';
        37, 36, '131.243.89.117', 'Test:BPM1', 'Attenuation_Unity';  % In 46 lab.  Needs to be calibrated.

        % APEX
        25, 20, '131.243.89.117', 'Test:BPM1', 'Attenuation_AFE2_Rev2_SN025_2016-01-13_22-13-01';        
        28, 11, '131.243.89.117', 'Test:BPM1', 'Attenuation_AFE2_Rev2_SN028_2016-01-13_16-06-23';
        34, 34, '131.243.89.117', 'Test:BPM1', 'Attenuation_AFE2_Rev2_SN034_2016-01-13_12-36-58';
        38, 61, '131.243.89.117', 'Test:BPM1', 'Attenuation_AFE2_Rev2_SN038_2016-01-15_16-54-24';

        % GTL, LN
        30, 29, '131.243.89.160', 'GTL:BPM1',  'Attenuation_AFE2_Rev2_SN030_2016-01-12_23-28-20';
        31, 18, '131.243.89.161', 'GTL:BPM2',  'Attenuation_AFE2_Rev2_SN031_2016-01-12_17-23-17';
        32, 28, '131.243.89.158', 'LN:BPM1',   'Attenuation_AFE2_Rev2_SN032_2016-01-13_11-15-56';
        33, 60, '131.243.89.159', 'LN:BPM2',   'Attenuation_AFE2_Rev2_SN033_2016-01-08_10-31-27';

        % LTB
        40, 40, '131.243.89.117', 'LTB:BPM1', 'Attenuation_AFE2_Rev2_SN040_2016-01-22_10-54-58';
%%% !!!  41, 50, '131.243.89.117', 'LTB:BPM2', 'Attenuation_AFE2_Rev2_SN041_2016-01-22_17-28-20';       % on cal rack   
        41, 50, '131.243.89.117', 'Test:BPM1', 'Attenuation_AFE2_Rev2_SN041_2016-01-22_17-28-20';       % on cal rack   
        43, 47, '131.243.89.117', 'LTB:BPM3', 'Attenuation_AFE2_Rev2_SN043_2016-01-19_20-58-36';
        48, 41, '131.243.89.117', 'LTB:BPM4', 'Attenuation_AFE2_Rev2_SN048_2016-01-21_13-40-29';
        49, 38, '131.243.89.117', 'LTB:BPM5', 'Attenuation_AFE2_Rev2_SN049_2016-01-21_18-35-53';
        51, 32, '131.243.89.117', 'LTB:BPM6', 'Attenuation_AFE2_Rev2_SN051_2016-01-21_02-07-24';      
        52, 49, '131.243.89.117', 'LTB:BPM7', 'Attenuation_AFE2_Rev2_SN052_2016-01-19_11-33-24';

        % BTS
        42, 30, '131.243.89.118', 'BTS:BPM1',  'Attenuation_AFE2_Rev2_SN042_2016-01-11_14-49-43';
        46, 31, '131.243.89.119', 'BTS:BPM2',  'Attenuation_AFE2_Rev2_SN046_2016-01-11_13-48-39';
        29,  7, '131.243.89.124', 'BTS:BPM3',  'Attenuation_AFE2_Rev2_SN029_2016-01-11_12-57-32';
        45, 44, '131.243.89.129', 'BTS:BPM4',  'Attenuation_AFE2_Rev2_SN045_2016-01-11_12-23-43';
        26, 12, '131.243.89.134', 'BTS:BPM5',  'Attenuation_AFE2_Rev2_SN026_2016-01-10_21-57-01';
        39, 43, '131.243.89.139', 'BTS:BPM6',  'Attenuation_AFE2_Rev2_SN039_2016-01-08_22-02-51';
        };
    
elseif Rev == 4
    % Rev4
    
    % /remote/als-sw/epics/R3.14.12/modules/instrument/ALS_BPM/R1-03/FPGA
    
    %cmd = 'tftp 131.243.95.65 -v -m binary -c put Attenuation_AFE2_Rev4_SN017_2015-10-15_23-20-41.csv Attenuation.csv'
    %cmd = 'tftp 131.243.95.65 -v -m binary -c put Attenuation_Unity.csv Attenuation.csv'
    
    %S01BPM4_IP = '131.243.95.18';
    %IP = '131.243.95.68'; bpm_writefile_attn
    %IP = '131.243.95.109';  % SR12C:BPM7
    
    %File = 'Attenuation_AFE2_Rev4_SN017_2015-10-15_23-20-41';
    %%File = 'Attenuation_AFE2_Rev4_SN017_2015-10-17_23-37-21';
    %File = 'Attenuation_AFE2_Rev4_SN018_2015-10-18_23-08-34';
    
    %AFE = 15;
    %IP = '131.243.95.96';
    %File = 'Attenuation_AFE2_Rev4_SN015_2015-10-19_00-01-45';
    
    %File = 'Attenuation_AFE2_Rev4_SN014_2015-10-19_00-51-28';
    %File = 'Attenuation_AFE2_Rev4_SN011_2015-10-19_09-08-50';  11 7
    
    %AFE = 17;
    %IP = '131.243.95.109';
    %File = 'Attenuation_AFE2_Rev4_SN017_2015-10-17_23-37-21';
    
    AFE_Table = {};
end

AFE_List = cell2mat(AFE_Table(:,1));
i = findrowindex(AFE, AFE_List);
DFE    = AFE_Table{i,2};
IP     = AFE_Table{i,3};
Prefix = AFE_Table{i,4};
File   = AFE_Table{i,5};

if ~strcmpi(File(end-3:end), '.csv');
    File = [File, '.csv'];
end


