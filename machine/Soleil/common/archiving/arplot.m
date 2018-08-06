function arplot(varargin)
%ARPLOT - Read data from archiving database
%
%  INPUTS
%  1. attribute name
%  2. starting date {now - 1 hour}
%  3. endind date {now}
%  4. {'HDB'} or 'TDB' : select database
%
%  EXAMPLES
%
%  1. read and plot all dose for the 10 hours 
%      arplot('CIGdose')
%  2. read and plot all dose between two dates
%     arplot('CIGrate', [], '30-09-2005 03:21:02', '30-09-2005 9:21:00')
%  3. read and plot for moniteur 1 and 4 in list see afterwards
%     arplot('CIGrate', [1;4], '30-09-2005 03:21:02', '30-09-2005 9:21:00')
%

% LIN/RP/CIG.001
% LT1/RP/CIG.002
% BOO-C21/RP/CIG.003
% BOO-C04/RP/CIG.004
% BOO-C16/RP/CIG.007
% BOO-C13/RP/CIG.009
% BOO-C16/RP/CIG.010
% BOO-C16/RP/CIG.011
% BOO-C01/RP/CIG.012
% BOO-C12/RP/CIG.026
% BOO-C13/RP/CIG.027
% BOO-C14/RP/CIG.028
% BOO-C15/RP/CIG.029
% BOO-C16/RP/CIG.030
% 


% See also arread

% TODO: convertion to Physics units in 'Physics' asked
%       extract the attribute display units        

%
% Written by Laurent S. Nadolski

%% Ask for data
Data = arread(varargin{:});

if (isnumeric(Data.ardata) && Data == -1) || (~isstruct(Data.ardata) && Data == -1) ...
        || isempty(Data.ardata(1).dvalue)
    disp('No data available')
    return;
end

% Format for time conversion 
%formatstr0 = 'yyyy-mm-dd HH:MM:SS';
% formatstr0 = 'dd-mm-yyyy HH:MM:SS';
%formatstr0 = 'dd-mmm-yyyy HH:MM:SS';
formatstr = 'HH:MM';

figure
h = newplot;
% set size
set(gcf,'Position',[80 320 1200 620])
xlabel('Time')
ylabel('Attribut [Harware unit]');
hold on;
grid on;

for ik = 1:length(Data.TangoNames)
    % Time conversion
%      val_date = datenum(datestr(Data.ardata(ik).svalue), formatstr0);
     val_date = Data.ardata(ik).svalue;
     plot(h,val_date,Data.ardata(ik).dvalue,'.-','Color',nxtcolor);
     datetick('x',formatstr);
end

datalabel on;

title(['Data extracted from ', Data.database, ' database']);
legend(Data.TangoNames,'Location','EastOutside');
addlabel(1,0,['Starting Date : ',datestr(val_date(1),21),'  Ending Date : ', datestr(val_date(end),21)]);
    