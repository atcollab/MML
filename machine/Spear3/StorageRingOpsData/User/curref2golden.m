clear all
load 'GoldenConfig'

ConfigSetpoint.HCM.Setpoint=getsp('HCM','struct');
ConfigSetpoint.VCM.Setpoint=getsp('VCM','struct');
ConfigSetpoint

ConfigMonitor.HCM.Monitor=getam('HCM','struct');
ConfigMonitor.VCM.Monitor=getam('VCM','struct');
ConfigMonitor.HCMCurrReference.Monitor=getam('HCMCurrReference','struct');
ConfigMonitor.VCMCurrReference.Monitor=getam('VCMCurrReference','struct');
ConfigMonitor.IDTrim.Monitor=getam('HCMCurrReference','struct');
ConfigMonitor

save 'TestConfig' ConfigSetpoint ConfigMonitor