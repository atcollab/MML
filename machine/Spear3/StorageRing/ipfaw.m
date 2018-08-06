function    [coff,freq,data] = ipfaw(data,varargin)
%Using interpolated-FFT to determine the tunes of a signal within a window
%[coff,freq,data] = ipfaw(data)
%   extract the highest peak for window [0, 0.5], data is a vector
%[coff,freq,data] = ipfaw(data, window)
%   extract the highest peak within the given window, window=[wmin, wmax]
%[coff,freq,data] = ipfaw(data, window,nmod)
%   extract the nmod highest peaks within the given window, window=[wmin, wmax]
%[coff,freq,data] = ipfaw(data, window, nmod, excldelta)
%   extract the nmod highest peaks within the given window, window=[wmin,
%   wmax], each subsequent peak should be excldelta away from the larger
%   peaks
%Output:
%   data,   the remainder of the input data after the tune components
%           subtracted. 
%   freq,   frequency of peaks mapped to [0,0.5]
%   coff,   corresponding amplitude of peaks in freq
%
%ipfa - Iterative Precise Frequency Analysis
%Using precise tune measurement (R. Bartolini, et al "Algorithm for precise 
%determination of the betatron tune")
%to find the frequency peaks and corresponding amplitudes 
%with an iterative scheme (J.Laskar,"Frequency Map Analysis and Particle Accelerators"
%
coff=[];
freq=[];

if size(data,1)~= 1 
    data = data.';
end
if size(data,1) > 1
    disp('only 1D data accepted')
    return
end

N = length(data);
window = [1.0/N, 0.5];
if nargin>=2
   window = varargin{1};
   if length(window) ~= 2
      disp('not a valid window')
       return;
   end 
   if window(1) >=window(2) || window(1)<0 ||window(2)>0.5
       disp('not a valid window')
       return;
   end
end

nmod = 1;
if nargin>=3 
    nmod = varargin{2};
end

excldelta = 0.0;
if nargin>=4
    excldelta = varargin{3};
    if excldelta < 0.0 || excldelta > 0.5
        excldelta = 0.0;
        disp('exclusion window size set to zero!');
    end
end

avgdata = mean(data);
data = data - avgdata;

n=0:N-1;
data_power = norm(data);
power_ratio = 0.001;
k = 1;
dp_remain = data_power;
while k<=nmod & dp_remain>power_ratio*data_power
    [coff(k),freq(k)] = interpolatedFFT(data, window); % interp_hanning_FFT(data);  % 
    if isreal(data)
        data = data - 2.*real(coff(k)*exp(i*2.*pi*freq(k)*n));
    else
        data = data - coff(k)*exp(i*2.*pi*freq(k)*n);
    end
    dp_remain = norm(data);
	dpr(k) = dp_remain;
    
    k = k+1;
    
end

k=1;
if excldelta > 0
    sfreq = sort(freq);
    dfreq = abs(diff(sfreq));
    while min(dfreq) < excldelta
        acof = abs(coff);
        [vm, im] = max(acof);
        iwin = find(abs(freq-freq(im))< excldelta);
        filt_coff(k) = coff(im);
        filt_freq(k) = freq(im);
        
        coff(iwin) = [];
        freq(iwin) = [];
        sfreq = sort(freq);
        dfreq = abs(diff(sfreq));
        
        k = k+1;
    end
    
    coff = filt_coff;
    freq = filt_freq;
end



%[coff(1),freq(2)] = interp_hanning_FFT(data);
%[coff(1),freq(1)] = interpolatedFFT(data);


function [c,f]=interpolatedFFT(data,varargin)
%
afq = abs(fft(data));
N = length(data);
if nargin>=2
    %with window
    win = varargin{1};
    if isreal(data)
        k = max(1,round(win(1)*N)):min(ceil(N/2), round(win(2)*N));
    else
        k=max(1,round(win(1)*N)):min(N, round(win(2)*N));;
    end
    [vm,im]=max(afq(k));
    im = im + k(1)-1;
else
    %no windowing
    if isreal(data)
        k = 1:ceil(N/2);
    else
        k=1:N;
    end

    [vm,im]=max(afq(k));
end

if im==1 
    im2 = im+1;
elseif im==length(k)
    im2 = im-1;
else
    if afq(im+1) > afq(im-1)
        im2 = im+1;
    else
        im2 = im-1;
    end
end

f = ( im-1 + (im2-im)*afq(im2)/(afq(im) + afq(im2)) )/N;
c = calcampli(data,f);

function [c,f]=interp_hanning_FFT(data,varargin)
%
N=length(data);
n=1:N;
chi = sin(pi*n/N).^2;
ndata = data.*chi;

afq = abs(fft(ndata));

if nargin>=2
    %with window
    win = varargin{1};
    if isreal(data)
        k = max(1,round(win(1)*N)):min(ceil(N/2), round(win(2)*N));
    else
        k=max(1,round(win(1)*N)):min(N, round(win(2)*N));;
    end
    [vm,im]=max(afq(k));
    im = im + k(1)-1;
else
    %now windowing
    if isreal(data)
        k = 1:ceil(N/2);
    else
        k=1:N;
    end

    [vm,im]=max(afq(k));
end



if im==1 
    im2 = im+1;
elseif im==length(k)
    im2 = im-1;
else
    if afq(im+1) > afq(im-1)
        im2 = im+1;
    else
        im2 = im-1;
    end
end

f = (im-1 + (im2-im)*( 3.*afq(im2)/(afq(im)+afq(im2)) - 1 ))/N;
c = calcampli(data,f);


function c=calcampli(data, v)
%calculate the amplitude of frquency v in 1D series data
% data - (a+b*i) e(2 pi v t)  will contain no v component
% c= a+b*i;
N=length(data);
fq = fft(data);

% im = round(N*v)+1;
% k=[im-1,im,im+1];
% k(find(k<1)) = [];
% a = real(sum(fq(k)));
% b = imag(sum(fq(k)));

n=1:N;
n = n-1;
em = exp(-2.*pi*i*v*n);

a = sum(real(data.*em))/N;
b = sum(imag(data.*em))/N;

c = a+ b*i;
