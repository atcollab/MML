
XOrbitHandle = mcaopen('spr:zc1/xx1'); % Multiple PVs - multiple handles 
%
% MCAOPEN() establish a channel to a PV or group of PVs, assign integer 
% handles
% Multiple PVs - multiple handles 
[XOrbitHandle, YOrbitHandle] = mcaopen('spr:zc1/xx1','spr:zc2/xx1'); 

% Automatiacally get this whe input is a {:}
% cell array of PV names - cell array of Handles
CorrPVNames = {'spr:...','spr: ..','...');
CorrHandles = cell(1,length(CorrPVNames));
CorrValues = cell(1,length(CorrPVNames));
[CorrHandles{:}]=mcaopen(CorrPVNames{:});  

% To simply return an array of integer handles
CorrHandlesArray = mcaopen(CorrPVNames)

% MCAISOPEN(NAME) % serches locally for previously open cahnnels
%  if a channel is founnd, returns its handle,
%  otherwise returns 0

XOrbitHandle = mcaisopen('spr:zc1/xx1')
if ~XOrbitHandle
    XOrbitHandle = mcaopen('spr:zc1/xx1');
end

% MCAGET()

XOrbit = mcaget(XOrbitHandle); % single handle get

[XOrbit, YOrbit] = mcaget(XOrbitHandle,YOrbitHandle); % multiple handle get

[CorrValues{:}]=mcaget(CorrHandles{:}); % cell array of handles 

% MCAPUT

mcaput(Handle1,0.01); % single handle, 1 value 

mcaput(Handle1,0.01,Handle2,0.01); % multiple handles - multiple values

mcaput(CorrHandles,CorrValues); % cell arrays of handles and values


% MCATIMEOUT() - one of the functions for fine-tuning MATLAB-CA interface
mcatimeout('io',0.1,'poll',0.0001,'event',1);
mcatimout('default');

% -------------------------------------------------------------------------------
% Asynchronous features

%MCAMONITOR(handle1, .. , handleN)
%MCAMONITORCALLBACK(HANDLE,COMMANDSTRING,ARGS)
%MCACLEARMONITOR(handle1, .. ,handleN)

%MCATIMER
%MCATIMER

%[var1 .. varM] = mcamonitor(handle1 ... handleN) - set a
% monitor wirh callback function that synchronizes the
% value of a PV with a variable in MATLAB workspace
% The sync