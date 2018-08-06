function [X Z Q Sum Va Vb Vc Vd] = readbpm(varargin)
% READBPM - Gets turn by turn sample data for one BPM 
%
%  INPUTS
%  1. num - bpm number 
%  Optionnal
%  Display/NoDisplay
%
%  OUTPUTS
%  1. X - Horizontal data
%  2. Z - Vertical data
%  3. Q - Quadrupole signal data
%  4. Sum - Sum signal data
%  5. Va electrode data
%  6. Vb electrode data
%  7. Vc electrode data
%  8. Vd electrode data
% 
%
% See Also getbpmrawdata

%
%  Written by Laurent S. Nadolski

DisplayFlag = 1;

for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    end
end

if isempty(varargin)
   error('Give a BPM number') 
else
    num = varargin{1};
end

AO=getao;

attr_name = ...
   {'XPosVector','ZPosVector', 'QuadVector', 'SumVector', ...
    'VaVector', 'VbVector', 'VcVector', 'VdVector'};

rep = tango_read_attributes(AO.BPMx.DeviceName{num},attr_name);

X   = rep(1).value;
Z   = rep(2).value;
Q   = rep(3).value;
Sum = rep(4).value;
Va  = rep(5).value;
Vb  = rep(6).value;
Vc  = rep(7).value;
Vd  = rep(8).value;

if DisplayFlag

    subplot(2,2,1)
    plot(X)
    ylabel('X (mm)')
    grid on

    subplot(2,2,2)
    plot(Z)
    ylabel('Z (mm)')
    grid on

    subplot(2,2,3)
    plot(Sum)
    ylabel('SUM')
    xlabel('turn number')
    grid on

    subplot(2,2,4)
    plot(Q)
    ylabel('Q')
    xlabel('turn number')
    grid on

    suptitle(sprintf('Turn by turn data for %s',AO.BPMx.DeviceName{num}))
end
