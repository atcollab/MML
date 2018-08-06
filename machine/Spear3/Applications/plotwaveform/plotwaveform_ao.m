%==============================        
function AO=PlotWaveformAO(status)              %%%%%%%%  PlotWaveformAO %%%%%%%%%
%==============================        

AO=[];    
if strcmpi(status,'online')
    try
LINTR1_timebase=getpv('LIN-TR1:TimeDelta');
LINTR2_timebase=getpv('LIN-TR2:TimeDelta');
LINTR3_timebase=getpv('LIN-TR3:TimeDelta');
LINTR4_timebase=getpv('LIN-TR4:TimeDelta');
LINTR5_timebase=getpv('LIN-TR5:TimeDelta');
    catch
        disp('   ***  Warning: B140-IOCLINAC1 IOC server may be down ***')
    end
    try
BOOTR2_timebase=getpv('BOO-TR2:TimeDelta');
    catch
        disp('   ***  Warning: B140-IOCBOO1 IOC server may be down ***')
    end

else
disp('   Warning: PlotWaveform operating in simulator mode')
LINTR1_timebase=0.01;
LINTR2_timebase=0.01;
LINTR3_timebase=0.01;
LINTR4_timebase=0.01;
LINTR5_timebase=0.01;
BOOTR2_timebase=0.0977;
end
   

Value={'Avg'; 'Centroid'; 'Min'; 'Max'; 'Sum'; 'TimeWidth';};
%<Charge or Ener> Integrated value - "Charge" for Curr, "Ener" for Pwr,
%"Intgrl" for Load)
%insert 'Fst' for fast signal
%getpv({'GTL-GT1:Conv.A' 'GTL-GT1:Conv.A'})

%GUN Family
AO.GUN.FamilyName               = 'GUN';
AO.GUN.FamilyType               = 'PSM';
AO.GUN.MemberOf                 = {'PlotWaveform' 'PSM'};
Waveform='VoltFst';  %Voltage
Device={'GUN:Frwd'; 'GUN:Refl'; 'GUN:Isolator'; 'GUN:FullCell'; 'GUN:HalfCell';};  
CommonNames= {'GUN_FWD'; 'GUN_RFL'; 'GUN_ISO'; 'GUN_FUL'; 'GUN_HLF';};
Param={'Pwr'; 'Pwr'; 'Pwr'; 'Pwr'; 'Pwr';};
Device=char(Device);
CommonNames=char(CommonNames);
Param=char(Param);
for ii=1:size(Device,1)
AO.GUN.Monitor.ChannelNames(ii ,:) = Device(ii,:);
AO.GUN.CommonNames(ii ,:) = CommonNames(ii,:);
AO.GUN.RawYUnits(ii ,:) = 'Volts';
AO.GUN.EngYUnits(ii ,:) = Param(ii,:);
AO.GUN.Timebase(ii)=LINTR1_timebase;
end
AO.GUN.RawSignal='VoltFst';
AO.GUN.EngSignal='Fst';
AO.GUN.XUnits='usec';
%VoltOffset and PolyConv loaded from EPICS - line ~330

%GTL Family
AO.GTL.FamilyName               = 'GTL';
AO.GTL.FamilyType               = 'PSM';
AO.GTL.MemberOf                 = {'PlotWaveform' 'PSM'};
Waveform='VoltFst';  %Voltage
Device= {'GTL-FC1:'; 'GTL-GT1:'; 'GTL-GT2:'; 'GTL-GT3:';};
CommonNames={'GTL_FC1'; 'GTL_GT1'; 'GTL_GT2'; 'GTL_GT3';};  
Param={'Curr'; 'Curr'; 'Curr'; 'Curr';};
Device=char(Device);
Param=char(Param);
CommonNames=char(CommonNames);
for ii=1:size(Device,1)
AO.GTL.Monitor.ChannelNames(ii ,:) = Device(ii,:);
AO.GTL.CommonNames(ii ,:) = CommonNames(ii,:);
AO.GTL.RawYUnits(ii ,:) ='Volts';
AO.GTL.EngYUnits(ii ,:) =Param(ii,:);
AO.GTL.Timebase(ii)=LINTR1_timebase;
end
AO.GTL.RawSignal='VoltFst';
AO.GTL.EngSignal='Fst';
AO.GTL.XUnits='usec';
%VoltOffset and PolyConv loaded from EPICS - line ~330

%LIN Family
AO.LIN.FamilyName                = 'LIN';
AO.LIN.FamilyType                = 'PSM';
AO.LIN.MemberOf                  = {'PlotWaveform' 'PSM'};
Waveform='VoltFst';  %Voltage
Device={'LIN-K1:Drive'; 'LIN-K1:Frwd';  'LIN-K1:Refl';  'LIN-LD1:Frwd'; ...
              'LIN-LD1:Refl'; 'LIN-K2:Drive'; 'LIN-K2:Frwd';  'LIN-K2:Refl';  ...
              'LIN-LD2:Frwd'; 'LIN-LD2:Refl'; 'LIN-K3:Drive'; 'LIN-K3:Frwd';  ...
              'LIN-K3:Refl';  'LIN-LD3:Frwd'; 'LIN-LD3:Refl'; 'LIN-LT1:';     ...
              'LIN-LT2:';      'LIN-LT3:';     'LINAC:Chop';};  
