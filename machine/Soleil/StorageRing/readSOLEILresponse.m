function varargout = ReadSOLEILResponse(DirSpec,FileName,mode)
% Reads SOLEIL response matrix from file (or .mat file)
%12/09/03 ib and ic return full complement

%
% Written by Spear People
% Adapted by Laurent S. Nadolski

DirSpec=char(DirSpec);
FileName=char(FileName);
mode=char(mode);

BPMxFamily = 'BPMx';
BPMzFamily = 'BPMz';
HCORFamily = 'HCOR';
VCORFamily = 'VCOR';

disp(['loading response matrix file ' [DirSpec FileName]]);

temp = getbpmresp(BPMxFamily, BPMzFamily, HCORFamily, VCORFamily, 'Struct');

%=============================  
%load horizontal rsp structure
%=============================  
rsp(1).ib=dev2elem(BPMxFamily,temp(1,1).Monitor.DeviceList);     % horizontal BPM index list
bpmelem=dev2elem(BPMxFamily,getlist(BPMxFamily,1));              % valid BPM element list
ntbpm=size(getlist(BPMxFamily,0),1);                             % total number of horizontal BPMs

rsp(1).ic=dev2elem(HCORFamily,temp(1,1).Actuator.DeviceList);    % horizontal corrector index list
corelem=dev2elem(HCORFamily,getlist(HCORFamily,1));              % valid COR element list
ntcor=size(getlist(HCORFamily,0),1);                             % total number of horizontal correctors

rsp(1).c=zeros(ntbpm,ntcor);                                     % generate full size matrix
rsp(1).c(:) = deal(NaN);                                         % load matrix with NaNs
rsp(1).c(bpmelem,corelem)=temp(1,1).Data;                        % load valid data

rsp(1).cur=temp(1,1).ActuatorDelta;                              % horizontal corrector currents

%=============================  
%load vertical rsp structure
%=============================  

rsp(2).ib=dev2elem(BPMzFamily,temp(2,2).Monitor.DeviceList);     % vertical BPM index list
bpmelem=dev2elem(BPMzFamily,getlist(BPMzFamily,1));              % valid BPM element list
ntbpm=size(getlist(BPMzFamily,0),1);                             % total number of vertical BPMs

rsp(2).ic=dev2elem(VCORFamily,temp(2,2).Actuator.DeviceList);    % vertical corrector index list
corelem=dev2elem(VCORFamily,getlist(VCORFamily,1));              % valid COR element list
ntcor=size(getlist(VCORFamily,0),1);                             % total number of vertical correctors

rsp(2).c=zeros(ntbpm,ntcor);                                     % generate full size matrix
rsp(2).c(:) = deal(NaN);                                         % load matrix with NaNs
rsp(2).c(bpmelem,corelem)=temp(2,2).Data;                        % load valid data

rsp(2).cur=temp(2,2).ActuatorDelta;                            %vertical corrector currents

varargout{1}=rsp;