function setbpmaverages(varargin)
%SETBPMAVERAGES - Sets the BPM sampling period [second] and the number of points for the BPM median calculation.
%  setbpmaverages(varargin)
%  varargin{1} : Data collection period of the BPMs in seconds
%  varargin{2} : Data collection number of points

AD = getad;
if (nargin > 0), AD.SIRIUSParams.control_system_update_period = varargin{1}; end
if (nargin > 1), AD.SIRIUSParams.bpm_nr_points_average = varargin{2}; end
setad(AD);
