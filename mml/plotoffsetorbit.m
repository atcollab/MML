function plotoffsetorbit(varargin)
%PLOTOFFSETORBIT - Plots the offset orbit 
%  plotoffsetorbit(XAxisFlag)
%
%  INPUTS
%  1. XAxisFlag - 'Position' in meters {Default} or 'Phase'
%
%  See also plotgoldenorbit, setoffset, getoffset, saveoffsetorbit

%  Written by Greg Portmann
%  Modifed by Laurent S. Nadolski

XAxisFlag = 'Position';

% Input parsing
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'struct')
        % Just remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'numeric')
        % Just remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Position')
        XAxisFlag = 'Position';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Phase')
        XAxisFlag = 'Phase';
        varargin(i) = [];
    end
end


BPMxFamily = gethbpmfamily;
BPMyFamily = getvbpmfamily;

if strcmpi(XAxisFlag, 'Phase')
    [BPMxspos, BPMyspos, Sx, Sy, Tune] = modeltwiss('Phase', BPMxFamily, [], BPMyFamily, []);
    BPMxspos = BPMxspos/2/pi;
    BPMyspos = BPMyspos/2/pi;
    XLabel = 'BPM Phase';
else
    BPMxspos = getspos(BPMxFamily,family2dev(BPMxFamily));
    BPMyspos = getspos(BPMyFamily,family2dev(BPMyFamily));
    XLabel = 'BPM Position [meters]';
end


% Get data
Xoffset = getoffset(BPMxFamily);
Yoffset = getoffset(BPMyFamily);


% Change to physics units
if any(strcmpi('Physics',varargin))
    Xoffset = hw2physics(BPMxFamily, 'Monitor', Xoffset, family2dev(BPMxFamily));
    Yoffset = hw2physics(BPMyFamily, 'Monitor', Yoffset, family2dev(BPMyFamily));
end

UnitsString = getfamilydata('BPMx','Monitor','HWUnits');

clf reset
subplot(2,1,1);
plot(BPMxspos, Xoffset, '.-');
ylabel(sprintf('Horizontal [%s]',UnitsString));
title('Offset Orbit');
grid on;

subplot(2,1,2);
plot(BPMyspos, Yoffset, '.-');
xlabel(XLabel);
ylabel(sprintf('Vertical [%s]',UnitsString));
grid on;

orient tall

