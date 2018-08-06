function samplehistoryplot
% function samplehistoryplot
% samplehistoryplot plots the impedance of the waveguide as a function of
%  waveguide pressure for a given ambient temperatures
%  to demonstrate the use of readhistplotfile

[l33, n33, d33] = readhistplotfile( 'z10s11f33.dat' );

% find indices of data in data array
indP33 = find( strcmp( n33, 'WG_10S11_PRES' ) );
indV33 = find( strcmp( n33, '10S11_TOTAL_GV' ) );
indI33 = find( strcmp( n33, 'DCCT' ) );
indT33 = find( strcmp( n33, 'WG_AMB' ) );

figure(1); clf;
plot( d33(:,indP33), 1e3*d33(:,indV33)./d33(:,indI33) );
v = axis;  axis( [ 4 10 v(3:4) ] );
xlabel( '10S11 waveguide pressure (inches H_2O)' );
ylabel( 'fundamental impedance (M\Omega)' );
title( [datestr(l33(1),0), ...
		'    10S11 Cavity Impedance vs Waveguide Pressure at T = ', ...
		num2str( mean(d33(:,indT33)) ), '^oC' ] );
return
