function [Dx, Dy, Sx, Sy, h] = ploteta(varargin)
% PLOTETA plots UNCOUPLED! eta-functions
%
%  INPUTS
%  0. PLOTETA with no argumnts uses THERING as the default lattice
%  1. RING - PLOTETA(RING) calculates eta functions of the lattice RING
% 
%  NOTES
%  1. PLOTETA uses FINDORBIT4 and LINOPT which assume a lattice
%     with NO accelerating cavities and NO radiation
%
%  See also modeltwiss, plottwiss, plotcod, plotbeta 


if nargout == 0
    modeldisp(varargin{:}, 'Drawlattice');
else
    [Dx, Dy, Sx, Sy, h] = modeldisp(varargin{:}, 'Drawlattice');
end



% % Written by Andrei Terebilo
% % Modified by Laurent S. Nadolski
% 
% if nargin == 0
% 	global THERING
% 	RING = THERING;
% end
% 
% [TD, tune] = twissring(THERING,0,1:length(THERING)+1,'chroma');
% ETA        = cat(2,TD.Dispersion)';
% S          = cat(1,TD.SPos);
% 
% disp(tune)
% 
% % figure
% % plot betax and betay in two subplots
% 
% h1 = subplot(5,1,[1 2]);
% plot(S,ETA(:,1),'.-b');
% ylabel('\eta_x [m]');
% xlim([0 S(end)]);
% 
% title('Dispersion functions');
% 
% h2 = subplot(5,1,3);
% drawlattice 
% set(h2,'YTick',[])
% 
% h3 = subplot(5,1,[4 5]);
% plot(S,ETA(:,3),'.-r');
% xlabel('s - position [m]');
% ylabel('\eta_z [m]');
% 
% linkaxes([h1 h2 h3],'x')
% set([h1 h2 h3],'XGrid','On','YGrid','On');
