function [DCCT, LifeTime, dIdt] = getdcct(varargin)
%GETDCCT - Returns the beam current
%  [DCCT, LifeTime, dIdt] = getdcct(NumberOfAverages);
%
%  INPUTS
%  1.  NumberOfAverages = number of lifetime averages
%  2. 'Struct' will return a data structure
%     'Numeric' will return numeric outputs {Default for}
%  3. 'Online' - Get data online (optional override of the mode)
%     'Model'  - Get data from the model (optional override of the mode)
%     'Manual' - Get data manually (optional override of the mode)
%
%  OUTPUTS
%  1.  DCCT = storage ring electron beam current [mAmps]
%  2.  LifeTime [hours]
%  3.  dIdt = the change in current as measured by the Keithley [mAmps/sec]
%
%  NOTE
%  1. Simulation mode: lifetime is 6 hour, refill at midnight to 1000 mamps


ModeFlag = getmode('DCCT');
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'struct')
        % Remove and ignor
        varargin(i) = [];
    elseif strcmpi(varargin{i},'numeric')
        % Remove and ignor
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Online')
        ModeFlag = 'Online';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Manual')
        ModeFlag = 'Manual';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'simulator') | strcmpi(varargin{i},'model')
        ModeFlag = 'simulator';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'physics')
        varargin(i) = [];
    elseif strcmpi(varargin{i},'hardware')
        varargin(i) = [];
    end
end

if length(varargin) >= 1
    NumberOfAverages = varargin{1};
end

if strcmpi(ModeFlag,'Simulator')
    
    DCCT = getam('DCCT', varargin{:}); 
    LifeTime = 6;
    dIdt = -DCCT/6;
    
elseif strcmpi(ModeFlag,'Manual')
    
    DCCT = getam('DCCT', 'Manual'); 
    LifeTime = NaN;
    dIdt = NaN;
    
else
    
    if nargin == 1
        setsp('SR05W___DCCT2__AC00', NumberOfAverages);
    end
    
    %DCCT = getam('DCCT', varargin{:}); 
    DCCT = 1000 * getam('SR05W___DCCT2__AM01');
    
    
    if nargout >= 2
        LifeTime = getam('SR05W___DCCT2__AM00');
    end
    
    
    if nargout >= 3
        dIdt = 1000*getam('SR05W___DCCT2__AM02');
    end
end