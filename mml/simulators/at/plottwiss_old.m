function plottwiss(varargin)
%PLOTTWISS - Plot the optical functions and tune of the present lattice


%[TD, Tune] = twissring(RING,0,1:(length(RING)+1),'chrom');

[BetaX, BetaY, Sx, Sy, Tune] = modeltwiss('Beta', 'All');
[EtaX, EtaY] = modeltwiss('Eta', 'All');


%figure
clf reset;
plot(Sx, BetaX, '-b');
hold on;
plot(Sy, BetaY, '-r');
plot(Sx, 100*EtaX, '-g');
plot(Sy, 100*EtaY, '-m');

% Add BPM dots
try
    [EtaBPMX, EtaBPMY] = modeltwiss('Eta', gethbpmfamily, getvbpmfamily);
    [BetaBPMX, BetaBPMY, SBPMx, SBPMy, Tune] = modeltwiss('Beta', gethbpmfamily, getvbpmfamily);
    plot(SBPMx, BetaBPMX, '.b');
    plot(SBPMy, BetaBPMY, '.r');
    plot(SBPMx, 100*EtaBPMX, '.g');
    plot(SBPMy, 100*EtaBPMY, '.m');
catch
end

xlabel('Position [meters]');
%ylabel('[meters]');
title(sprintf('Optical Functions ({\\it \\nu_x} = %5.3f, {\\it \\nu_y} = %5.3f)', Tune(1),Tune(2)));
axis tight;


% Plot 1 sector
a = axis;
N = getnumberofsectors;
L = getfamilydata('Circumference');
if ~isempty(L) && ~isempty(N)
    a(2) = L / N;
end

% Make room for the lattice
DeltaY = a(4) - a(3);
a(3) = a(3) - .12 * DeltaY;
axis(a);


% Draw the lattice
a = axis;
drawlattice(a(3)+.06*DeltaY, .05*DeltaY);
axis(a);
hold off;


legend('{\it\beta_x [meters]}','{\it\beta_y [meters]}','{\it\eta_x [cm]}','{\it\eta_y [cm]}',0);
%legend('{\it\beta_x}','{\it\beta_y}','{\it\eta_x \times 100}','{\it\eta_y \times 100}',0);

