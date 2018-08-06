function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathbfactory(varargin)
%SETPATHBFACTORY - Initializes the Matlab Middle Layer (MML) for the B-Factory
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathbfactory(SubMachineName, OnlineLinkMethod)
%
%  INPUTS
%  1. SubMachineName - 'LER' or 'HER'
%  2. OnlineLinkMethod - 'MCA', 'LabCA', 'SCA'

%  Written by Greg Portmann


Machine = 'BFactory';
SubMachineName = '';


%%%%%%%%%%%%%%%%%
% Input Parsing %
%%%%%%%%%%%%%%%%%

% First strip-out the link method
LinkFlag = '';
for i = length(varargin):-1:1
    if ~ischar(varargin{i})
        % Ignor input
    elseif strcmpi(varargin{i},'SLC')
        LinkFlag = 'SLC';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'LabCA')
        LinkFlag = 'LabCA';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'MCA')
        LinkFlag = 'MCA';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'SCA')
        LinkFlag = 'SCA';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Tango')
        LinkFlag = 'Tango';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'UCODE')
        LinkFlag = 'UCODE';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'HER')
        SubMachineName = 'HER';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'LER')
        SubMachineName = 'LER';
        varargin(i) = [];
    end
end


% Link default
if isempty(LinkFlag)
    LinkFlag = 'SLC';
end


% Get the submachine name
if isempty(SubMachineName)
    SubMachineName = questdlg('Which Ring?', 'B-Factory', 'HER', 'LER', 'LER');
    drawnow;
end


[MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, SubMachineName, 'StorageRing', LinkFlag);
