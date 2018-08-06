
% Isochronous Sections Shift
% 1. run alsinit and setoperationalmode in the new matlab7 middlelayer.
% 2. run srinit 
%    This should set BSC ramp rate to .4, if not:
%    or setpv('BEND','RampRate',.4,[4 2;8 2;12 2]);
%    or setsp('BSCramprate', .4)  % Old middle layer
% 3. Load the new golden orbit -> BPM_2005-09-18_Golden.mat
% 4. Load the best lattice (you can try ramping to the injection lattice from the new middle layer only)
%    Note: make sure Sector 6 chicane is off
% 5. Turn off the sextupole power supplies.
% 6. setlocodata -> Symmetry Correction -> /home/als/physdata/matlab/alsdata/IsochronousSections/LOCO/2005-08-15/Run2/LOCO_IS_SkewQuadsByPS.mat
%    Note: the AT lattice must already be set properly (setoperationalmode) 
% 7. setlocodata -> Coupling Correction -> /home/als/physdata/matlab/alsdata/IsochronousSections/LOCO/2005-08-15/Run2/LOCO_IS_SkewQuadsByPS.mat
% 8. More LOCO runs
%    Note:  HCM(3,10) seems to have a setting issue.  It was removed from the LOCO runs.  Run magstep on it to check it.
% 9. Injection bump?
%
% NOTE
% 1. Remember to save the lattice as the injection lattice.  The
%    production lattice is the 1.9 GeV lattice (for now).


