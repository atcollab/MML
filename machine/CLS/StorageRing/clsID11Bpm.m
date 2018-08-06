function [orbit] = clsID11Bpm

% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/clsID11Bpm.m 1.2 2007/03/02 09:03:24CST matiase Exp  $
% ----------------------------------------------------------------------------------------------

[hbpm numopen] = mcagethandle('SrBPMs:ArrayData');
if numopen == 0
     hbpm = mcaopen('SrBPMs:ArrayData');
     if hbpm == 0
         error(['Problem opening a channel to : SrBPMs:ArrayData' steername1]);
    end
end		
%get all 98 positions */
orbit = mcaget(hbpm);

  fprintf('ID11 raw X = %f Volts\n',orbit(41)*1e3)
  fprintf('ID11 raw Y = %f Volts\n',orbit(90)*1e3)
%  
  fprintf('ID11 X reconstructed = %f Volts\n',(orbit(41)*1.261)*1e3)
  fprintf('ID11 Y reconstructed = %f Volts\n',(orbit(90)*1.152)*1e3)

%using Johannes new conversion numbers
fprintf('ID11 X = %f mm\n',((orbit(41)*1.261)/5.93)*1e3)
fprintf('ID11 Y = %f mm\n',((orbit(90)*1.152)/3.82)*1e3)

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/clsID11Bpm.m  $
% Revision 1.2 2007/03/02 09:03:24CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
