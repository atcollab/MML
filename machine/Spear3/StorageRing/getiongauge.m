function IonGauge = getiongauge(GaugeNumber)
% IonGauge = getiongauge(GaugeNumber)

if nargin < 1
    GaugeNumber = (1:55)';
end

ChanName = [];
for i = 1:length(GaugeNumber)
    ChanName = strvcat(ChanName,sprintf('spr:VG%02d/AM1',GaugeNumber(i)));
end

IonGauge = getpv(ChanName);


% for i = 1:length(GaugeNumber)
%     fprintf('%d. %g\n', GaugeNumber(i), IonGauge(i,1));
% end
