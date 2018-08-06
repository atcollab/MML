function d = getirm(irm)


% Analog
for i = 1:4
    d.ADC.PVName{i,1} = sprintf('irm:%03d:ADC%d', irm, i-1);
    d.DAC.PVName{i,1} = sprintf('irm:%03d:DAC%d', irm, i-1);
end

d.ADC.Data = cell2mat(getpv(d.ADC.PVName));
d.DAC.Data = cell2mat(getpv(d.DAC.PVName));



% Digital - PV for BM or BC
% for i = 1:16
%     ChanBM{i} = sprintf('irm:%03d:%02???d', irm, i-1);
%     ChanBC{i} = sprintf('irm:%03d:%02d', irm, i-1);
% end
% 
% d.BM = getpv(ChanBM);
% d.BC = getpv(ChanBC);

