function setangle4(varargin)
%SETANGLE4 - Set an orbit angle using 4 correctors in H or V
%  in the middle of the straigth on the top of the present orbit
%
%  INPUTS
%  1. IDnum straight section number  1 is injection straigth
%  2. plane  1 for horizontal {default}
%           2 for vertical
%  3. angle  size in mrad Default : 0.5 mrad
%  4. percent percent to apply 100% {default}
%                 
%  OUPUTS
%
%  NOTES
%  1. use orbit golden response matrix
%  2. Straight list
%     1 injection straight section
%
%  See Also setbump4, set4correctorbump

% Maximum aplitude possible in straigth sections
% Long = circa 0.5 mrad H - 0.28 mrad V
% Medium = circa 0.6 mrad H - 0.3 mrad V
% Short = circa 1.1 mrad H  - 0.4 mrad V 
% 

% 10 septembre 2004
% Written Laurent S. Nadolski

set4correctorbump(varargin{:},'Angle');