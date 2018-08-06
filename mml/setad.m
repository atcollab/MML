function  setad(AD)
%SETAD - Sets the MML AcceleratorData cell array to appdata
%  setad(AD)
%
%  INPUTS 
%  1. Accelerator Data Structure
%
%  See also getad, setao

setappdata(0, 'AcceleratorData', AD);

