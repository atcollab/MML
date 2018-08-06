function setbpmavg(BPMNumAverages)
% setbpmavg(IDBPMNumAverages {Default: 190})
% This function sets the number of averages for all BPMs to BPMNumAverages
% 380 averages corresponds to 1 Hz data rate.
%


if nargin < 1
    BPMNumAverages = 190;
end

BPMNumAveragesPerOneSecondPeriod_OldStyle = 2 * 190;

T = BPMNumAverages / BPMNumAveragesPerOneSecondPeriod_OldStyle;

setbpmaverages(T);

