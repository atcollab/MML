function [PhaseX, PhaseZ, Sx, Sz, Tune] = modelphase(varargin)
%MODELBETA - Returns the Phase function of the model
%  [PhaseX, PhaseZ, Sx, Sz, Tune] = modelphase(Family1, DeviceList1, Family2, DeviceList2)
%  [PhaseX, PhaseZ, Sx, Sz, Tune] = modelphase(Family1, DeviceList1);
%  [PhaseX, PhaseZ, Sx, Sz, Tune] = modelphase(Family1, Family2)
%  [PhaseX, PhaseZ, Sx, Sz, Tune] = modelphase('All');
%
%  INPUTS
%  1. Family1 and Family2 are the family names for where to measure the horizontal/vertical phase function.
%     A family name can be a middlelayer family or an AT family.  'All' returns phase at every element in the model.
%     {default or []: 'All'}
%  2. DeviceList1 and DeviceList2 are the device list corresponding to Family1 and Family2
%     {default or []: the entire list}
%
%  OUTPUTS
%  1. PhaseX and PhaseZ - Horizontal and vertical phase function [meters]
%  2. Sx and Sz are longitudinal locations in the ring [meters]
%  3. Tune
%
%  NOTE
%  1. Family1 and DeviceList1 can be any family.  For instance, if Family1='VCM'
%     and DeviceList1=[], then PhaseX is the horizontal phase function at the 
%     vertical corrector magnets (similarly for Family2 and DeviceList2).
%  2. If no output exists, the phase function will be plotted to the screen.
%  3. Calls modeltwiss
%
%  See Also modeltwiss, modeltune, modeldisp, modelbeta


if nargout == 0
    modeltwiss('Phase', varargin{:});
else
    [PhaseX, PhaseZ, Sx, Sz, Tune] = modeltwiss('Phase', varargin{:});
end
