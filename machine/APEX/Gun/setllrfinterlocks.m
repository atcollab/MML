function setllrfinterlocks(LLRFData)

if nargin < 1
    % Note: must resave after a calibration change
    load LLRFDataStructure
end

FileName = '/remote/apex/hlc/data/LLRF_Thresholds.txt';
fprintf('   Reading LLRF threshold table (%s)\n', FileName);
fdata = importdata(FileName, '\t');

ChannelText = fdata.textdata(3:24);
d = fdata.data;

% To convert a threshold T given in Watts, compute sqrt(T/F)*51010
% (where 51010 is 22^2 * 64 * 1.64676 does _not_ depend on the waveform
% setup parameters wave_samp_per or wave_shift).  The result is a 16-bit
% unsigned register value that is sent to the hardware, using the PVs named
% {llrf1,1molk1,1molk2,2molk1,2molk2}:{upper,lower}_thresh_{1,2,3,4}

k = 0;
for i = 1:20
    
    BoardNumber = ceil(i/4);
    Prefix = LLRFData{BoardNumber}.Prefix;
    Ch = rem(i-1,4) + 1;
    Inp = sprintf('Inp%d', Ch);
    
    k = k + 1;
    Tlower = round(51010 * sqrt(abs(d(k,1))) / LLRFData{BoardNumber}.(Inp).ScaleFactor);
    Tupper = round(51010 * sqrt(abs(d(k,2))) / LLRFData{BoardNumber}.(Inp).ScaleFactor);
    
    fprintf('   %2d.  %14s  min=%f (%d)   max=%f (%d)   mode=%d\n', k, ChannelText{k}, d(k,1), Tlower, d(k,2), Tupper, d(k,3));

    PVlower = sprintf('%slower_thresh_%d_ao', Prefix, Ch);
    PVupper = sprintf('%supper_thresh_%d_ao', Prefix, Ch);
    PVmode  = sprintf('%sinlk_mode_%d_ao',    Prefix, Ch);

    setpvonline(PVlower, Tlower);
    setpvonline(PVupper, Tupper);
    setpvonline(PVmode,  round(d(k,3)));
    
end


% Set the dynamic interlocks
for i = 1:2
    if i == 1
        dyn_fpga = 'llrf1';
        BoardNumber = 1;
        Ch = 3;
    elseif i == 2
        dyn_fpga = 'llrf2molk1';
        BoardNumber = 4;
        Ch = 2;
    else
        dyn_fpga = '';
        dyn_ch = 0;
    end
    Inp = sprintf('Inp%d', Ch);
    sf = LLRFData{BoardNumber}.(Inp).ScaleFactor;  % sqrt(W) full-scale
    exp_init_reg = round(58564 * d(20+i,1) / sf^2);
    pedestal_reg = round(58564 * d(20+i,2) / sf^2);
    decay_bw_hz = d(20+i,3);  % 1/(2*pi*tau)  where tau is amplitude decay time constant
    update_period = 22*2/102.143e6;  % seconds per update of threshold inside FPGA 
    decay_coef_reg = round(decay_bw_hz*2*pi*update_period*2*2^16);
    setpvonline(sprintf('%s:rev_ilk_ch_sel_ao', dyn_fpga), Ch-1);
    setpvonline(sprintf('%s:thresh_init_ao',    dyn_fpga), exp_init_reg);
    setpvonline(sprintf('%s:thresh_noise_ao',   dyn_fpga), pedestal_reg);
    setpvonline(sprintf('%s:decay_coef_ao',     dyn_fpga), decay_coef_reg);
end


% Direct EPICS bits
% setpvonline('llrf1:rev_ilk_ch_sel_ao', 2);
% setpvonline('llrf1:thresh_init_ao',  d(21,1));
% setpvonline('llrf1:thresh_noise_ao', d(21,2));
% setpvonline('llrf1:decay_coef_ao',   d(21,3));
% 
% setpvonline('llrf2molk1:rev_ilk_ch_sel_ao', 1);
% setpvonline('llrf2molk1:thresh_init_ao',  d(22,1));
% setpvonline('llrf2molk1:thresh_noise_ao', d(22,2));
% setpvonline('llrf2molk1:decay_coef_ao',   d(22,3));

fprintf('   Done.\n\n');