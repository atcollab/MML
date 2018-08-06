// Addinter for EZCA interface
// for hppa/sun-solaris/linux/dec
//--------------------------------
//Scilab functions 
ezca_funs=[...
  'lcaGet';
  'lcaPut';
  'lcaPutNoWait';
  'lcaGetNelem';
  'lcaGetControlLimits';
  'lcaGetGraphicLimits';
  'lcaGetStatus';
  'lcaGetPrecision';
  'lcaGetUnits';
  'lcaGetRetryCount';
  'lcaSetRetryCount';
  'lcaGetTimeout';
  'lcaSetTimeout';
  'lcaDebugOn';
  'lcaDebugOff';
  'lcaSetSeverityWarnLevel';
  'lcaClear';
  'lcaSetMonitor';
  'lcaNewMonitorValue';
  'lcaNewMonitorWait';
  'lcaDelay';
  'lcaLastError';
  'lecdrGet';
  ];
ezca_top=get_absolute_file_path('labca.sce')+'../../';
addinter(ezca_top+'bin/win32-x86/sezcaglue.dll','ezca',ezca_funs);
if grep(%helps(:,1),ezca_top)== [] then
   %helps=[%helps;[ezca_top+"html/help", "EPICS CA Interface"]];
end
