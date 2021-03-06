% macro match dba test lattice beta functions and dispersion using
% quadrupoles.
%
% this macro shows the available functionalities of atmatch. 
% 
% various variable and constraint input constructions are shown

clear all
load('dba.mat','RING');
addpath(fullfile(pwd,'..'))

%%  VARIABLES

% Variab1=struct('Indx',{findcells(RING,'FamName','QD'),findcells(RING,'FamName','QF')},...
%     'LowLim',{[],[]},...
%     'HighLim',{[],[]},...
%     'Parameter',{{'PolynomB',{1,2}},{'PolynomB',{1,2}}}...
%     ); 

% or 

Variab1=atVariableBuilder(RING,{'QD','QF'},{{'PolynomB',{1,2}},{'PolynomB',{1,2}}});


k1start=getcellstruct(RING,'PolynomB',findcells(RING,'FamName','QDM'),1,2);

Variab2=struct('Indx',{findcells(RING,'FamName','QFM'),@(RING,K1Val)VaryQuadFam(RING,K1Val,'QDM')},...
    'LowLim',{[],[]},...
    'HighLim',{[],[]},...
    'Parameter',{{'PolynomB',{1,2}},k1start(1)}...
    );

Variab=[Variab1,Variab2];


%%  CONSTRAINTS
qfmindx=findcells(RING,'FamName','QFM');
Constr1=struct('Fun',@(RING,~,~)dispx(RING,1),...
    'Min',0,...
    'Max',0,...
    'RefPoints',[],...
    'Weight',1);
disp('Horizontal dispersion at straigth section= 0')

Constr2=struct('Fun',@(RING,~,~)betx(RING,qfmindx(2)),...
    'Min',17.3,...
    'Max',17.3,...
    'RefPoints',[],...
    'Weight',1);
disp('Horizontal beta at QFM= 17.3')

Constr3=struct('Fun',{@(RING,~,~)bety(RING,qfmindx(2)),@(~,ld,~)mux(ld)},...
    'Min',{0.58,4.35},...
    'Max',{0.58,4.35},...
    'RefPoints',{[],[1:length(RING)+1]},...
    'Weight',{1,1});
disp('Vertical beta at QFM= 0.58')
disp('Horizontal phase advance = 4.35')

Constr=[Constr1,Constr2,Constr3];

%% MATCHING
 disp('wait few iterations')
RING_matched=atmatch(RING,Variab,Constr,10^-20,1000,3,@lsqnonlin);

%return
c1=atlinconstraint(qfmindx(2),...
    {{'beta',{1}},{'beta',{2}}},...
    [17.3,0.58],...
    [17.3,0.58],...
    [1 1]);

c2=atlinconstraint(1,...
    {{'Dispersion',{1}},{'tune',{1}}},...
    [0,0.35],...
    [0,0.35],...
    [1 1]);

c=[c1,c2];

RING_matched_optconstr=atmatch(RING,Variab,c,10^-6,1000,3);%

figure;atplot(RING);% export_fig('ringdba.pdf','-transparent');
figure;atplot(RING_matched);% export_fig('ringdba_matched.pdf','-transparent');
figure;atplot(RING_matched_optconstr);% export_fig('ringdba_matched.pdf','-transparent');
