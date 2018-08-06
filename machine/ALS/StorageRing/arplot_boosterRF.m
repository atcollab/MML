function arplot_boosterRF(monthStr, days, year1, month2Str, days2, year2)
% arplot_boosterRF(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
% 
% Plots a whole bunch of Booster RF related archived data.
%
% Example #1:  arplot_boosterRF('January',22:24,1998);
%              plots data from 1/22, 1/23, and 1/24 in 1998
%
% Example #2:  arplot_boosterRF('January',28:31,1998,'February',1:4,1998);
%              plots data from the last 4 days in Jan. and the first 4 days in Feb.
%
% See also arplot arplot_sr_report arplot_sbm
% 
% Written by Greg Portmann & Tom Scarvie


LeftGraphColor = 'b';
RightGraphColor = 'r';
FFFlag = 1;


% Inputs
if nargin < 2
   error('ARPLOTS:  You need at least two input arguments.');
elseif nargin == 2
   tmp = clock;
   year1 = tmp(1);
   monthStr2 = [];
   days2 = [];
   year2 = [];
elseif nargin == 3
   monthStr2 = [];
   days2 = [];
   year2 = [];
elseif nargin == 4
   error('ARPLOTS:  You need 2, 3, 5, or 6 input arguments.');
elseif nargin == 5
   tmp = clock;
   year2 = tmp(1);
elseif nargin == 6
else
   error('ARPLOTS:  Inputs incorrect.');
end


arglobal


t=[];

GapEnableNames = family2channel('ID','GapEnable');

dcct=[];
i_cam=[];
lifetime=[];
lcw=[];
gev=[];
IDgap=[];
GapEnable=[];
FF7Enable=[];

%initialize BR RF variables
Power_RF_fwd=[];
Power_RF_ref=[];
Power_drive=[];
HV_setpoint=[];
Beam_volts=[];
Beam_current=[];
Bias_volts=[];
Bias_current=[];
Heater_Voltage=[];
Heater_current=[];
Focus_voltage=[];
Focus_current=[];
VacIon_voltage=[];
VacIon_current=[];
Thy_Grid1_volts=[];
Thy_Grid2_volts=[];
Thy_heater_volts=[];
Thy_heater_current=[];
Body_Current=[];
Temp_HV_enclose=[];
Temp_IOT_enclose=[];
Temp_IOT_cooling=[];
Temp_ceramic_output=[];

BR_CLDFWD=[];
BR_WGREV=[];
BR_WGFWD=[];
BR_RFCONT=[];
BR_PHSCON_AM=[];
BR_PHSCON_AC=[];
BR_TUNPOS=[];
BR_TUNERR=[];
BR_CAVTMP=[];
BR_LCWTMP=[];
BR_CLDFLW=[];
BR_CIRFLW=[];
BR_SLDTMP=[];
BR_CIRTMP=[];
BR_SLDFLW=[];
BR_CLDTMP=[];
BR_CAVFLW=[];
BR_WINFLW=[];
BR_TUNFLW=[];

if isempty(days2)
   if length(days) == [1]
      month  = mon2num(monthStr);
      NumDays = length(days);
      StartDayStr = [monthStr, ' ', num2str(days(1)),', ', num2str(year1)];
      EndDayStr =   [''];
      titleStr = [StartDayStr];
      DirectoryDate = sprintf('%d-%02d-%02d', year1, month, days(1)); 
   else
      month  = mon2num(monthStr);
      NumDays = length(days);
      StartDayStr = [monthStr, ' ', num2str(days(1)),', ', num2str(year1)];
      EndDayStr =   [monthStr, ' ', num2str(days(length(days))),', ', num2str(year1)];
      titleStr = [StartDayStr,' to ', EndDayStr,' (', num2str(NumDays),' days)'];
      DirectoryDate = sprintf('%d-%02d-%02d to %d-%02d-%02d', year1, month, days(1), year1, month, days(end)); 
   end
else
   month  = mon2num(monthStr);
   month2 = mon2num(month2Str);
   NumDays = length(days) + length(days2);
   StartDayStr = [monthStr, ' ', num2str(days(1)),', ', num2str(year1)];
   EndDayStr =   [month2Str, ' ', num2str(days2(length(days2))),', ', num2str(year2)];
   titleStr = [StartDayStr,' to ', EndDayStr,' (', num2str(NumDays),' days)'];
   DirectoryDate = sprintf('%d-%02d-%02d to %d-%02d-%02d', year1, month, days(1), year2, month2, days2(end));
end

StartDay = days(1);
EndDay = days(length(days));

tic;
for day = days
      %   try
      year1str = num2str(year1);
      if year1 < 2000
         year1str = year1str(3:4);
         FileName = sprintf('%2s%02d%02d', year1str, month, day);
      else
         FileName = sprintf('%4s%02d%02d', year1str, month, day);
      end
      arread(FileName, FFFlag);
      
      [y1, igev] = arselect('cmm:sr_energy');
      gev = [gev y1];

      [y1, ilifetime] = arselect('SR05W___DCCT2__AM00');
      lifetime = [lifetime  y1];

      % ID vertical gap
      IDlist = family2dev('ID');
      [y1, i, iNotFound] = arselect(family2channel('ID','Monitor',IDlist));
      y1(iNotFound,:) = [];
      IDlist(iNotFound,:) = [];
      IDgap = [IDgap  y1];
      IDLegend = mat2cell(ARChanNames(i,3:5),ones(length(i),1),3);
      IDLegend = strcat(IDLegend,ARChanNames(i,12));


      if FFFlag
          GapEnable = [GapEnable arselect(GapEnableNames)];
      
          [y1,i] = arselect('sr07u:FFEnable:bi');
          FF7Enable = [FF7Enable  y1];
      end
     
		% BR RF parameters
      [y1, i] = arselect('Power_RF_fwd');
		Power_RF_fwd=[Power_RF_fwd y1];

		[y1, i] = arselect('Power_RF_ref');
		Power_RF_ref=[Power_RF_ref y1];

		[y1, i] = arselect('Power_drive');
		Power_drive=[Power_drive y1];

		[y1, i] = arselect('HV_setpoint');
		HV_setpoint=[HV_setpoint y1];

		[y1, i] = arselect('Beam_volts');
		Beam_volts=[Beam_volts y1];

		[y1, i] = arselect('Beam_current');
		Beam_current=[Beam_current y1];

		[y1, i] = arselect('Bias_volts');
		Bias_volts=[Bias_volts y1];

		[y1, i] = arselect('Bias_current');
		Bias_current=[Bias_current y1];

		[y1, i] = arselect('Heater_Voltage');
		Heater_Voltage=[Heater_Voltage y1];

		[y1, i] = arselect('Heater_current');
		Heater_current=[Heater_current y1];

		[y1, i] = arselect('Focus_voltage');
		Focus_voltage=[Focus_voltage y1];

		[y1, i] = arselect('Focus_current');
		Focus_current=[Focus_current y1];

		[y1, i] = arselect('VacIon_voltage');
		VacIon_voltage=[VacIon_voltage y1];

		[y1, i] = arselect('VacIon_current');
		VacIon_current=[VacIon_current y1];

		[y1, i] = arselect('Thy_Grid1_volts');
		Thy_Grid1_volts=[Thy_Grid1_volts y1];

		[y1, i] = arselect('Thy_Grid2_volts');
		Thy_Grid2_volts=[Thy_Grid2_volts y1];

		[y1, i] = arselect('Thy_heater_volts');
		Thy_heater_volts=[Thy_heater_volts y1];

		[y1, i] = arselect('Thy_heater_current');
		Thy_heater_current=[Thy_heater_current y1];

		[y1, i] = arselect('Body_Current');
		Body_Current=[Body_Current y1];

		[y1, i] = arselect('Temp_HV_enclose');
		Temp_HV_enclose=[Temp_HV_enclose y1];

		[y1, i] = arselect('Temp_IOT_enclose');
		Temp_IOT_enclose=[Temp_IOT_enclose y1];

		[y1, i] = arselect('Temp_IOT_cooling');
		Temp_IOT_cooling=[Temp_IOT_cooling y1];

		[y1, i] = arselect('Temp_ceramic_output');
		Temp_ceramic_output=[Temp_ceramic_output y1];

 	   [y1, i] = arselect('BR4_____CLDFWD_AM00');
	   BR_CLDFWD=[BR_CLDFWD y1];

	   [y1, i] = arselect('BR4_____WGREV__AM01');
	   BR_WGREV=[BR_WGREV y1];

	   [y1, i] = arselect('BR4_____WGFWD__AM02');
	   BR_WGFWD=[BR_WGFWD y1];

	   [y1, i] = arselect('BR4_____RFCONT_AM01');
	   BR_RFCONT=[BR_RFCONT y1];
 
	   [y1, i] = arselect('BR4_____PHSCON_AM00');
	   BR_PHSCON_AM=[BR_PHSCON_AM y1];

	   [y1, i] = arselect('BR4_____PHSCON_AC00');
	   BR_PHSCON_AC=[BR_PHSCON_AC y1];

	   [y1, i] = arselect('BR4_____TUNPOS_AM00');
	   BR_TUNPOS=[BR_TUNPOS y1];

	   [y1, i] = arselect('BR4_____TUNERR_AM02');
	   BR_TUNERR=[BR_TUNERR y1];

	   [y1, i] = arselect('BR4_____CAVTMP_AM03');
	   BR_CAVTMP=[BR_CAVTMP y1];

	   [y1, i] = arselect('BR4_____LCWTMP_AM03');
	   BR_LCWTMP=[BR_LCWTMP y1];

	   [y1, i] = arselect('BR4_____CLDFLW_AM01');
	   BR_CLDFLW=[BR_CLDFLW y1];

	   [y1, i] = arselect('BR4_____CIRFLW_AM02');
	   BR_CIRFLW=[BR_CIRFLW y1];

	   [y1, i] = arselect('BR4_____SLDTMP_AM01');
	   BR_SLDTMP=[BR_SLDTMP y1];

	   [y1, i] = arselect('BR4_____CIRTMP_AM03');
	   BR_CIRTMP=[BR_CIRTMP y1];

	   [y1, i] = arselect('BR4_____SLDFLW_AM00');
	   BR_SLDFLW=[BR_SLDFLW y1];

	   [y1, i] = arselect('BR4_____CLDTMP_AM03');
	   BR_CLDTMP=[BR_CLDTMP y1];

	   [y1, i] = arselect('BR4_____CAVFLW_AM00');
	   BR_CAVFLW=[BR_CAVFLW y1];

	   [y1, i] = arselect('BR4_____WINFLW_AM01');
	   BR_WINFLW=[BR_WINFLW y1];

	   [y1, i] = arselect('BR4_____TUNFLW_AM02');
	   BR_TUNFLW=[BR_TUNFLW y1];

		t = [t  ARt+(day-StartDay)*24*60*60]; 

%    catch
%       fprintf('  Error reading archived data file.\n');
%       fprintf('  %s will be ignored.\n', FileName);
%    end
   
   disp(' ');
end


if ~isempty(days2)
   
   StartDay = days2(1);
   EndDay = days2(length(days2));
   
   for day = days2
      try
         year2str = num2str(year2);
         if year2 < 2000
            year2str = year2str(3:4);
            FileName = sprintf('%2s%02d%02d', year2str, month2, day);
         else
            FileName = sprintf('%4s%02d%02d', year2str, month2, day);
         end
         arread(FileName, FFFlag);
         
         [y1, igev] = arselect('cmm:sr_energy');
         gev = [gev y1];
         
         [y1, ilifetime] = arselect('SR05W___DCCT2__AM00');
         lifetime = [lifetime  y1];
         
         % ID vertical gap
         [y1, i, iNotFound] = arselect(family2channel('ID','Monitor',IDlist));
         y1(iNotFound,:) = [];
         IDlist(iNotFound,:) = [];
         IDgap = [IDgap  y1];

         if FFFlag
             GapEnable = [GapEnable arselect(GapEnableNames)];

             [y1,i]=arselect('sr07u:FFEnable:bi');
             FF7Enable =[FF7Enable  y1];
         end
         
			% BR RF parameters
			[y1, i] = arselect('Power_RF_fwd');
			Power_RF_fwd=[Power_RF_fwd y1];

			[y1, i] = arselect('Power_RF_ref');
			Power_RF_ref=[Power_RF_ref y1];

			[y1, i] = arselect('Power_drive');
			Power_drive=[Power_drive y1];

			[y1, i] = arselect('HV_setpoint');
			HV_setpoint=[HV_setpoint y1];

			[y1, i] = arselect('Beam_volts');
			Beam_volts=[Beam_volts y1];

			[y1, i] = arselect('Beam_current');
			Beam_current=[Beam_current y1];

			[y1, i] = arselect('Bias_volts');
			Bias_volts=[Bias_volts y1];

			[y1, i] = arselect('Bias_current');
			Bias_current=[Bias_current y1];

			[y1, i] = arselect('Heater_Voltage');
			Heater_Voltage=[Heater_Voltage y1];

			[y1, i] = arselect('Heater_current');
			Heater_current=[Heater_current y1];

			[y1, i] = arselect('Focus_voltage');
			Focus_voltage=[Focus_voltage y1];

			[y1, i] = arselect('Focus_current');
			Focus_current=[Focus_current y1];

			[y1, i] = arselect('VacIon_voltage');
			VacIon_voltage=[VacIon_voltage y1];

			[y1, i] = arselect('VacIon_current');
			VacIon_current=[VacIon_current y1];

			[y1, i] = arselect('Thy_Grid1_volts');
			Thy_Grid1_volts=[Thy_Grid1_volts y1];

			[y1, i] = arselect('Thy_Grid2_volts');
			Thy_Grid2_volts=[Thy_Grid2_volts y1];

			[y1, i] = arselect('Thy_heater_volts');
			Thy_heater_volts=[Thy_heater_volts y1];

			[y1, i] = arselect('Thy_heater_current');
			Thy_heater_current=[Thy_heater_current y1];

			[y1, i] = arselect('Body_Current');
			Body_Current=[Body_Current y1];

			[y1, i] = arselect('Temp_HV_enclose');
			Temp_HV_enclose=[Temp_HV_enclose y1];

			[y1, i] = arselect('Temp_IOT_enclose');
			Temp_IOT_enclose=[Temp_IOT_enclose y1];

			[y1, i] = arselect('Temp_IOT_cooling');
			Temp_IOT_cooling=[Temp_IOT_cooling y1];

			[y1, i] = arselect('Temp_ceramic_output');
			Temp_ceramic_output=[Temp_ceramic_output y1];

			[y1, i] = arselect('BR4_____CLDFWD_AM00');
			BR_CLDFWD=[BR_CLDFWD y1];

			[y1, i] = arselect('BR4_____WGREV__AM01');
			BR_WGREV=[BR_WGREV y1];

			[y1, i] = arselect('BR4_____WGFWD__AM02');
			BR_WGFWD=[BR_WGFWD y1];

			[y1, i] = arselect('BR4_____RFCONT_AM01');
			BR_RFCONT=[BR_RFCONT y1];

			[y1, i] = arselect('BR4_____PHSCON_AM00');
			BR_PHSCON_AM=[BR_PHSCON_AM y1];

			[y1, i] = arselect('BR4_____PHSCON_AC00');
			BR_PHSCON_AC=[BR_PHSCON_AC y1];

			[y1, i] = arselect('BR4_____TUNPOS_AM00');
			BR_TUNPOS=[BR_TUNPOS y1];

			[y1, i] = arselect('BR4_____TUNERR_AM02');
			BR_TUNERR=[BR_TUNERR y1];

			[y1, i] = arselect('BR4_____CAVTMP_AM03');
			BR_CAVTMP=[BR_CAVTMP y1];

			[y1, i] = arselect('BR4_____LCWTMP_AM03');
			BR_LCWTMP=[BR_LCWTMP y1];

			[y1, i] = arselect('BR4_____CLDFLW_AM01');
			BR_CLDFLW=[BR_CLDFLW y1];

			[y1, i] = arselect('BR4_____CIRFLW_AM02');
			BR_CIRFLW=[BR_CIRFLW y1];

			[y1, i] = arselect('BR4_____SLDTMP_AM01');
			BR_SLDTMP=[BR_SLDTMP y1];

			[y1, i] = arselect('BR4_____CIRTMP_AM03');
			BR_CIRTMP=[BR_CIRTMP y1];

			[y1, i] = arselect('BR4_____SLDFLW_AM00');
			BR_SLDFLW=[BR_SLDFLW y1];

			[y1, i] = arselect('BR4_____CLDTMP_AM03');
			BR_CLDTMP=[BR_CLDTMP y1];

			[y1, i] = arselect('BR4_____CAVFLW_AM00');
			BR_CAVFLW=[BR_CAVFLW y1];

			[y1, i] = arselect('BR4_____WINFLW_AM01');
			BR_WINFLW=[BR_WINFLW y1];

			[y1, i] = arselect('BR4_____TUNFLW_AM02');
			BR_TUNFLW=[BR_TUNFLW y1];

         t = [t  ARt+(day-StartDay+(days(length(days))-days(1)+1))*24*60*60];
         
      catch
         fprintf('  Error reading archived data file.\n');
         fprintf('  %s will be ignored.\n', FileName);
      end
      
      disp(' ');
   end
end
ar_functions_time = toc;
fprintf('  %.1f seconds to arread and arselect data\n', ar_functions_time);

tic;
% condition data

dcct = 100*dcct;

% Remove points when current is below 1 mamps
[y, i]=find(dcct<1);
gev(i)=NaN*ones(size(i));
lifetime(i)=NaN*ones(size(i));
Power_RF_fwd(i)=NaN*ones(size(i));
Power_RF_ref(i)=NaN*ones(size(i));
Power_drive(i)=NaN*ones(size(i));
HV_setpoint(i)=NaN*ones(size(i));
Beam_volts(i)=NaN*ones(size(i));
Beam_current(i)=NaN*ones(size(i));
Bias_volts(i)=NaN*ones(size(i));
Bias_current(i)=NaN*ones(size(i));
Heater_Voltage(i)=NaN*ones(size(i));
Heater_current(i)=NaN*ones(size(i));
Focus_voltage(i)=NaN*ones(size(i));
Focus_current(i)=NaN*ones(size(i));
VacIon_voltage(i)=NaN*ones(size(i));
VacIon_current(i)=NaN*ones(size(i));
Thy_Grid1_volts(i)=NaN*ones(size(i));
Thy_Grid2_volts(i)=NaN*ones(size(i));
Thy_heater_volts(i)=NaN*ones(size(i));
Thy_heater_current(i)=NaN*ones(size(i));
Body_Current(i)=NaN*ones(size(i));
Temp_HV_enclose(i)=NaN*ones(size(i));
Temp_IOT_enclose(i)=NaN*ones(size(i));
Temp_IOT_cooling(i)=NaN*ones(size(i));
Temp_ceramic_output(i)=NaN*ones(size(i));
BR_CLDFWD(i)=NaN*ones(size(i));
BR_WGREV(i)=NaN*ones(size(i));
BR_WGFWD(i)=NaN*ones(size(i));
BR_RFCONT(i)=NaN*ones(size(i));
BR_PHSCON_AM(i)=NaN*ones(size(i));
BR_PHSCON_AC(i)=NaN*ones(size(i));
BR_TUNPOS(i)=NaN*ones(size(i));
BR_TUNERR(i)=NaN*ones(size(i));
BR_CAVTMP(i)=NaN*ones(size(i));
BR_LCWTMP(i)=NaN*ones(size(i));
BR_CLDFLW(i)=NaN*ones(size(i));
BR_CIRFLW(i)=NaN*ones(size(i));
BR_SLDTMP(i)=NaN*ones(size(i));
BR_CIRTMP(i)=NaN*ones(size(i));
BR_SLDFLW(i)=NaN*ones(size(i));
BR_CLDTMP(i)=NaN*ones(size(i));
BR_CAVFLW(i)=NaN*ones(size(i));
BR_WINFLW(i)=NaN*ones(size(i));
BR_TUNFLW(i)=NaN*ones(size(i));

% Remove points when FF is disabled
if FFFlag 
   [y, i] = find(FF7Enable==0);
   gev(i)=NaN*ones(size(i));
   lifetime(i)=NaN*ones(size(i));
end   

% Remove points when the gaps are open
% j = any([IDgap5;IDgap7;IDgap8;IDgap9;IDgap10;IDgap12] < 80);
%j = any(IDgap < 80); % was 80 before IVID
j = any(IDgap < 29); %changed from 37 10-10-05 because we've been running IVID at 30mm pemanently
i = 1:length(t);
i(j) = [];
gev(i)=NaN*ones(size(i));
lifetime(i)=NaN*ones(size(i));

% Remove points after a NaN
[y, i]=find(isnan(dcct));
i = i + 1;
if ~isempty(i)
   if i(end) > length(dcct)
      i = i(1:end-1);
   end
end
gev(i)=NaN*ones(size(i));
lifetime(i)=NaN*ones(size(i));
Power_RF_fwd(i)=NaN*ones(size(i));
Power_RF_ref(i)=NaN*ones(size(i));
Power_drive(i)=NaN*ones(size(i));
HV_setpoint(i)=NaN*ones(size(i));
Beam_volts(i)=NaN*ones(size(i));
Beam_current(i)=NaN*ones(size(i));
Bias_volts(i)=NaN*ones(size(i));
Bias_current(i)=NaN*ones(size(i));
Heater_Voltage(i)=NaN*ones(size(i));
Heater_current(i)=NaN*ones(size(i));
Focus_voltage(i)=NaN*ones(size(i));
Focus_current(i)=NaN*ones(size(i));
VacIon_voltage(i)=NaN*ones(size(i));
VacIon_current(i)=NaN*ones(size(i));
Thy_Grid1_volts(i)=NaN*ones(size(i));
Thy_Grid2_volts(i)=NaN*ones(size(i));
Thy_heater_volts(i)=NaN*ones(size(i));
Thy_heater_current(i)=NaN*ones(size(i));
Body_Current(i)=NaN*ones(size(i));
Temp_HV_enclose(i)=NaN*ones(size(i));
Temp_IOT_enclose(i)=NaN*ones(size(i));
Temp_IOT_cooling(i)=NaN*ones(size(i));
Temp_ceramic_output(i)=NaN*ones(size(i));
BR_CLDFWD(i)=NaN*ones(size(i));
BR_WGREV(i)=NaN*ones(size(i));
BR_WGFWD(i)=NaN*ones(size(i));
BR_RFCONT(i)=NaN*ones(size(i));
BR_PHSCON_AM(i)=NaN*ones(size(i));
BR_PHSCON_AC(i)=NaN*ones(size(i));
BR_TUNPOS(i)=NaN*ones(size(i));
BR_TUNERR(i)=NaN*ones(size(i));
BR_CAVTMP(i)=NaN*ones(size(i));
BR_LCWTMP(i)=NaN*ones(size(i));
BR_CLDFLW(i)=NaN*ones(size(i));
BR_CIRFLW(i)=NaN*ones(size(i));
BR_SLDTMP(i)=NaN*ones(size(i));
BR_CIRTMP(i)=NaN*ones(size(i));
BR_SLDFLW(i)=NaN*ones(size(i));
BR_CLDTMP(i)=NaN*ones(size(i));
BR_CAVFLW(i)=NaN*ones(size(i));
BR_WINFLW(i)=NaN*ones(size(i));
BR_TUNFLW(i)=NaN*ones(size(i));

if 0
   % Remove points 2 after a NaN
   [y, i]=find(isnan(dcct));
   i = i + 1;
   if ~isempty(i)
      if i(end) > length(dcct)
         i = i(1:end-1);
      end
   end
   gev(i)=NaN*ones(size(i));
   lifetime(i)=NaN*ones(size(i));
	Power_RF_fwd(i)=NaN*ones(size(i));
	Power_RF_ref(i)=NaN*ones(size(i));
	Power_drive(i)=NaN*ones(size(i));
	HV_setpoint(i)=NaN*ones(size(i));
	Beam_volts(i)=NaN*ones(size(i));
	Beam_current(i)=NaN*ones(size(i));
	Bias_volts(i)=NaN*ones(size(i));
	Bias_current(i)=NaN*ones(size(i));
	Heater_Voltage(i)=NaN*ones(size(i));
	Heater_current(i)=NaN*ones(size(i));
	Focus_voltage(i)=NaN*ones(size(i));
	Focus_current(i)=NaN*ones(size(i));
	VacIon_voltage(i)=NaN*ones(size(i));
	VacIon_current(i)=NaN*ones(size(i));
	Thy_Grid1_volts(i)=NaN*ones(size(i));
	Thy_Grid2_volts(i)=NaN*ones(size(i));
	Thy_heater_volts(i)=NaN*ones(size(i));
	Thy_heater_current(i)=NaN*ones(size(i));
	Body_Current(i)=NaN*ones(size(i));
	Temp_HV_enclose(i)=NaN*ones(size(i));
	Temp_IOT_enclose(i)=NaN*ones(size(i));
	Temp_IOT_cooling(i)=NaN*ones(size(i));
	Temp_ceramic_output(i)=NaN*ones(size(i));
	BR_CLDFWD(i)=NaN*ones(size(i));
	BR_WGREV(i)=NaN*ones(size(i));
	BR_WGFWD(i)=NaN*ones(size(i));
	BR_RFCONT(i)=NaN*ones(size(i));
	BR_PHSCON_AM(i)=NaN*ones(size(i));
	BR_PHSCON_AC(i)=NaN*ones(size(i));
	BR_TUNPOS(i)=NaN*ones(size(i));
	BR_TUNERR(i)=NaN*ones(size(i));
	BR_CAVTMP(i)=NaN*ones(size(i));
	BR_LCWTMP(i)=NaN*ones(size(i));
	BR_CLDFLW(i)=NaN*ones(size(i));
	BR_CIRFLW(i)=NaN*ones(size(i));
	BR_SLDTMP(i)=NaN*ones(size(i));
	BR_CIRTMP(i)=NaN*ones(size(i));
	BR_SLDFLW(i)=NaN*ones(size(i));
	BR_CLDTMP(i)=NaN*ones(size(i));
	BR_CAVFLW(i)=NaN*ones(size(i));
	BR_WINFLW(i)=NaN*ones(size(i));
	BR_TUNFLW(i)=NaN*ones(size(i));
end

% Remove points before a NaN
i = i - 2;
if ~isempty(i)
   if i(1) < 1
      i = i(2:end);
   end
end
gev(i)=NaN*ones(size(i));
lifetime(i)=NaN*ones(size(i));
Power_RF_fwd(i)=NaN*ones(size(i));
Power_RF_ref(i)=NaN*ones(size(i));
Power_drive(i)=NaN*ones(size(i));
HV_setpoint(i)=NaN*ones(size(i));
Beam_volts(i)=NaN*ones(size(i));
Beam_current(i)=NaN*ones(size(i));
Bias_volts(i)=NaN*ones(size(i));
Bias_current(i)=NaN*ones(size(i));
Heater_Voltage(i)=NaN*ones(size(i));
Heater_current(i)=NaN*ones(size(i));
Focus_voltage(i)=NaN*ones(size(i));
Focus_current(i)=NaN*ones(size(i));
VacIon_voltage(i)=NaN*ones(size(i));
VacIon_current(i)=NaN*ones(size(i));
Thy_Grid1_volts(i)=NaN*ones(size(i));
Thy_Grid2_volts(i)=NaN*ones(size(i));
Thy_heater_volts(i)=NaN*ones(size(i));
Thy_heater_current(i)=NaN*ones(size(i));
Body_Current(i)=NaN*ones(size(i));
Temp_HV_enclose(i)=NaN*ones(size(i));
Temp_IOT_enclose(i)=NaN*ones(size(i));
Temp_IOT_cooling(i)=NaN*ones(size(i));
Temp_ceramic_output(i)=NaN*ones(size(i));
BR_CLDFWD(i)=NaN*ones(size(i));
BR_WGREV(i)=NaN*ones(size(i));
BR_WGFWD(i)=NaN*ones(size(i));
BR_RFCONT(i)=NaN*ones(size(i));
BR_PHSCON_AM(i)=NaN*ones(size(i));
BR_PHSCON_AC(i)=NaN*ones(size(i));
BR_TUNPOS(i)=NaN*ones(size(i));
BR_TUNERR(i)=NaN*ones(size(i));
BR_CAVTMP(i)=NaN*ones(size(i));
BR_LCWTMP(i)=NaN*ones(size(i));
BR_CLDFLW(i)=NaN*ones(size(i));
BR_CIRFLW(i)=NaN*ones(size(i));
BR_SLDTMP(i)=NaN*ones(size(i));
BR_CIRTMP(i)=NaN*ones(size(i));
BR_SLDFLW(i)=NaN*ones(size(i));
BR_CLDTMP(i)=NaN*ones(size(i));
BR_CAVFLW(i)=NaN*ones(size(i));
BR_WINFLW(i)=NaN*ones(size(i));
BR_TUNFLW(i)=NaN*ones(size(i));

% Hours or days for the x-axis?
if t(end)/60/60/24 > 3
   t = t/60/60/24;
   xlabelstring = ['Date since ', StartDayStr, ' [Days]'];
   DayFlag = 1;
else
   t = t/60/60;
   xlabelstring = ['Time since ', StartDayStr, ' [Hours]'];
   DayFlag = 0;
end
Days = [days days2];
xmax = max(t);


% change data to NaN for plotting if archiver has stalled for more than 12minutes
StalledArchFlag = [];
for loop = 1:size(t,2)-1
   StalledArchFlag(loop) = (t(loop+1)-t(loop)>0.2);
end
SANum = find(StalledArchFlag==1)+1;
dcct(SANum)=NaN;


% Plotted during user time
if FFFlag
    GapEnable(isnan(GapEnable)) = 0;
    GapEnable(GapEnable==127) = 1;  % Sometime 127 is the same as 1 (boolean???) 
    i = find(sum(GapEnable) < 3);   % Why 3, just because sometimes 1 or 2 gaps are enabled for testing.
else
    i = find(dcct < 150)
end

filter_data_time = toc;
%fprintf('  %.1f seconds to filter data\n', filter_data_time);

%%%%%%%%%%%%%%%%%%%% 
% Plot BR RF Plots %
%%%%%%%%%%%%%%%%%%%%
FigNum = 0;
FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
%p = get(h, 'Position');
%set(h, 'Position', FigurePosition);
clf reset;

subplot(5,1,1);
[ax, h1, h2] = plotyy(t,[Power_RF_fwd; Power_RF_ref], t,Power_drive);
set(get(ax(1),'Ylabel'), 'String', sprintf('Fwd Pwr and Ref [%%]'), 'Color', LeftGraphColor);
set(get(ax(2),'Ylabel'), 'String', 'Pwr Drive [W]', 'Color', RightGraphColor);
set(ax(1), 'YColor', LeftGraphColor);
set(h1, 'Color', LeftGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
   MaxDay = round(max(t));
   set(ax(1),'XTick',[0:MaxDay]');
   set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');
title(['Booster RF Plots: ', titleStr]);

subplot(5,1,2);
[ax, h1, h2] = plotyy(t,[HV_setpoint; Beam_volts], t,[Beam_current; Body_Current]);
set(get(ax(1),'Ylabel'), 'String', 'Beam HV SP and AM [kV]', 'Color', LeftGraphColor);
set(get(ax(2),'Ylabel'), 'String', 'Beam and Body I [A]', 'Color', RightGraphColor);
set(ax(1), 'YColor', LeftGraphColor);
set(h1, 'Color', LeftGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
   MaxDay = round(max(t));
   set(ax(1),'XTick',[0:MaxDay]');
   set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(5,1,3);
[ax, h1, h2] = plotyy(t,Bias_volts, t,Bias_current);
set(get(ax(1),'Ylabel'), 'String', 'Bias V [V]');
set(get(ax(2),'Ylabel'), 'String', 'Bias I [mA]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
   MaxDay = round(max(t));
   set(ax(1),'XTick',[0:MaxDay]');
   set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(5,1,4);
[ax, h1, h2] = plotyy(t,Heater_Voltage, t,Heater_current);
set(get(ax(1),'Ylabel'), 'String', 'Htr V [V]');
set(get(ax(2),'Ylabel'), 'String', 'Htr I [A]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
   MaxDay = round(max(t));
   set(ax(1),'XTick',[0:MaxDay]');
   set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(5,1,5);
[ax, h1, h2] = plotyy(t,Focus_voltage, t,Focus_current);
set(get(ax(1),'Ylabel'), 'String', 'Focus V [V]');
set(get(ax(2),'Ylabel'), 'String', 'Focus I [A]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
   MaxDay = round(max(t));
   set(ax(1),'XTick',[0:MaxDay]');
   set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.15);
setappdata(FigNum, 'ArchiveDate', DirectoryDate);
orient tall


FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
%p = get(h, 'Position');
%set(h, 'Position', FigurePosition);
clf reset;

subplot(4,1,1);
[ax, h1, h2] = plotyy(t,VacIon_voltage, t,VacIon_current);
set(get(ax(1),'Ylabel'), 'String', 'IonPump V [kV]');
set(get(ax(2),'Ylabel'), 'String', sprintf('IonPump I [\muA]'), 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
   MaxDay = round(max(t));
   set(ax(1),'XTick',[0:MaxDay]');
   set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(4,1,2);
[ax, h1, h2] = plotyy(t,Thy_Grid1_volts, t,Thy_Grid2_volts);
set(get(ax(1),'Ylabel'), 'String', 'Thy Grid1 V [V]');
set(get(ax(2),'Ylabel'), 'String', 'Thy Grid2 V [V]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
   MaxDay = round(max(t));
   set(ax(1),'XTick',[0:MaxDay]');
   set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');
title(['Booster RF Plots: ', titleStr]);

subplot(4,1,3);
[ax, h1, h2] = plotyy(t,Thy_heater_volts, t,Thy_heater_current);
set(get(ax(1),'Ylabel'), 'String', 'Thy Htr V [V]');
set(get(ax(2),'Ylabel'), 'String', 'Thy Htr I [A]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
   MaxDay = round(max(t));
   set(ax(1),'XTick',[0:MaxDay]');
   set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(4,1,4);
plot(t,Temp_HV_enclose,'b', t,Temp_IOT_enclose,'r', t,Temp_IOT_cooling, 'g', t,Temp_ceramic_output,'m');
legend('HV Enclosure Temp','IOT Enclosure Temp','IOT Cooling Temp','Ceramic Output Temp');
set(get(gca,'Ylabel'), 'String', '[deg C]', 'Color', LeftGraphColor);
set(gca,'YColor', LeftGraphColor);
grid on
xaxis([0 xmax]);
%if DayFlag
%   MaxDay = round(max(t));
%  set(ax,'XTick',[0:MaxDay]');
%end
%set(ax,'XTickLabel','');

xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.15);
setappdata(FigNum, 'ArchiveDate', DirectoryDate);
orient tall


FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
%p = get(h, 'Position');
%set(h, 'Position', FigurePosition);
clf reset;

subplot(4,1,1);
[ax, h1, h2] = plotyy(t,BR_CLDFWD, t,BR_RFCONT);
set(get(ax(1),'Ylabel'), 'String', 'Circulator Load Fwd Pwr [kW]');
set(get(ax(2),'Ylabel'), 'String', 'RF Amplitude AM [kW]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
   MaxDay = round(max(t));
   set(ax(1),'XTick',[0:MaxDay]');
   set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');
title(['Booster RF Plots: ', titleStr]);

subplot(4,1,2);
[ax, h1, h2] = plotyy(t,BR_WGREV, t,BR_WGFWD);
set(get(ax(1),'Ylabel'), 'String', 'Waveguide Rev Pwr [kW]');
set(get(ax(2),'Ylabel'), 'String', 'Waveguide Fwd Pwr [kW]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
   MaxDay = round(max(t));
   set(ax(1),'XTick',[0:MaxDay]');
   set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(4,1,3);
[ax, h1, h2] = plotyy(t,BR_PHSCON_AM, t,BR_PHSCON_AC);
set(get(ax(1),'Ylabel'), 'String', 'RF Phase AM [deg]');
set(get(ax(2),'Ylabel'), 'String', 'RF Phase AC [deg]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
   MaxDay = round(max(t));
   set(ax(1),'XTick',[0:MaxDay]');
   set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(4,1,4);
[ax, h1, h2] = plotyy(t,BR_TUNPOS, t,BR_TUNERR);
set(get(ax(1),'Ylabel'), 'String', 'Tuner Position AM [cm]');
set(get(ax(2),'Ylabel'), 'String', sprintf('Tuner Loop Error [%%]'), 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
   MaxDay = round(max(t));
   set(ax(1),'XTick',[0:MaxDay]');
   set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.15);
setappdata(FigNum, 'ArchiveDate', DirectoryDate);
orient tall


FigNum = FigNum + 1;
h = figure(FigNum);
subfig(1,1,1, h);
%p = get(h, 'Position');
%set(h, 'Position', FigurePosition);
clf reset;

subplot(4,1,1);
plot(t,BR_CAVTMP);
set(get(gca,'Ylabel'), 'String', 'Cavity Temp [deg C]', 'Color', LeftGraphColor);
set(gca,'YColor', LeftGraphColor);
grid on
xaxis([0 xmax]);
%if DayFlag
%   MaxDay = round(max(t));
%   set(ax,'XTick',[0:MaxDay]');
%end
%set(ax,'XTickLabel','');
title(['Booster RF Plots: ', titleStr]);

subplot(4,1,2);
plot(t,BR_LCWTMP,'b', t,BR_SLDTMP,'r', t,BR_CIRTMP,'g', t,BR_CLDTMP,'m');
legend('LCW Inlet Temp','Switch Load Temp','Circulator Temp','Circulator Load Temp');
set(get(gca,'Ylabel'), 'String', '[deg C]', 'Color', LeftGraphColor);
set(gca,'YColor', LeftGraphColor);
grid on
xaxis([0 xmax]);
%if DayFlag
%   MaxDay = round(max(t));
%   set(ax,'XTick',[0:MaxDay]');
%end
%set(ax,'XTickLabel','');

subplot(4,1,3);
plot(t,BR_CLDFLW,'b', t,BR_CIRFLW,'r', t,BR_SLDFLW,'g');
legend('Circulator Load Flow','Circulator Flow','Switch Load Flow');
set(get(gca,'Ylabel'), 'String', '[GPM]', 'Color', LeftGraphColor);
set(gca,'YColor', LeftGraphColor);
grid on
xaxis([0 xmax]);
%if DayFlag
%   MaxDay = round(max(t));
%   set(ax,'XTick',[0:MaxDay]');
%end
%set(ax,'XTickLabel','');

subplot(4,1,4);
[ax, h1, h2] = plotyy(t,[BR_CAVFLW; BR_WINFLW], t,BR_TUNFLW);
set(get(ax(1),'Ylabel'), 'String', 'Cavity & RF Window Flow [GPM]', 'Color', LeftGraphColor);
set(get(ax(2),'Ylabel'), 'String', 'Tuner Flow [GPM]', 'Color', RightGraphColor);
set(ax(1), 'YColor', LeftGraphColor);
set(h1, 'Color', LeftGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = xmax;
axis(aa);
if DayFlag
   MaxDay = round(max(t));
   set(ax(1),'XTick',[0:MaxDay]');
   set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.15);
setappdata(FigNum, 'ArchiveDate', DirectoryDate);
orient tall


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ChangeAxesLabel(t, Days, DayFlag)
xaxis([0 max(t)]);

if DayFlag
   if size(Days,2) > 1
      Days = Days'; % Make a column vector
   end
   
   MaxDay = round(max(t));
   set(gca,'XTick',[0:MaxDay]');
   %xaxis([0 MaxDay]);

   if length(Days) < MaxDay-1
      % Days were skipped 
      set(gca,'XTickLabel',strvcat(num2str([0:MaxDay-1]'+Days(1)),' '));  
   else
      % All days plotted
      set(gca,'XTickLabel',strvcat(num2str(Days),' '));  
   end
   
   XTickLabelString = get(gca,'XTickLabel');
   if MaxDay < 20
      % ok
   elseif MaxDay < 40
      set(gca,'XTick',[0:2:MaxDay]');       
      set(gca,'XTickLabel',XTickLabelString(1:2:MaxDay-1,:));       
   elseif MaxDay < 63
      set(gca,'XTick',[0:3:MaxDay]');       
      set(gca,'XTickLabel',XTickLabelString(1:3:MaxDay-1,:));       
   elseif MaxDay < 80
      set(gca,'XTick',[0:4:MaxDay]');       
      set(gca,'XTickLabel',XTickLabelString(1:4:MaxDay-1,:));       
   end
end
