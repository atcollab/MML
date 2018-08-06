% MODELSERVERDEMO1 - Example of using
% MATLAB Channel Access Toolbox and Accelerator Toolbox
% to controls applications with
% real-time on-line model features
% 
% This example applications 
%
% 1. monitors the strength of 
% QF,QD quadrupoles families and 
% SF,SD sextupole families
% served by ATfake_sp3.vi LabView(*) program
%  (*) LabView code uses LabView-ActiveX interface to 
%      EPICS by Kay-Uwe Kasemir (LANL)
%
% 2. When any change occurs, MATLAB updates the
% Accelerator Toolbox model with new values and computes
% tunes and chromaticities
%
% 3. Posts the new computed tune and chromaticity values 
% on another server application ATpost_model.vi implemented in LabView
%
% *******************************************************************************

% Load SPEAR3 Lattice
sp3v81loco;
cavityoff;

global QFI QDI SFI SDI qfh qdh sfh sdh
global txh tyh cxh cyh


% Find indexes of elements
QFI = findcells(THERING,'FamName','QF');
QDI = findcells(THERING,'FamName','QD');
SFI = findcells(THERING,'FamName','SF');
SDI = findcells(THERING,'FamName','SD');

% Open conections to CA process variables
[qfh,qdh,sfh,sdh]=mcaopen('QF','QD','SF','SD');
[txh, tyh, cxh, cyh] = mcaopen('X-tune','Y-tune','X-chromaticity','Y-chromaticity');


% Install monitors with callbacks to compute and post
% tunes and chromaticities
% mcamon(qfh,'syncmodel QF; timereval(3,1,10,''tunechrompost;'');');
% mcamon(qdh,'syncmodel QD; timereval(3,1,10,''tunechrompost;'');');
% mcamon(sfh,'syncmodel SF; timereval(3,1,10,''tunechrompost;'');');
% mcamon(sdh,'syncmodel SD; timereval(3,1,10,''tunechrompost;'');');

mcamon(qfh,'timereval(3,1,100,''syncmodel QF; tunechrompost;'');');
mcamon(qdh,'timereval(3,1,100,''syncmodel QD; tunechrompost;'');');
mcamon(sfh,'timereval(3,1,100,''syncmodel SF; tunechrompost;'');');
mcamon(sdh,'timereval(3,1,100,''syncmodel SD; tunechrompost;'');');


% mcamon(qfh,'syncmodel QF; timereval(1,10,''tunechrompost'');');
% mcamon(qdh,'syncmodel QD; timereval(1,10,''tunechrompost'');');
% mcamon(sfh,'syncmodel SF; timereval(1,10,''tunechrompost'');');
% mcamon(sdh,'syncmodel SD; timereval(1,10,''tunechrompost'');');