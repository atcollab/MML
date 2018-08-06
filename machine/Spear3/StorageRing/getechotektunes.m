function [nux, nuy, nus, varargout] = getechotektunes(cpldata, varargin)
%measure tunes nux, nuy and nus from Echotek data
%[nux] = getechotektunes(cpldata)
%[nux, nuy] = getechotektunes(cpldata, winx, winy)	
%[nux, nuy, nus] = getechotektunes(cpldata, winx, winy, wins)	
%	cpldata, 4xN complex vector,  echotek data as saved, e.g.,  cpldata = data(1:4,1:N, rfindex, kickindex);
%	winx, winy, wins = [low, high], a window within which the tunes to be found
%by default, winx = [0.05, 0.2], winy=[0.16, 0.3], wins=[0.001, 0.02]
%modified 6/21/2007 to add the option to use NAFF

method = 'IPFAW'; %'NAFF'; 

% winx = [0.05, 0.2];
winx = [0.11, 0.15];
if nargin>=2
	winx = varargin{1};
end
% winy=[0.16, 0.3]
winy=[0.20, 0.24]; 
if nargin>=3
	winy = varargin{2};
end
wins=[0.001, 0.02];
if nargin>=4
	wins = varargin{3};
end


[x, y] = xyechotek(cpldata);  

	Phase = angle(cpldata(1,:));  %phase
    switch method
        case 'IPFAW'
        	[amps, nus] = ipfaw(Phase, wins, 1);  
        case 'NAFF'
            [nus,amps] = naff(Phase', wins);  
    end
	if (norm(x))==0
		ampx = 0; nux = 0;
    else
        switch method
        case 'IPFAW'
        	[ampx, nux] = ipfaw(x, winx, 1);  
        case 'NAFF'
            [nux,ampx] = naff(x', winx);  
        end
    end
		 
	if (norm(y))==0
		ampy = 0; nuy = 0;
	else
        switch method
        case 'IPFAW'
    		[ampy, nuy] = ipfaw(y, winy, 1);   
        case 'NAFF'
            [nuy,ampy] = naff(y', winy);  
        end
	end
	
if nargout>=4
	
	      goodx = 0;
            goody = 0;
            goods = 0;  
	
			N = length(x);	
	            aft = abs(fft(x-mean(x)));
	            xnoise = median(aft);
       		
       		aft = abs(fft(y-mean(y)));
	            ynoise = median(aft);
	            
	            aft = abs(fft(Phase-mean(Phase)));
	            snoise = median(aft);
       
	            if abs(ampx)*N > 6 * xnoise 
	               goodx = 1;
	            end
	            if abs(ampy)*N > 4 * ynoise 
	               goody = 1;
	            end
	            if abs(amps)*N > 4 * snoise 
	               goods = 1;
	            end
	stat.x = [nux, ampx, xnoise, goodx];
	stat.y = [nuy, ampy, ynoise, goody];
	stat.s = [nus, amps, snoise, goods];
	
	varargout{1} = stat;
	
end