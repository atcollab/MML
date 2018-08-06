function Caen = getcaen(BaseName)

Caen.WaveformStop   = getpv([BaseName,':WaveformStop']);
Caen.Setpoint       = getpv([BaseName,':Setpoint']);
Caen.Current        = getpv([BaseName,':CurrentRBV']);
Caen.BulkVoltage    = getpv([BaseName,':BulkVoltage']);
Caen.LeakageCurrent = getpv([BaseName,':LeakageCurrent']);
Caen.OutputVoltage  = getpv([BaseName,':OutputVoltage']);
Caen.RegulatorTemp  = getpv([BaseName,':RegulatorTemp']);
Caen.ShuntTemp      = getpv([BaseName,':ShuntTemp']);
Caen.ControllerKp   = getpv([BaseName,':ControllerKp']);
Caen.ControllerKi   = getpv([BaseName,':ControllerKi']);
Caen.ControllerKd   = getpv([BaseName,':ControllerKd']);
Caen.SlewRate       = getpv([BaseName,':SlewRate']);
Caen.WaveformActive = getpv([BaseName,':WaveformActive']);
%Caen.WaveformStart  = getpv([BaseName,':WaveformStart']);
%Caen.WaveformStop   = getpv([BaseName,':WaveformStop']);
