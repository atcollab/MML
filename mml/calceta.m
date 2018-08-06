function [d, Dy] = calceta(d, varargin)
%CALCETA - Calculates the dispersion function in physics or hardware units 
%  d = calceta(d,'Hardware')     Calculates dispersion in hardware units (converts if necessary)
%  d = calceta(d,'Physics')      Calculates dispersion in physics  units (converts if necessary)
%
%  When not using structure inputs, assumptions have to be made about the units
%  This function assumes that hardware units are mm/MHz and physics units are meters/Hz
%  [Dx,Dy] = calceta(Dx,Dy,'Physics',mcf,rf)  Converts Dx,Dy from mm/MHz to m/(dp/p)
%                                             ie, was measured using [Dx, Dy] = measdisp('Hardware')
%  [Dx,Dy] = calceta(Dx,Dy,'Hardware',mcf,rf) Converts Dx,Dy from m/(dp/p) to mm/MHz
%                                             ie, was measured using [Dx, Dy] = measdisp('Physics')
%
%  INPUTS
%  1. d (dispersion structure) or Dx and Dy (vectors) as measure by measdisp
%  2. 'Physics'  is a flag to plot dispersion function in physics units
%     'Hardware' is a flag to plot dispersion function in hardware units
%     ('Eta' can be used instead of 'Physics')
%  3. mcf = momentum compaction factor (linear)
%  4. rf  = rf frequency (MHz)
%     rf and mcf input are only for nonstructure inputs when using the 'Physics' flag
%  5. 'Hardware' or 'Physics' - Optional units flags 
%
%  OUTPUTS
%  1. d or [Dx, Dy] is dispersion function with new units
%
%  NOTES
%  1. 'Hardware' and 'Physics' are not case sensitive
%
%  See also measdisp, plotdisp

%  J. Corbett and G. Portmann (August 2003)


UnitsFlag = '';
MCF = [];
RF0 = [];
if nargin > 1
    % Look if 'physics' or 'eta' are on the input line
    for i = length(varargin):-1:1
        if strcmpi(varargin{i},'eta') || strcmpi(varargin{i},'physics')
            UnitsFlag = 'Physics';
            if length(varargin) >= i+1
                if isnumeric(varargin{i+1})
                    MCF = varargin{i+1};
                    if length(varargin) >= i+2
                        if isnumeric(varargin{i+2})
                            RF0 = varargin{i+2};
                        end
                    end
                end
            end
        elseif strcmpi(varargin{i},'Hardware')
            UnitsFlag = 'Hardware';
            varargin(i) = [];    
        elseif isempty(varargin{i})
            % Remove empty
            varargin(i) = [];    
        else
            if ischar(varargin{i})  
                % Unknown string input
                fprintf('   WARNING:  Unknown input ''%s''ignored\n', varargin{i});
                varargin(i) = [];
            end
        end
    end
end

if isempty(UnitsFlag)
    %error('No units string input (Hardware or Physics)');
    UnitsFlag = 'Physics';
end

% Check if the input is a structure
if isstruct(d)
    if length(d) ~= 2
        error('Supply proper structure array to calceta');
    end
    
    MCF = d(1).MCF;
    
    if strcmpi(UnitsFlag,'Physics') && strcmpi(d(1).Units,'Hardware')
        % Change to physics units
        d = hw2physics(d);
        
        % Change to denominator to energy shift (dp/p)
        RF0 = d(1).Actuator.Data;    
        RF0 = RF0(1);  % Just in case someone has a vector for multiple cavities
        d(1).Data = -RF0 * MCF * d(1).Data;
        d(2).Data = -RF0 * MCF * d(2).Data;
        
        d(1).UnitsString = [d(1).Monitor.UnitsString,'/(dp/p)'];
        d(2).UnitsString = [d(2).Monitor.UnitsString,'/(dp/p)'];
    end
    
    if strcmpi(UnitsFlag,'Hardware') && strcmpi(d(1).Units,'Physics')
        % Change to denominator to RF change
        RF0 = d(1).Actuator.Data;    
        RF0 = RF0(1);  % Just in case someone has a vector for multiple cavities
        d(1).Data = d(1).Data / (-RF0 * MCF);
        d(2).Data = d(2).Data / (-RF0 * MCF);
        
        % Change to hardware units
        d = physics2hw(d);
        
        d(1).UnitsString = [d(1).Monitor.UnitsString,'/',d(1).Actuator.UnitsString];
        d(2).UnitsString = [d(2).Monitor.UnitsString,'/',d(2).Actuator.UnitsString];
    end
    Dy = d(2).Data;
    
else
    % Non structure inputs
    Dx = d;
    Dy = varargin{1};
    
    if strcmpi(UnitsFlag,'Physics')
        % Convert to physics units
        if ~isempty(RF0) && ~isempty(MCF)
            % Change units to meters/(dp/p)
            Dx = -RF0(1) * MCF * Dx / 1000;
            Dy = -RF0(1) * MCF * Dy / 1000;
        else
            error('MCF and RF frequency not input');
        end     
    elseif strcmpi(UnitsFlag,'Hardware')
        % Convert to hardware units
        if ~isempty(RF0) && ~isempty(MCF)
            % Change units to mm/MHz
            Dx = 1000 * Dx / (-RF0(1) * MCF);
            Dy = 1000 * Dy / (-RF0(1) * MCF);
        else
            error('MCF and RF frequency not input');
        end     
    else
        error('Output units unknown');
    end
    
    d = Dx;
end
