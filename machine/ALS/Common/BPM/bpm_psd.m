function [Paa, Paa_RMS, Phase, PTaa_RMS] = bpm_psd(Data, nHarmUse, nPT, NAvg, PercentOverLap)
%  nHarmUse  - index for the revolution harmonic
%  nPT  - index for the pilot tone


if nargin < 4 || isempty(NAvg)
    % # of FFTs to average
    NAvg = 1;
end
if nargin < 5 || isempty(PercentOverlap)
    PercentOverLap = 100;
end


Data = Data(:);

N = floor(length(Data)/NAvg);

w = 1;
U = 1;
%if exist('hanning') == 0
%    w = ones(N,1);            % no window
%else
%    w = hanning(N);          % hanning window
%end
%U = sum(w.^2)/N;              % approximately .375 for hanning
%U2 = ((norm(w)/sum(w))^2);   % used to normalize plots (p. 1-68, matlab DSP toolbox)

% if NAvg > 1 && round((100-PercentOverLap)*N/100) < 1
%     error('Percent overlap is too high. Must advance by at least 1 ADC count.');
% end
% if NAvg> 1 && round((100-PercentOverLap)*N/100) < 77
%     fprintf('  Note: advancing on FFT averaging is less than 1 turn.\n');
% end

PaaAvg = 0;
for i = 1:NAvg
    %ii = (1:N) + (i-1)*round((100-PercentOverLap)*N/100);
    
    ii = (1:N)+(i-1)*N;  % No overlap
    a = Data(ii);        % detrend???
    
    a_w = a .* w;
    A = fft(a_w);
    Paa = A.*conj(A)/N;
    Paa = Paa/U;
    Paa = Paa(1:ceil(N/2));
    Paa(2:end) = 2*Paa(2:end);
    
    PaaAvg = PaaAvg + Paa/NAvg;
end

Paa = PaaAvg;

Paa(1) = 0; % Remove the DC term
Paa_RMS = sqrt(sum(Paa(nHarmUse))/N);

% Data_RMS = sqrt(sum((Data-mean(Data)).^2)/length(Data))
% a_RMS = sqrt(sum((a-mean(a)).^2)/length(a))
% Paa_RMS_Total = sqrt(sum(Paa)/N)

if nargout >= 3
    Phase = atan2(imag(A(1:ceil(N/2))), real(A(1:ceil(N/2))));
end

if nargout >= 4 && ~isempty(nPT) && nPT>0
    PTaa_RMS = sqrt(sum(Paa(nPT))/N);
else
    PTaa_RMS = NaN;
end



