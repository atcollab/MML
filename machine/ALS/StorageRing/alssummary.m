function sum = alssummary
%ALSSUMMARY - Prints out the paramters of the current AT lattice
%
%  See also atsummary


global THERING

% 
sum = atsummary;


% Add ALS structure
[Tilt, Eta, EpsX, EpsY, EmittanceRatio, ENV, DP, DL, BeamSize] = calccoupling;



%              sum.DxB1 = 
%              sum.DxB2 = 
%        sum.DxStraight = 
%               sum.MuX = 
%               sum.MuY = 


sum.Emittance = sum.naturalEmittance;
sum = rmfield(sum, 'naturalEmittance');

sum.MCF = sum.compactionFactor;
sum = rmfield(sum, 'compactionFactor');

sum.QD  = getsp('QF', 'Physics',[1 1]);
sum.QF  = getsp('QD', 'Physics',[1 1]);
sum.QFA = getsp('QFA','Physics',[1 1]);

               
i = family2atindex('BEND',[1 1]);
[bx, by] = modelbeta('BEND');
N = size(i,2);

if rem(N,2) == 1
    % Odd
    sum.SigmaXB1 = (BeamSize(1,i(1,floor(N/2))) + BeamSize(1,i(1,ceil(N/2)))) / 2;
    sum.BetaXB1  = (bx(i(1,floor(N/2))) + bx(i(1,ceil(N/2)))) / 2;
    sum.BetaYB1  = (by(i(1,floor(N/2))) + by(i(1,ceil(N/2)))) / 2;
elseif rem(N,2) == 0
    % Even
    sum.SigmaXB1 = BeamSize(1,i(1,N/2+1));
    sum.BetaXB1  = bx(i(1,N/2+1));
    sum.BetaYB1  = by(i(1,N/2+1));
end

i = family2atindex('BEND',[1 2]);
[bx, by] = modelbeta('BEND');
N = size(i,2);
if rem(N,2) == 1
    % Odd
    sum.SigmaXB2 = (BeamSize(1,i(1,floor(N/2))) + BeamSize(1,i(1,ceil(N/2)))) / 2;
    sum.BetaXB2  = (bx(i(1,floor(N/2))) + bx(i(1,ceil(N/2)))) / 2;
    sum.BetaYB2  = (by(i(1,floor(N/2))) + by(i(1,ceil(N/2)))) / 2;
elseif rem(N,2) == 0
    % Even
    sum.SigmaXB2 = BeamSize(1,i(1,N/2+1));
    sum.BetaXB2  = bx(i(1,N/2+1));
    sum.BetaYB2  = by(i(1,N/2+1));
end

sum.SigmaXStraight = BeamSize(1,1);
sum.BetaXStraight = bx(1);
sum.BetaYStraight = by(1);


if nargout == 0
    fprintf('\n');
    fprintf('   ******** AT Lattice Summary ********\n');
    fprintf('   Energy: \t\t\t%4.5f [GeV]\n', sum.e0);
    fprintf('   Gamma: \t\t\t%4.5f \n', sum.gamma);
    fprintf('   Circumference: \t\t%4.5f [m]\n', sum.circumference);
    fprintf('   Revolution time: \t\t%4.5f [ns] (%4.5f [MHz]) \n', sum.revTime*1e9,sum.revFreq*1e-6);
    fprintf('   Betatron tune H: \t\t%4.5f (%4.5f [kHz])\n', sum.tunes(1),sum.tunes(1)/sum.revTime*1e-3);
    fprintf('                 V: \t\t%4.5f (%4.5f [kHz])\n', sum.tunes(2),sum.tunes(2)/sum.revTime*1e-3);
    fprintf('   Momentum Compaction Factor: \t%4.5f\n', sum.compactionFactor);
    fprintf('   Chromaticity H: \t\t%+4.5f\n', sum.chromaticity(1));
    fprintf('                V: \t\t%+4.5f\n', sum.chromaticity(2));
    fprintf('   Synchrotron Integral 1: \t%4.5f [m]\n', sum.integrals(1));
    fprintf('                        2: \t%4.5f [m^-1]\n', sum.integrals(2));
    fprintf('                        3: \t%4.5f [m^-2]\n', sum.integrals(3));
    fprintf('                        4: \t%4.5f [m^-1]\n', sum.integrals(4));
    fprintf('                        5: \t%4.5f [m^-1]\n', sum.integrals(5));
    fprintf('                        6: \t%4.5f [m^-1]\n', sum.integrals(6));
    fprintf('   Damping Partition H: \t%4.5f\n', sum.damping(1));
    fprintf('                     V: \t%4.5f\n', sum.damping(2));
    fprintf('                     E: \t%4.5f\n', sum.damping(3));
    fprintf('   Radiation Loss: \t\t%4.5f [keV]\n', sum.radiation*1e6);
    fprintf('   Natural Energy Spread: \t%4.5e\n', sum.naturalEnergySpread);
    fprintf('   Natural Emittance: \t\t%4.5e [mrad]\n', sum.naturalEmittance);
    fprintf('   Radiation Damping H: \t%4.5f [ms]\n', sum.radiationDamping(1)*1e3);
    fprintf('                     V: \t%4.5f [ms]\n', sum.radiationDamping(2)*1e3);
    fprintf('                     E: \t%4.5f [ms]\n', sum.radiationDamping(3)*1e3);
    fprintf('   Slip factor : \t%4.5f\n', sum.etac);
    fprintf('\n');
    fprintf('   Assuming cavities Voltage: %4.5f [kV]\n', v_cav/1e3);
    fprintf('                   Frequency: %4.5f [MHz]\n', freq/1e6);
    fprintf('             Harmonic Number: %4.5f\n', sum.harmon);
    fprintf('   Overvoltage factor: %4.5f\n', sum.overvoltage);
    fprintf('   Synchronous Phase:  %4.5f [rad] (%4.5f [deg])\n', sum.syncphase, sum.syncphase*180/pi);
    fprintf('   Linear Energy Acceptance:  %4.5f %%\n', sum.energyacceptance*100);
    fprintf('   Synchrotron Tune:   %4.5f (%4.5f kHz or %4.2f turns) \n', sum.synctune, sum.synctune/sum.revTime*1e-3, 1/sum.synctune);
    fprintf('   Bunch Length:       %4.5f [mm]\n', sum.bunchlength*1e3);
end