function imgload

% Create figure for storing data
h = figure('Visible', 'off','tag','h1');
handles = guihandles(h);
%Load Images for patches
% a = imread('aperture','jpeg'); % Aperture
% d = imread('drift','jpeg'); % Drift
c = imread('corrector1','jpeg'); % Corrector
% q = imread('quad', 'jpeg'); % Quadrupole
% b = imread('bpm','jpeg'); % BPM or Bend
% s = imread('sext','jpeg'); % Sextupole

%Store image information in application data
% guidata(h, a);
% guidata(h, b);
guidata(h, c);
% guidata(h, q);
% guidata(h, b);
% guidata(h, s);




% Handles info
% GUIDATA(H, DATA)
% DATA = GUIDATA(H)