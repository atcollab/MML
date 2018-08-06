function [MeasMainPos, MeasBkgrPos] = idReadMeasElecBeamBPM(folder, mode, indMeasGap, x_or_z)

MeasMain_LH = cellstr(['G15_5_P0_C0_a_2006-09-14_14-47-08'; 
                       'G18_P0_2006-09-14_12-02-30       '; 
                       'G20_P0_a_2006-09-14_11-56-30     '; 
                       'G25_P0_2006-09-14_11-32-27       '; 
                       'G30_P0_2006-09-14_11-25-30       '; 
                       'G50_P0_2006-09-14_11-21-40       '; 
                       'G80_P0_2006-09-14_11-07-01       '; 
                       'G110_P0_2006-09-14_10-57-10      ']);
MeasBkgr_LH = cellstr(['G250_P0_C0_a_2006-09-14_14-51-53'; 
                       'G250_P0_2006-09-14_10-55-27     '; 
                       'G250_P0_2006-09-14_10-55-27     '; 
                       'G250_P0_2006-09-14_10-55-27     '; 
                       'G250_P0_2006-09-14_10-55-27     '; 
                       'G250_P0_2006-09-14_10-55-27     '; 
                       'G250_P0_2006-09-14_10-55-27     '; 
                       'G250_P0_2006-09-14_10-55-27     ']);
%MeasGaps_LH = [15.5, 18, 20, 25, 30, 50, 80, 110];
%MeasPhases_LH = [0, 0, 0, 0, 0, 0, 0, 0];

MeasMain_LV = cellstr(['G15_5_P40_C0_a_2006-09-14_17-36-44'; 
                       'G18_P40_C0_a_2006-09-14_17-25-22  '; 
                       'G20_P40_C0_b_2006-09-14_17-16-12  '; 
                       'G25_P40_C0_a_2006-09-14_17-07-23  '; 
                       'G30_P40_C0_a_2006-09-14_16-56-37  '; 
                       'G50_P40_C0_a_2006-09-14_16-53-50  '; 
                       'G80_P40_C0_a_2006-09-14_16-47-10  '; 
                       'G250_P44_C0_a_2006-09-14_16-39-59 ']);
MeasBkgr_LV = cellstr(['G250_P40_C0_a_2006-09-14_17-29-23'; 
                       'G250_P40_C0_a_2006-09-14_17-29-23'; 
                       'G250_P40_C0_c_2006-09-14_17-21-35'; 
                       'G250_P40_C0_b_2006-09-14_17-11-00'; 
                       'G250_P40_C0_b_2006-09-14_17-11-00'; 
                       'G250_P40_C0_b_2006-09-14_17-11-00'; 
                       'G250_P44_C0_a_2006-09-14_16-30-28'; 
                       'G250_P44_C0_a_2006-09-14_16-30-28']);
%MeasGaps_LV = [15.5, 18, 20, 25, 30, 50, 80, 110];
%MeasPhases_LV = [40, 40, 40, 40, 40, 40, 40, 40];

MeasMain_HE = cellstr(['G15_5_P20_C0_a_2006-09-14_19-19-41'; 
                       'G18_P20_C0_a_2006-09-14_20-51-24  '; 
                       'G20_P30_C0_a_2006-09-14_20-47-06  '; 
                       'G25_P30_C0_a_2006-09-14_20-32-56  '; 
                       'G30_P30_C0_a_2006-09-14_20-23-33  '; 
                       'G50_P30_C0_a_2006-09-14_20-02-20  '; 
                       'G80_P30_C0_a_2006-09-14_20-05-51  '; 
                       'G110_P30_C0_a_2006-09-14_20-19-06 ']);
MeasBkgr_HE = cellstr(['G250_P0_C0_a_2006-09-14_19-29-51'; 
                       'G250_P0_C0_a_2006-09-14_20-56-58'; 
                       'G250_P0_C0_a_2006-09-14_20-56-58'; 
                       'G250_P0_C0_a_2006-09-14_20-37-40'; 
                       'G250_P0_C0_a_2006-09-14_20-27-56'; 
                       'G250_P0_C0_a_2006-09-14_20-14-55'; 
                       'G250_P0_C0_a_2006-09-14_20-14-55'; 
                       'G250_P0_C0_a_2006-09-14_20-14-55']);
%MeasGaps_HE = [15.5, 18, 20, 25, 30, 50, 80, 110];
%MeasPhases_HE = [20, 20, 30, 30, 30, 30, 30, 30];

MeasMainNameAr = MeasMain_LH;
MeasBkgrNameAr = MeasBkgr_LH;
if strcmp(mode, 'LV') ~= 0
    MeasMainNameAr = MeasMain_LV;
    MeasBkgrNameAr = MeasBkgr_LV;
end
if strcmp(mode, 'HE') ~= 0
    MeasMainNameAr = MeasMain_HE;
    MeasBkgrNameAr = MeasBkgr_HE;
end

dirStart = pwd;
if strcmp(folder, '') == 0
    cd(folder);
end

%MeasFileName = char(MeasMainNameAr(indMeasGap));
ElecBeamDataMain = load(char(MeasMainNameAr(indMeasGap)));
ElecBeamDataBkgr = load(char(MeasBkgrNameAr(indMeasGap)));
cd(dirStart);

if strcmp(x_or_z, 'x') ~= 0
	MeasMainPos = ElecBeamDataMain.X;
    MeasBkgrPos = ElecBeamDataBkgr.X;
end
if strcmp(x_or_z, 'z') ~= 0
	MeasMainPos = ElecBeamDataMain.Z;
    MeasBkgrPos = ElecBeamDataBkgr.Z;
end