CommonNames= {'K1_DRV'; 'K1_FWD'; 'K1_RFL'; 'LD1_FWD'; 'LD1_RFL'; 'K2_DRV'; 'K2_FWD'; 'K2_RFL'; 'LD2_FWD'; 'LD2_RFL';...
              'K3_DRV'; 'K3_FWD'; 'K3_RFL'; 'LD3_FWD'; 'LD3_RFL'; 'LT1';    'LT2';    'LT3';    'CHOP';};
Param={'Pwr'; 'Pwr'; 'Pwr'; 'Pwr'; 'Pwr'; 'Pwr';  'Pwr';  'Pwr'; 'Pwr'; 'Pwr'; ...
        'Pwr'; 'Pwr'; 'Pwr'; 'Pwr'; 'Pwr'; 'Curr'; 'Curr'; 'Curr'; 'Load';};
Device=char(Device);
CommonNames=char(CommonNames);
Param=char(Param);
for ii=1:size(Device,1)
AO.LIN.Monitor.ChannelNames(ii ,:) = Device(ii,:);
AO.LIN.CommonNames(ii ,:) = CommonNames(ii,:);
AO.LIN.RawYUnits(ii ,:) = 'Volts';
AO.LIN.EngYUnits(ii ,:) = Param(ii,:);
AO.LIN.Timebase(ii)=LINTR1_timebase;
end
AO.LIN.RawSignal='VoltFst';
AO.LIN.EngSignal='Fst';
AO.LIN.XUnits='usec';
%VoltOffset and PolyConv loaded from EPICS - line ~330

% AO.LTB.FamilyName               = 'LTB';
% AO.LTB.MemberOf                 = {'PlotWaveform' 'PSM'};

%BOO_usec Family
AO.BOO_usec.FamilyName               = 'BOO_usec';
AO.BOO_usec.FamilyType               = 'PSM';
AO.BOO_usec.MemberOf                 = {'PlotWaveform' 'PSM'};
Waveform='VoltFst';  %Voltage
Device={'BOO-IK1:'; 'BOO-IK2:';};  
CommonNames= {'BOO_IK1'; 'BOO_IK2';};
Param={'Curr'; 'Curr';};
Device=char(Device);
CommonNames=char(CommonNames);
Param=char(Param);
for ii=1:size(Device,1)
AO.BOO_usec.Monitor.ChannelNames(ii ,:) = Device(ii,:);
AO.BOO_usec.CommonNames(ii ,:) = CommonNames(ii,:);
AO.BOO_usec.RawYUnits(ii ,:) = 'Volts';
AO.BOO_usec.EngYUnits(ii ,:) = Param(ii,:);
AO.BOO_usec.Timebase(ii)=LINTR1_timebase;
end
AO.BOO_usec.RawSignal='VoltFst';
AO.BOO_usec.EngSignal='Fst';
AO.BOO_usec.XUnits='usec';
%VoltOffset and PolyConv loaded from EPICS - line ~330

%BOO_msec Family
AO.BOO_msec.FamilyName               = 'BOO_msec';
AO.BOO_msec.FamilyType               = 'PSM';
AO.BOO_msec.MemberOf                 = {'PlotWaveform' 'PSM'};
Waveform='VoltFst';  %Voltage
Device={'BOO-QF:'; 'BOO-QFSP:'; 'BOO-QD:'; 'BOO-QDSP:';};  
CommonNames= {'BOO_QF'; 'BOO_QFSP'; 'BOO_QD'; 'BOO_QDSP';};
Param={'Curr'; 'Curr'; 'Curr'; 'Curr'};
Device=char(Device);
CommonNames=char(CommonNames);
Param=char(Param);
for ii=1:size(Device,1)
AO.BOO_msec.Monitor.ChannelNames(ii ,:) = Device(ii,:);
AO.BOO_msec.CommonNames(ii ,:) = CommonNames(ii,:);
AO.BOO_msec.RawYUnits(ii ,:) = 'Volts';
AO.BOO_msec.EngYUnits(ii ,:) = Param(ii,:);
AO.BOO_msec.Timebase(ii)=BOOTR2_timebase;
end
AO.BOO_msec.RawSignal='VoltFst';
AO.BOO_msec.EngSignal='Fst';
AO.BOO_msec.XUnits='msec';

%VoltOffset and PolyConv loaded from EPICS - line ~330

% AO.BTS.FamilyName               = 'BTS';
% AO.BTS.MemberOf                 = {'PlotWaveform' 'PSM'};

% AO.SPR.FamilyName               = 'SPR';
% AO.SPR.MemberOf                 = {'PlotWaveform' 'PSM'};

end  %end plotwaveform_ao
