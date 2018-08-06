function varargout = cavityoff(varargin)
%CAVITYOFF - Turns all cavities off
%  Sets PassMethod to DriftPass or IdentityPass depending
%  on the value of 'Length' field
%
%  See also cavityon, radiationon, radiationoff


if ~evalin('base','exist(''THERING'')') % || ~evalin('base','isglobal(THERING)');
   error('Global variable THERING could not be found');
end

global THERING

localcavindex = findcells(THERING,'Frequency');

if isempty(localcavindex)
   error('No cavities were found in the lattice');
end


for ii = localcavindex
   if THERING{ii}.Length == 0;
      THERING{ii}.PassMethod = 'IdentityPass';
   else
      THERING{ii}.PassMethod = 'DriftPass'; 
   end
end

disp(strcat('Cavities located at index  [',num2str(localcavindex),  ']  were turned OFF'))     
clear ii localcavindex