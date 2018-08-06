
% SETUP
% 1. umer2at and at2umer need to be written
%   umer2at - DONE
%   at2umer - DONE
%
% 2. Add proper .Ranges, .Tolerances, and .DeltaRespMat
%   added in umerinit file
%   Tolerances - DONE (umer magnets run around 2-3 amps and have mA tolerances
%   Ranges - DONE (umer magnets run max 2.5/3 amps other will burn PCBs )
%   DeltaRespMat - unsure how to do this?
%
% 4. gev2bend & bend2gev need work
%   *UMER doesn't having ramping dipoles so not sure if this is neccessary*
%   gev2bend - DONE
%   bend2gev - DONE (just returns a constant energy.)
%
% 5. setpvonline / getpvonline in ../mml/links/umer
%    Add channel names
%   setpvonline - DONE
%   getpvonline - DONE
%
% 6. AT lattice (umeratlattice)
%    1. I changed the y-section to include the QF and BEND in those families. 
%       I'm not sure if that's what you want.  For instance the tune correction quads shouldn't be mixed with other quads.
%      
%       Levon - Unsure here since the y-section magnets are physically
%           larger/longer than other magnets, and so have different K-values
%

% Basic tests
% 1. Try mmlviewer to view and check the MML setup. - WORKS
% 2. run monmags to check the .Tolerance field - WORKS
% 3. Measurements - monbpm, measbpmresp, measdisp
%   monbpm - WORKS (simulator)
%   measbpmresp - UNSURE if working correctly
%   measdisp - 
% 4  Copy them to the StorageRingOpsData directory (option in plotfamily)
% 5. Ideally get the tune family working - What is this?
% 6. Check the BPM delay and set getbpmaverages accordingly. - DONE
%    (Edit and try magstep to test the timing.)


% Functions to test:
% 1. Try measbpmresp, meastuneresp, measchroresp
%    Compare to the model and maybe copy them to the StorageRingOpsData directory.
%    After LOCO it's often better to use the calibrated model (no noise).
% 2. Try setorbitgui, steptune, stepchro, ...
% 3. To run LOCO
%    1. Measure new data
%       >> measlocodata
%       For the model use
%       >> measlocodata('model');
%    2. Build the LOCO input file
%       >> buildlocoinput
%    3. Run LOCO
%       >> loco
%    4. To set back to the machine see setlocodata (may need some work)
%       >> setlocodata
% 4. Try meastuneresp, measchroresp
%    Compare to the model and maybe copy them to the StorageRingOpsData directory.
%    After LOCO it's often better to use the calibrated model.

%% Questions for Greg.

% Are the family modes in umerinit suppose to be in 'Simulator'? If I want
% to grab online values from the machine I would set these to 'Online'??
% What is AO.TUNE ??
% getpvmodel is not working properly with dipoles set as HCM 