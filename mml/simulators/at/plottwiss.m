function [ax, h1, h2] = plottwiss(varargin)
%PLOTTWISS - Plot the optical functions and tune of the present lattice


%[TD, Tune] = twissring(RING,0,1:(length(RING)+1),'chrom');

[BetaX, BetaY, Sx, Sy, Tune] = modeltwiss('Beta', 'All');
%BetaX(1), BetaY(1)

[EtaX, EtaY] = modeltwiss('Eta', 'All');
%EtaX(1), EtaY(1)

[N, Nsymmetry] = getnumberofsectors;
L = getfamilydata('Circumference');
Lsector = L / Nsymmetry;

if Nsymmetry >= 2
    i = 1:length(Sx);
    i(find(Sx > Lsector)) = [];
    i(end+1) = i(end) + 1;
else
    i = 1:length(Sx);    
end

%figure
clf reset;
[ax,h1,h2] = plotyy(Sx(i), [BetaX(i) BetaY(i)], Sx(i), EtaX(i));

xlabel('Position [meters]');
%ylabel('[meters]');
title(sprintf('Optical Functions ({\\it\\nu_x} = %5.3f, {\\it\\nu_y} = %5.3f)', Tune(1),Tune(2)));
%axis tight;

set(get(ax(1),'ylabel'),'string','{\it\beta}  [meters]');
%set(get(ax(1),'ylabel'),'string','{\it\beta_x}   {\it\beta_y  [meters]}');
set(get(ax(2),'ylabel'),'string','{\it\eta_x [meters]}');


% Plot 1 sector
axes(ax(2));
%axis tight;
a2 = axis;
if ~isempty(L) && ~isempty(N)
    a2(1) = 0;
    a2(2) = Lsector;
end

% Make room for the lattice
DeltaY = a2(4) - a2(3);
a2(3) = a2(3) - .12 * DeltaY;
%a2(4) = a2(4) + .08 * DeltaY;
axis(a2);

axes(ax(1));
%axis tight
a1 = axis;
if ~isempty(L) && ~isempty(N)
    a1(2) = Lsector;
end

% Make room for the lattice
DeltaY = a1(4) - a1(3);
a1(3) = a1(3) - .12 * DeltaY;
%a1(4) = a1(4) + .08 * DeltaY;
axis([a2(1:2) a1(3:4)]);


% Draw the lattice
a = axis;
hold on;
drawlattice(a(3)+.06*DeltaY, .05*DeltaY, ax(1), Lsector);
axis(a);
hold off;


legend('{\it\beta_x}', '{\it\beta_y }', 'Location', 'Best');

ax(end+1) = gca;
linkaxes(ax, 'x');

axes(ax(2));


