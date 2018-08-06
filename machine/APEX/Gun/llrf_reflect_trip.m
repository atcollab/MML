function llrf_reflect_trip

checkforao;


Board{1} = 'llrf1';
Board{2} = 'llrf2molk1';


FigHandle = figure;
hExit = uicontrol(FigHandle, 'Style', 'PushButton', 'String', 'Exit', 'Callback', 'delete(gcbf)');
P = get(hExit, 'Position');
set(hExit, 'Position', [mean(P(1)/4) mean(P(1)/4) P(3:4)]);

h(1) = subplot(2,1,1);
hline(1,1) = plot([NaN NaN], [NaN NaN], 'b');
hold on
hline(1,2) = plot([NaN NaN], [NaN NaN], 'k');
hline(1,3) = plot([NaN NaN], [NaN NaN], 'g.');
hline(1,4) = plot([NaN NaN], [NaN NaN], 'r.');
hold off
xlabel('Time(ms)');
title(Board{1})

h(2) = subplot(2,1,2);
hline(2,1) = plot([NaN NaN], [NaN NaN], 'b');
hold on
hline(2,2) = plot([NaN NaN], [NaN NaN], 'k');
hline(2,3) = plot([NaN NaN], [NaN NaN], 'g.');
hline(2,4) = plot([NaN NaN], [NaN NaN], 'r.');
hold off
xlabel('Time(ms)');
title(Board{2})

htime(1) = addlabel(1, 0.51, 'TimeStamped1');
htime(2) = addlabel(1, 0.01, 'TimeStamped2');

while (ishandle(FigHandle))
    for iBoard = 1:2
        t              = getpvonline(sprintf('%s:%s',  Board{iBoard}, 'xaxis')) *  1e-9;
        thresh_init    = getpvonline(sprintf('%s:%s',  Board{iBoard}, 'thresh_init_ao'));
        thresh_noise   = getpvonline(sprintf('%s:%s',  Board{iBoard}, 'thresh_noise_ao'));
        decay_coef     = getpvonline(sprintf('%s:%s',  Board{iBoard}, 'decay_coef_ao'));
        rev_ilk_ch_sel = getpvonline(sprintf('%s:%s',  Board{iBoard}, 'rev_ilk_ch_sel_ao'));
        [x, tmp, Ts]   = getpvonline(sprintf('%s:%s%d',Board{iBoard}, 'w',(2*rev_ilk_ch_sel+1)));
        y              = getpvonline(sprintf('%s:%s%d',Board{iBoard}, 'w',(2*rev_ilk_ch_sel+2)));
        yscale         = getpvonline(sprintf('%s:%s',  Board{iBoard}, 'yscale'));
        decay_samp_per = getpvonline(sprintf('%s:%s',  Board{iBoard}, 'decay_samp_per_ao'));
        
        k = (1 - decay_coef * 2^-16);  % applied per cycle
        dti = 22*2/102.143e6;  % time interval between interlock updates
        a=log(k)/dti;  % better be negative
        line_thresh=thresh_noise+thresh_init*exp(a*t);
        line_thresh_norm=line_thresh/(22^4/4);
        
        npt2=1024*4;
        thresh_exp=zeros(1,npt2);
        shift=16;
        thresh_exp(1)=thresh_init*2^shift;
        
        for i = 2:npt2
            thresh_prod   = floor(thresh_exp(i-1)*2^-shift)*decay_coef;
            thresh_delta  = floor(thresh_prod/2^(16-shift));
            thresh_exp(i) = thresh_exp(i-1)-thresh_delta;
        end
        
        thresh_int      = (floor(thresh_exp*2^-shift)+thresh_noise);
        thresh_int_norm = thresh_int/(22^4/4);
        dt       = 22*decay_samp_per/102.143e6;
        t_dis    = [0:npt2-1]*dt;
        t_dis_ms = 1e3 * t_dis;
        
        line_meas = (x.^2+y.^2) / (yscale^2);
        tms = 1e3 * t; % convert to milisecond
        ix_bad  = find(line_meas >= line_thresh_norm);
        ix_good = find(line_meas  < line_thresh_norm);
        set(hline(iBoard,1), 'XData', tms,          'YData', line_thresh_norm);
        set(hline(iBoard,2), 'XData', t_dis_ms,     'YData', thresh_int_norm);
        set(hline(iBoard,3), 'XData', tms(ix_good), 'YData', line_meas(ix_good));
        set(hline(iBoard,4), 'XData', tms(ix_bad),  'YData', line_meas(ix_bad));

        set(h(iBoard), 'XLim', [0 max(tms)]);
        %plot(tms,line_thresh_norm,'b',  t_dis_ms,thresh_int_norm,'k',  tms(ix_good),line_meas(ix_good),'g.',  tms(ix_bad),line_meas(ix_bad),'r.')
        
        %plot(tms,line_thresh_norm,'r.',tms,line_meas,'g')
        %semilogy(tms,line_thresh_norm,'b',t_dis_ms,thresh_int_norm,'k',tms(ix_good),line_meas(ix_good),'g.',tms(ix_bad),line_meas(ix_bad),'r.')
        %xlim([0 max(tms)])
        %ylim([1e-4 1])
        %legend('computed','good',sprintf('%d bad',length(ix_bad)))
        
        TimeMatlab = labca2datenum(Ts);
        set(htime(iBoard), 'String', datestr(TimeMatlab, 'HH:MM:SS.FFF'));
        
        pause(0.5);
    end
end

