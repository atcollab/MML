function [RawVolt1, RawVolt2, RawVolt3, RawVolt4] = getbpmv(ButtonNumber, NumberOfAverages, newBPMlist);
%  [raw voltage1, 2, 3, 4] = getbpmv(ButtonNumber, NumberOfAverages, BPMlist);
%
%   Inputs:  ButtonNumber (this only controls the first output)
%            Number of averages (10 Hz data rate) (default: 1)
%            BPMlist ([Sector Device #] or [element #]) (default: all BPMs)
%
%   Outputs: raw voltage = raw voltage on the BPM (column vector)
%            Note: if multiple outputs exist, all four button voltages can be extracted
%                  [RawVolt1, RawVolt2, RawVolt3, RawVolt4] = getBPMv(1);
%
 
	if nargin == 0,
		ButtonNumber = 1;
		NumberOfAverages = 1;
		newBPMlist = getlist('BPMx');
	elseif nargin == 1;
		NumberOfAverages = 1;
		newBPMlist = getlist('BPMx');
	elseif nargin == 2;
		newBPMlist = getlist('BPMx');
	end 
	
	if (size(newBPMlist,2) == 1) 
		newBPMlist = elem2dev('BPMx', newBPMlist);
	end

	if nargout >= 1,
		[RawVolt1] = vecbpmv(ButtonNumber, newBPMlist(:,1), newBPMlist(:,2), NumberOfAverages);    
	end

	if nargout >= 2,
		[RawVolt2] = vecbpmv(2, newBPMlist(:,1), newBPMlist(:,2), NumberOfAverages);    
	end
		
	if nargout >= 3,
		[RawVolt3] = vecbpmv(3, newBPMlist(:,1), newBPMlist(:,2), NumberOfAverages);    
	end

	if nargout >= 4,
		[RawVolt4] = vecbpmv(4, newBPMlist(:,1), newBPMlist(:,2), NumberOfAverages);    
	end




	