function setidbpmavg(IDBPMNumAverages)
% setidbpmavg(IDBPMNumAverages {Default: 2700})
% This function sets up a bunch of storage ring parameters
% 5400 averages corresponds to 1 Hz data rate.
%

% This function is not used any longer (as of 9/02) because no IDBPMs or BBPMs
%		support averaging. Instead the timeconstants are set via setidbpmtimeconstant.m
% 9-25-02, Tom Scarvie

error('This function needs to be repaired to work with the new middle layer software.');


if nargin==0
   IDBPMNumAverages = 2700;
end

IDBPMlist = getlist('IDBPMx');

% IDBPMs do not support averaging anymore, instead use setidbpmtimeconstant ....
% C. Steier, September 2001

% Set the IDBPM averaging
% for i=1:size(IDBPMlist,1)
%   Name = sprintf('SR%02dS___IBPM%dA_AC%d', IDBPMlist(i,1), IDBPMlist(i,2), 97+IDBPMlist(i,2));
%   scaput(Name, IDBPMNumAverages);
% end

% Other IDBPMs
% scaput('SR04S___IBPM3A_AC98', IDBPMNumAverages);
% scaput('SR04S___IBPM4A_AC99', IDBPMNumAverages);

% These channels are not used anymore. Instead, the BBPM timeconstants are set the same
%		as the IDBPM ones via the SRxxS___IBPM___AC00 channels.
% scaput('SR09C___BPM4AT_AC98', IDBPMNumAverages);
% scaput('SR09C___BPM5AT_AC99', IDBPMNumAverages);
