function set_topoff_interlock_default_currents(varargin)
% set_topoff_interlock_default_currents
%
% Routine used for topoff testing to find set magnets back to their original default/golden currents
%
% Christoph Steier, October 2011

disp('Resetting all top-off interlocked magnets to their original golden setpoints');

disp('Energy Match Interlock (SRBEND, SR4BSC, SR8BSC,SR12BSC)');
match_current_values('SRBend_Mag_I_Mon','SR01C___B______AC00',895.938+0.8,895.969+0.8);
match_current_values('SR4SB_Mag_I_Mon','SR04C___BSC_P__AC00',299.906-1.37,299.419-0.92);
match_current_values('SR8SB_Mag_I_Mon','SR08C___BSC_P__AC00',296.265+0.36,296.611);
match_current_values('SR12SB_Mag_I_Mon','SR12C___BSC_P__AC00',299.044-0.6,299.194-0.76);

disp('Lattice Match Interlock (SRBEND, SR4BSC, SR8BSC,SR12BSC)');
match_current_values('SRBend_Mag_I_Mon','SR01C___B______AC00',895.938+0.8,895.969+0.8);
match_current_values('SR4SB_Mag_I_Mon','SR04C___BSC_P__AC00',299.906-1.37,299.419-0.92);
match_current_values('SR8SB_Mag_I_Mon','SR08C___BSC_P__AC00',296.265+0.36,296.611);
match_current_values('SR12SB_Mag_I_Mon','SR12C___BSC_P__AC00',299.044-0.6,299.194-0.76);

disp('Finished!');
return

%----------- match_current_values 
function match_current_values(ChanNameInterlock,ChanNameSP,defA,defB)
if nargin<4
    error('match_current_values needs 4 input arguments');
end
ChanNameInterlockA=[ChanNameInterlock,'A'];
ChanNameInterlockB=[ChanNameInterlock,'B'];
startA=getpv(ChanNameInterlockA);
startB=getpv(ChanNameInterlockB);
% steppv(ChanNameSP,mean([defA-startA,defB-startB]));
mean([defA-startA,defB-startB])
if ((abs(getpv(ChanNameInterlockA)-defA)./abs(defA))<0.0005) && ((abs(getpv(ChanNameInterlockB)-defB)./abs(defB))<0.0005)
    fprintf('Adjusted %s, IAAM should be %.2f A, is %.2f A, IBAM should be %.2f A, is %.2f A - OK to continue\n',ChanNameSP,defA,getpv(ChanNameInterlockA),defB,getpv(ChanNameInterlockB));
else
    fprintf('Adjusted %s, IAAM should be %.2f A, is %.2f A, IBAM should be %.2f A, is %.2f A - outside range! Stop and investigate\n', ...
        ChanNameSP,defA,getpv(ChanNameInterlockA),defB,getpv(ChanNameInterlockB));
    soundtada;
end
return