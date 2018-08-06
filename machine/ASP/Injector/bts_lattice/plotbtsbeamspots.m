function varargout = plotbtsbeamspots(varargin)
% SPOTSIZE = PLOTBTSBEAMSPOTS
%
% The function assumes some values for deltaE and the transverse emittances
% and calculates the beamsizes at the screens. The function will plot the
% optical functions as well as simulated beam images.
%
% Mark Boland 2006-08-15
% Eugene Tan  2006-08-21: Modified a little to utilise the new plotbts

global THERING

% Switch THERING to the BTS
getam('BTS_BEND','Model');

numscreens = 4;
screennames = {'scr1', 'scr2','scr3','scr4'};

for i=1:numscreens
    I_screen(i) = findcells(THERING,'FamName',screennames{i});
end

% plot and calculate the Twiss parameters
td = plotbts('nonames');

%% calculate beam sizes at the screens
% from linac measurements 2006-08-14
deltaE = 0.005;
epsilonx = 50e-9;
epsilony = epsilonx*0.1; % Assume 10% coupling

% screen spot size
for i=1:numscreens
    betax(i) = td.betax(I_screen(i));
    betay(i) = td.betay(I_screen(i));
    etax(i) = td.etax(I_screen(i));
    etay(i) = td.etay(I_screen(i));
    sigmax(i) = sqrt(betax(i)*epsilonx + (etax(i)*deltaE)^2)/1e-3;
    sigmay(i) = sqrt(betay(i)*epsilony + (etay(i)*deltaE)^2)/1e-3;

    %% generate the beam spot plots
    [X,Y] = meshgrid([-30:0.1:30],[-30:0.1:30]);
    Z = exp(-(X./(2*sigmax(i))).^2-(Y./(2*sigmay(i))).^2);
    % surf(X,Y,Z)
    % Position the simulated beam spot images at the screens.
    axes('position',[(td.spos(I_screen(i))/(td.spos(end)*1.18)+0.05) 0.05 .1 .1])
    imagesc(Z)
    view(2)
    grid off
    axis equal
    axis off
    colormap(gray(256))
    shading interp
    set(gca,'Color',[0 0 0])
    
    spotsize.screen(i,:) = [sigmax(i) sigmay(i)];
end

if nargout == 1
    varargout{1} = spotsize;
end