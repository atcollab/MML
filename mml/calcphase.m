function [phix,phiy]=calcphase(nux,nuy,fadx,fady)
%CALCPHASE - Calculate the betatron oscillation phase at the BPM using turn-by-turn data
%   [phix,phiy]=calcphase(nux,nuy,fadx,fady)
%
%  This function calculates the betatron oscillation phase at the BPMs
%  using FAD data (turn by turn orbit measurement).
%
%  return values:
%  phix, phiy	horizontal and vertical betatron oscillation phase at every BPM
%
%  input values:
%  nux, nuy	horizontal and vertical tunes (as calculated by findfreq)
%  fadx		horizontal FAD data (number of BPMs and number of turns is variable)
%  fady		vertical FAD data

%  Christoph Steier, July 1999

tmpx = sum(nux./abs(nux-mean(nux)))/sum(ones(size(nux))./abs(nux-mean(nux)));

tmpy = sum(nuy./abs(nuy-mean(nuy)))/sum(ones(size(nuy))./abs(nuy-mean(nuy)));

qx = 0.0; tmpsumx = 0.0; qy = 0.0; tmpsumy = 0.0;

for n = 1:length(nux)
	if (abs(nux(n)-tmpx)<std(nux))
		qx = qx + nux(n)/abs(nux(n)-tmpx)
		tmpsumx = tmpsumx + 1/abs(nux(n)-tmpx);
    end
end
for n = 1:length(nuy)
	if (abs(nuy(n)-tmpy)<std(nuy))
		qy = qy + nuy(n)/abs(nuy(n)-tmpy)
		tmpsumy = tmpsumy + 1/abs(nuy(n)-tmpy);
	end
end

qx = qx/tmpsumx;
qy = qy/tmpsumy;

fprintf('\n\nBPM #\tnu_x\t\tnu_y\n');

for n=1:length(nux)
	fprintf('%2d:\t%8.6g\t%8.6g\n',n,nux(n),nuy(n));
end

outstring = sprintf('\nfractional horizontal tune (default=%g) ',qx);

inx = input(outstring);

if ~isempty(inx)
	qx = inx;
end

outstring = sprintf('\nfractional vertical tune (default=%g) ',qy);

iny = input(outstring);

if ~isempty(iny)
	qy = iny;
end

sfx=size(fadx);
sfy=size(fady);

mfadx = fadx-ones(sfx(1),1)*mean(fadx);
mfady = fady-ones(sfy(1),1)*mean(fady);

sfadx = sum(mfadx .* (ones(sfx(2),1)*sin(2*pi*qx*[0:(sfx(1)-1)]))');
cfadx = sum(mfadx .* (ones(sfx(2),1)*cos(2*pi*qx*[0:(sfx(1)-1)]))');
sfady = sum(mfady .* (ones(sfy(2),1)*sin(2*pi*qy*[0:(sfy(1)-1)]))');
cfady =	sum(mfady .* (ones(sfy(2),1)*cos(2*pi*qy*[0:(sfy(1)-1)]))');

phix = atan2(cfadx,sfadx)/(2*pi);
for n = 1:length(phix)
	if (phix(n) < 0.0)
		phix(n) = phix(n)+1.0;
	end
end

phiy = atan2(cfady,sfady)/(2*pi);
for n = 1:length(phiy)
	if (phiy(n) < 0.0)
		phiy(n) = phiy(n)+1.0;
	end
end

for n = 2:length(phix)
	while (phix(n) < (phix(n-1)-0.2))
		phix(n) = phix(n)+1.0;
	end
end

for n = 2:length(phiy)
	while (phiy(n) < (phiy(n-1)-0.2))
		phiy(n) = phiy(n)+1.0;
	end
end
