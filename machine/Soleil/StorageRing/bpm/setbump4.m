function setbump4(varargin)
%SETBUMP4 - Set an orbit bump using 4 correctors in H or V
%  on the top of the present orbit
%
%  INPUTS
%  1. IDnum straight section number  1 is injection straigth
%  2. plane  1 for horizontal {default}
%            2 for vertical
%  3. pos bump size in mm Default : 0.5 mm
%  4. percent percent to apply 100% {default}
%                 
%  NOTES
%  1. use orbit golden response matrix
%  2. Straight list
%     1 injection straight section
%  3. In model, should use fixed momentum Orbit response matrix
%
%  See Also setangle4, set4correctorbump

%  Maximum aplitude possible in straigth sections
%  Long = circa 3 mm (H) -
%  Medium = circa 2 mm (H) - 1.2 mm (V)
%  Short = circa 4 mm (H) -
% 

% 7 septembre 2004
% Written by Laurent S. Nadolski

set4correctorbump(varargin{:},'Position');