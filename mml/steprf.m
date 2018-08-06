function steprf(varargin)
%STEPRF - Increment change in the RF frequency
%  steprf(DelRF, WaitFlag)
%
%  INPUTS
%  1. DelRF = Change in RF frequenc
%  2. WaitFlag = 0    -> return immediately {SLAC default}
%                > 0  -> wait until ramping is done then adds an extra delay equal to WaitFlag 
%                = -1 -> wait until ramping is done
%                = -2 -> wait until ramping is done then adds an extra delay for fresh data 
%                        from the BPMs  {ALS default}
%                = -3 -> wait until ramping is done then adds an extra delay for fresh data 
%                        from the tune measurement system
%                = -4 -> wait until ramping is done then wait for a carriage return
%  3. 'Physics'  - Use physics  units (optional override of units)
%     'Hardware' - Use hardware units (optional override of units)
%     The actual physics or hardware strings can also be used.  
%     For example, if the physics and hardware modes corresponds 
%     to Hz and MHz then strings 'Hz' or 'MHz' can be used to specify units.
%  4. 'Online' - Set data online (optional override of the mode)
%     'Model'  - Set data on the model (optional override of the mode)
%     'Manual' - Set data manually (optional override of the mode)
%
%  setrf converts a string input to a number, hence, setrf 476.3 is the same as setrf(476.3)
%
%  EXAMPES
%  1. steprf(10000, 'Hz')  or  steprf 1000 Hz  => changes the RF frequency 10000 Hz
%  2. steprf(.01, 'MHz')   or  steprf .01 MHz  => changes the RF frequency 10000 Hz
%
%  NOTES
%  1. 'Hardware', 'Physics', 'MHz', 'Hz', 'Numeric', and 'Struct' are not case sensitive

%  Written by Greg Portmann


if nargin < 1
    error('No RF frequency input');
end

varargin{end+1} = 'Incremental';

setrf(varargin{:});

