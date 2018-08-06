function [nux,nuy,ampx,ampy] = findfreq_tuneguess(fadx,fady,guessx,guessy,range)
%FINDFREQ - Finds the tunes via an FFT of turn-by-turn data
%
%  [nux,nuy,ampx,ampy] = findfreq_tuneguess(fadx,fady,guessx,guessy,range)
%
%  This function calculates the tunes and the amplitude of the peak
%  for given transverse oscillation data (turn-by-turn) by
%  using an FFT with sine window and interpolation.
%
%  INPUTS
%  1. fadx - Horizontal turn-by-turn data (number of BPMs and number of turns is variable)
%  2. fady - Vertical   turn-by-turn data
%  3. guessx - guess for horizontal tune
%  4. guessy - guess for vertyical tune
%  5. range - search range around tune guesses
%  
%
%  OUTPUTS
%  1-2. nux, nuy   - the two transverse betatron tunes
%  3-4. ampx, ampy - the peak amplitudeS

%  Christoph Steier, July 1999
%  Modified by Laurent S. Nadolski, 2006

if nargin < 5
    error('need 5 input arguments');
end

sfx = size(fadx);
sfy = size(fady);

% substract average value from the data
mfadx = fadx - ones(sfx(1),1)*mean(fadx);
mfady = fady - ones(sfy(1),1)*mean(fady);

% compute fft amplitude for turn by turn data
fftx = abs(fft(mfadx));
ffty = abs(fft(mfady));

% minx=int32(sfx(1)/20);
% miny=int32(sfy(1)/20);
% dminx=double(minx);
% dminy=double(miny);
maxx = int32(sfx(1)/2);
maxy = int32(sfy(1)/2);
dmaxx = double(maxx);
dmaxy = double(maxy);

xmin = round((guessx-range/2)*dmaxx*2);
xmax = round((guessx+range/2)*dmaxx*2);
ymin = round((guessy-range/2)*dmaxy*2);
ymax = round((guessy+range/2)*dmaxy*2);

% look for maximum peak in data
[dummy,indx] = max(fftx(xmin:xmax,:));
[dummy,indy] = max(ffty(ymin:ymax,:));

indx=indx+xmin;
indy=indy+ymin;

dmaxx = indx + 5;
dminx = indx - 5;
dmaxy = indy + 5;
dminy = indy - 5;

% data with a sine window
sfadx = mfadx.* (ones(sfx(2),1)*sin(pi*[0:1/(sfx(1)-1):1]))';
sfady = mfady.* (ones(sfy(2),1)*sin(pi*[0:1/(sfy(1)-1):1]))';

% fft of turn by turn data convoluted by a sine window
fftx = abs(fft(sfadx));
ffty = abs(fft(sfady));


[dummy,indx] = max(fftx(dminx:dmaxx,:));
[dummy,indy] = max(ffty(dminy:dmaxy,:));

indx = indx + dminx;
indy = indy + dminy;

idx = [];
ampx = []; ampx2 = [];

for n = 1:sfx(2)

	if indx(n) == 1
		indx1=2; indx3=2;
	elseif indx(n) == (sfx(1)/2)
		indx1=(sfx(1)/2-1); indx3=(sfx(1)/2-1);
	else
		indx1=indx(n)-1; indx3=indx(n)+1;
	end

	if (fftx(indx3,n)>fftx(indx1,n))
		ampx(n) = fftx(indx(n),n); ampx2(n) = fftx(indx3,n);
		idx(n) = indx(n);
	else
		ampx(n) = fftx(indx1,n); ampx2(n) = fftx(indx(n),n);
		if (indx(n) ~= 1)
			idx(n) = indx1;
		else
			idx(n) = 0;
		end
	end
end

nux = 1/(sfx(1)) * (idx-1 + (2*ampx2./(ampx+ampx2)) - 0.5);

idy = [];
ampy = []; ampy2 = [];

for n = 1:(sfy(2))
	if indy(n) == 1
		indy1=2; indy3=2;
	elseif indy(n) == (sfy(1)/2)
		indy1=(sfy(1)/2-1); indy3=(sfy(1)/2-1);
	else
		indy1=indy(n)-1; indy3=indy(n)+1;
	end

	if (ffty(indy3,n)>ffty(indy1,n))
		ampy(n) = ffty(indy(n),n); ampy2(n) = ffty(indy3,n);
		idy(n) = indy(n);
	else
		ampy(n) = ffty(indy1,n); ampy2(n) = ffty(indy(n),n);
		if (indy(n) ~= 1)
			idy(n) = indy1;
		else
			idy(n) = 0;
		end
	end
end

nuy = 1/sfy(1) * (idy-1 + (2*ampy2./(ampy+ampy2)) - 0.5);

ampx = 2 * diag(fftx(indx,:),0)' ...
./( sin(pi*(indx-1+0.5-nux*sfx(1)))./(pi*(indx-1+0.5-nux*sfx(1))) + ...
sin(pi*(indx-1-0.5-nux*sfx(1)))./(pi*(indx-1-0.5-nux*sfx(1))));
ampy = 2 * diag(ffty(indy,:),0)' ...
./( sin(pi*(indy-1+0.5-nuy*sfy(1)))./(pi*(indy-1+0.5-nuy*sfy(1))) + ...
sin(pi*(indy-1-0.5-nuy*sfy(1)))./(pi*(indy-1-0.5-nuy*sfy(1))));

% ampx = 2 * diag(fftx(indx,:),0)' ...
% ./( sinc(0.5+nux*1024) + sinc(-0.5+nux*1024));
% ampy = 2 * diag(ffty(indy,:),0)' ...
% ./( sinc(0.5+nuy*1024) + sinc(-0.5+nuy*1024));

% nux = 1-nux;
% nuy = 1-nuy;