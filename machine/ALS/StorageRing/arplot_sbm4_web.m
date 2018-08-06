function arplot_sbm4_web(varargin)
% arplot_sbm4_web(varargin)
%
% Plots archived (and live) data about SBM4 to A WEB DISPLAY
%
% Example:  arplot_sbm4_web
%
% C. Steier, November 2012

        sbm1inow=0;        sbm1lnnow=0;        sbm1lnpnow=0;        sbm1lhenow=0;
        sbm1lhepnow=0;        sbm1hallnow=0;        sbm1cryovacnow=0;        sbm1t1now=0;
        sbm1t2now=0;        sbm1t3now=0;        sbm1t4now=0;        sbm1t5now=0;
        sbm1t6now=0;        sbm1t7now=0;        sbm1t8now=0;
        
        sbm2inow=0;        sbm2lnnow=0;        sbm2lnpnow=0;        sbm2lhenow=0;
        sbm2lhepnow=0;        sbm2hallnow=0;        sbm2cryovacnow=0;        sbm2t1now=0;
        sbm2t2now=0;        sbm2t3now=0;        sbm2t4now=0;        sbm2t5now=0;
        sbm2t6now=0;        sbm2t7now=0;        sbm2t8now=0;
        
        sbm3inow=0;        sbm3lnnow=0;        sbm3lnpnow=0;        sbm3lhenow=0;
        sbm3lhepnow=0;        sbm3hallnow=0;        sbm3cryovacnow=0;        sbm3t1now=0;
        sbm3t2now=0;        sbm3t3now=0;        sbm3t4now=0;        sbm3t5now=0;
        sbm3t6now=0;        sbm3t7now=0;        sbm3t8now=0;
        
        sbm4inow=0;        sbm4lnnow=0;        sbm4lnpnow=0;        sbm4lhenow=0;
        sbm4lhepnow=0;        sbm4hallnow=0;        sbm4cryovacnow=0;        sbm4t1now=0;
        sbm4t2now=0;        sbm4t3now=0;        sbm4t4now=0;        sbm4t5now=0;
        sbm4t6now=0;        sbm4t7now=0;        sbm4t8now=0;

h=figure(30);
% set(h,'Visible','off');

% Inputs
if nargin > 0
    warning('ARPLOT_SBM4_WEB:  This routine does not take any input arguments.');
end


arglobal
arcnt = 0;

while 1
    
    
    nowstr=datestr(now,30);nowstr=nowstr(1:8);
    
    titleStr=datestr(now);
    StartDayStr=datestr(now);
    
    try
        sbm1t1now=getpv('SR08C___BSC_T1_AM00');
        sbm1t2now=getpv('SR08C___BSC_T2_AM01');
        sbm1t3now=getpv('SR08C___BSC_T3_AM02');
        sbm1t4now=getpv('SR08C___BSC_T4_AM03');
        sbm1t5now=getpv('SR08C___BSC_T5_AM04');
        sbm1t6now=getpv('SR08C___BSC_T6_AM05');
        sbm1t7now=getpv('SR08C___BSC_T7_AM06');
        sbm1t8now=getpv('SR08C___BSC_T8_AM07');
        
        sbm2t1now=getpv('SR04C___BSC_T1_AM00');
        sbm2t2now=getpv('SR04C___BSC_T2_AM01');
        sbm2t3now=getpv('SR04C___BSC_T3_AM02');
        sbm2t4now=getpv('SR04C___BSC_T4_AM03');
        sbm2t5now=getpv('SR04C___BSC_T5_AM04');
        sbm2t6now=getpv('SR04C___BSC_T6_AM05');
        sbm2t7now=getpv('SR04C___BSC_T7_AM06');
        sbm2t8now=getpv('SR04C___BSC_T8_AM07');
        
        sbm4t1now=getpv('SR12C___BSC_T1_AM00');
        sbm4t2now=getpv('SR12C___BSC_T2_AM01');
        sbm4t3now=getpv('SR12C___BSC_T3_AM02');
        sbm4t4now=getpv('SR12C___BSC_T4_AM03');
        sbm4t5now=getpv('SR12C___BSC_T5_AM04');
        sbm4t6now=getpv('SR12C___BSC_T6_AM05');
        sbm4t7now=getpv('SR12C___BSC_T7_AM06');
        sbm4t8now=getpv('SR12C___BSC_T8_AM07');

        sbm1inow=getpv('SR08C___BSC_P__AM00');
        sbm1lnnow=getpv('SR08C___BSCLVN2AM00');
        sbm1lhenow=getpv('SR08C___BSCLVHEAM00');
        sbm1hallnow=0;
        
        sbm2inow=getpv('SR04C___BSC_P__AM00');
        sbm2lnnow=getpv('SR04C___BSCLVN2AM00');
        sbm2lhenow=getpv('SR04C___BSCLVHEAM00');
        sbm2hallnow=0;
        
        sbm4inow=getpv('SR12C___BSC_P__AM00');
        sbm4lnnow=getpv('SR12C___BSCLVN2AM00');
        sbm4lhenow=getpv('SR12C___BSCLVHEAM00');
        sbm4hallnow=0;%getpv('SR12C___BSCHALLAM00');

        sbm1cryovacnow=getpv('SR08C___BSCIG1_AM00');
        sbm2cryovacnow=getpv('SR04C___BSCIG1_AM00');
        sbm4cryovacnow=getpv('SR12C___BSCIG1_AM00');

        sbm1lnpnow=getpv('SR08C___BSC_LN_AM00');
        sbm1lhepnow=getpv('SR08C___BSC_LHEAM00');
        
        sbm2lnpnow=getpv('SR04C___BSC_LN_AM00');
        sbm2lhepnow=getpv('SR04C___BSC_LHEAM00');

        sbm4lnpnow=getpv('SR12C___BSC_LN_AM00');
        sbm4lhepnow=getpv('SR12C___BSC_LHEAM00');

        sbm3t1now=getpv('SR00C___BSC_T1_AM00');
        sbm3t2now=getpv('SR00C___BSC_T2_AM01');
        sbm3t3now=getpv('SR00C___BSC_T3_AM02');
        sbm3t4now=getpv('SR00C___BSC_T4_AM03');
        sbm3t5now=getpv('SR00C___BSC_T5_AM04');
        sbm3t6now=getpv('SR00C___BSC_T6_AM05');
        sbm3t7now=getpv('SR00C___BSC_T7_AM06');
        sbm3t8now=getpv('SR00C___BSC_T8_AM07');
        
        sbm3inow=0;
        sbm3lnnow=getpv('SR00C___BSCLVN2AM00');
        sbm3lnpnow=0;
        sbm3lhenow=getpv('SR00C___BSCLVHEAM00');
        sbm3lhepnow=0;
        sbm3hallnow=0;

        sbm3cryovacnow=getpv('SR00C___BSCIG1_AM00');
        
    catch
        disp('A channel access error has occurred - trying to continue');
    end
    
    
    if ~arcnt
        
        t=[];
        
        sbm1i = []; sbm1ln = []; sbm1lnp = []; sbm1lhe = []; sbm1lhep = []; sbm1hall =[]; sbm1cryovac =[];
        sbm1t1 = []; sbm1t2 = []; sbm1t3 = []; sbm1t4 = [];
        sbm1t5 = []; sbm1t6 = []; sbm1t7 = []; sbm1t8 = [];
        
        sbm2i = []; sbm2ln = []; sbm2lnp = []; sbm2lhe = []; sbm2lhep = []; sbm2hall =[]; sbm2cryovac =[];
        sbm2t1 = []; sbm2t2 = []; sbm2t3 = []; sbm2t4 = [];
        sbm2t5 = []; sbm2t6 = []; sbm2t7 = []; sbm2t8 = [];
        
        sbm3i = []; sbm3ln = []; sbm3lnp = []; sbm3lhe = []; sbm3lhep = []; sbm3hall =[]; sbm3cryovac =[];
        sbm3t1 = []; sbm3t2 = []; sbm3t3 = []; sbm3t4 = [];
        sbm3t5 = []; sbm3t6 = []; sbm3t7 = []; sbm3t8 = [];
        
        sbm4i = []; sbm4ln = []; sbm4lnp = []; sbm4lhe = []; sbm4lhep = []; sbm4hall =[]; sbm4cryovac =[];
        sbm4t1 = []; sbm4t2 = []; sbm4t3 = []; sbm4t4 = [];
        sbm4t5 = []; sbm4t6 = []; sbm4t7 = []; sbm4t8 = [];

        try
            nowstr=datestr(now-1,30);nowstr=nowstr(1:8);
            arread(nowstr);
            startind=-1;
        catch
            disp(datestr(now))
            warning('Could not read archiver data - Expected if time is between midnight and 0:15')
            startind=0;
        end

        for loop=startind:0
            
            if loop==0
                try
                    nowstr=datestr(now,30);nowstr=nowstr(1:8);
                    arread(nowstr);
                catch
                    disp(datestr(now))
                    warning('Could not read archiver data - Expected if time is between midnight and 0:15')
                    break
                end
            end
            
            [y1, i] = arselect('SR08C___BSC_P__AM00');
            sbm1i = [sbm1i y1];
            
            [y1, i] = arselect('SR08C___BSCLVN2AM00');
            sbm1ln = [sbm1ln y1];
            
            [y1, i] = arselect('SR08C___BSC_LN_AM00');
            sbm1lnp = [sbm1lnp y1];
            
            [y1, i] = arselect('SR08C___BSCLVHEAM00');
            sbm1lhe = [sbm1lhe y1];
            
            [y1, i] = arselect('SR08C___BSC_LHEAM00');
            sbm1lhep = [sbm1lhep y1];
            
            [y1, i] = arselect('SR08C___BSCHALLAM00');
            sbm1hall = [sbm1hall y1];
            
            [y1, i] = arselect('SR08C___BSCIG1_AM00');
            sbm1cryovac = [sbm1cryovac y1];
            
            [y1, i] = arselect('SR08C___BSC_T1_AM00');
            sbm1t1 = [sbm1t1 y1];
            
            [y1, i] = arselect('SR08C___BSC_T2_AM01');
            sbm1t2 = [sbm1t2 y1];
            
            [y1, i] = arselect('SR08C___BSC_T3_AM02');
            sbm1t3 = [sbm1t3 y1];
            
            [y1, i] = arselect('SR08C___BSC_T4_AM03');
            sbm1t4 = [sbm1t4 y1];
            
            [y1, i] = arselect('SR08C___BSC_T5_AM04');
            sbm1t5 = [sbm1t5 y1];
            
            [y1, i] = arselect('SR08C___BSC_T6_AM05');
            sbm1t6 = [sbm1t6 y1];
            
            [y1, i] = arselect('SR08C___BSC_T7_AM06');
            sbm1t7 = [sbm1t7 y1];
            
            [y1, i] = arselect('SR08C___BSC_T8_AM07');
            sbm1t8 = [sbm1t8 y1];
            
            [y1, i] = arselect('SR04C___BSC_P__AM00');
            sbm2i = [sbm2i y1];
            
            [y1, i] = arselect('SR04C___BSCLVN2AM00');
            sbm2ln = [sbm2ln y1];
            
            [y1, i] = arselect('SR04C___BSC_LN_AM00');
            sbm2lnp = [sbm2lnp y1];
            
            [y1, i] = arselect('SR04C___BSCLVHEAM00');
            sbm2lhe = [sbm2lhe y1];
            
            [y1, i] = arselect('SR04C___BSC_LHEAM00');
            sbm2lhep = [sbm2lhep y1];
            
            [y1, i] = arselect('SR04C___BSCHALLAM00');
            sbm2hall = [sbm2hall y1];
            
            [y1, i] = arselect('SR04C___BSCIG1_AM00');
            sbm2cryovac = [sbm2cryovac y1];
            
            [y1, i] = arselect('SR04C___BSC_T1_AM00');
            sbm2t1 = [sbm2t1 y1];
            
            [y1, i] = arselect('SR04C___BSC_T2_AM01');
            sbm2t2 = [sbm2t2 y1];
            
            [y1, i] = arselect('SR04C___BSC_T3_AM02');
            sbm2t3 = [sbm2t3 y1];
            
            [y1, i] = arselect('SR04C___BSC_T4_AM03');
            sbm2t4 = [sbm2t4 y1];
            
            [y1, i] = arselect('SR04C___BSC_T5_AM04');
            sbm2t5 = [sbm2t5 y1];
            
            [y1, i] = arselect('SR04C___BSC_T6_AM05');
            sbm2t6 = [sbm2t6 y1];
            
            [y1, i] = arselect('SR04C___BSC_T7_AM06');
            sbm2t7 = [sbm2t7 y1];
            
            [y1, i] = arselect('SR04C___BSC_T8_AM07');
            sbm2t8 = [sbm2t8 y1];
            
            [y1, i] = arselect('SR00C___BSC_P__AM00');
            sbm3i = [sbm3i y1];
            
            [y1, i] = arselect('SR00C___BSCLVN2AM00');
            sbm3ln = [sbm3ln y1];
            
            [y1, i] = arselect('SR00C___BSC_LN_AM00');
            sbm3lnp = [sbm3lnp y1];
            
            [y1, i] = arselect('SR00C___BSCLVHEAM00');
            sbm3lhe = [sbm3lhe y1];
            
            [y1, i] = arselect('SR00C___BSC_LHEAM00');
            sbm3lhep = [sbm3lhep y1];
            
            [y1, i] = arselect('SR00C___BSCHALLAM00');
            sbm3hall = [sbm3hall y1];
            
            [y1, i] = arselect('SR00C___BSCIG1_AM00');
            sbm3cryovac = [sbm3cryovac y1];
            
            [y1, i] = arselect('SR00C___BSC_T1_AM00');
            sbm3t1 = [sbm3t1 y1];
            
            [y1, i] = arselect('SR00C___BSC_T2_AM01');
            sbm3t2 = [sbm3t2 y1];
            
            [y1, i] = arselect('SR00C___BSC_T3_AM02');
            sbm3t3 = [sbm3t3 y1];
            
            [y1, i] = arselect('SR00C___BSC_T4_AM03');
            sbm3t4 = [sbm3t4 y1];
            
            [y1, i] = arselect('SR00C___BSC_T5_AM04');
            sbm3t5 = [sbm3t5 y1];
            
            [y1, i] = arselect('SR00C___BSC_T6_AM05');
            sbm3t6 = [sbm3t6 y1];
            
            [y1, i] = arselect('SR00C___BSC_T7_AM06');
            sbm3t7 = [sbm3t7 y1];
            
            [y1, i] = arselect('SR00C___BSC_T8_AM07');
            sbm3t8 = [sbm3t8 y1];
            
            [y1, i] = arselect('SR12C___BSC_P__AM00');
            sbm4i = [sbm4i y1];
            
            [y1, i] = arselect('SR12C___BSCLVN2AM00');
            sbm4ln = [sbm4ln y1];
            
            [y1, i] = arselect('SR12C___BSC_LN_AM00');
            sbm4lnp = [sbm4lnp y1];
            
            [y1, i] = arselect('SR12C___BSCLVHEAM00');
            sbm4lhe = [sbm4lhe y1];
            
            [y1, i] = arselect('SR12C___BSC_LHEAM00');
            sbm4lhep = [sbm4lhep y1];
            
            [y1, i] = arselect('SR12C___BSCHALLAM00');
            sbm4hall = [sbm4hall y1];
            
            [y1, i] = arselect('SR12C___BSCIG1_AM00');
            sbm4cryovac = [sbm4cryovac y1];
            
            [y1, i] = arselect('SR12C___BSC_T1_AM00');
            sbm4t1 = [sbm4t1 y1];
            
            [y1, i] = arselect('SR12C___BSC_T2_AM01');
            sbm4t2 = [sbm4t2 y1];
            
            [y1, i] = arselect('SR12C___BSC_T3_AM02');
            sbm4t3 = [sbm4t3 y1];
            
            [y1, i] = arselect('SR12C___BSC_T4_AM03');
            sbm4t4 = [sbm4t4 y1];
            
            [y1, i] = arselect('SR12C___BSC_T5_AM04');
            sbm4t5 = [sbm4t5 y1];
            
            [y1, i] = arselect('SR12C___BSC_T6_AM05');
            sbm4t6 = [sbm4t6 y1];
            
            [y1, i] = arselect('SR12C___BSC_T7_AM06');
            sbm4t7 = [sbm4t7 y1];
            
            [y1, i] = arselect('SR12C___BSC_T8_AM07');
            sbm4t8 = [sbm4t8 y1];
            
            t    = [t ARt+loop*24*60*60];
            
        end
        
        t = t/60/60;
        if (length(t)>1) & (t(1)>24)
            t=t-t(1);
        end
        xlabelstring = ['Time  [Hours]'];
        DayFlag = 0;
        
        if startind==(-1)
            Days=round(now)+[-1 0];
            t=t+24;
        else
            Days=round(now);
        end
        
        xmax = max(t);
        arcnt=arcnt+1;
        
        
    elseif arcnt>15
        arcnt = 0;
    else
        arcnt=arcnt+1;
    end
    
    
    
    % change data to NaN for plotting if archiver has stalled for more than 30minutes
    StalledArchFlag = [];
    for loop = 1:size(t,2)-1
        StalledArchFlag(loop) = (t(loop+1)-t(loop)>0.5);
    end
    SANum = find(StalledArchFlag==1)+1;
    
    sbm1i(SANum) = NaN; sbm1ln(SANum) = NaN; sbm1lnp(SANum) = NaN; sbm1lhe(SANum) = NaN; sbm1lhep(SANum) = NaN; sbm1hall(SANum) =NaN; sbm1cryovac(SANum) = NaN;
    sbm1t1(SANum) = NaN; sbm1t2(SANum) = NaN; sbm1t3(SANum) = NaN; sbm1t4(SANum) = NaN;
    sbm1t5(SANum) = NaN; sbm1t6(SANum) = NaN; sbm1t7(SANum) = NaN; sbm1t8(SANum) = NaN;
    
    sbm2i(SANum) = NaN; sbm2ln(SANum) = NaN; sbm2lnp(SANum) = NaN; sbm2lhe(SANum) = NaN; sbm2lhep(SANum) = NaN; sbm2hall(SANum) =NaN; sbm2cryovac(SANum) = NaN;
    sbm2t1(SANum) = NaN; sbm2t2(SANum) = NaN; sbm2t3(SANum) = NaN; sbm2t4(SANum) = NaN;
    sbm2t5(SANum) = NaN; sbm2t6(SANum) = NaN; sbm2t7(SANum) = NaN; sbm2t8(SANum) = NaN;
    
    sbm3i(SANum) = NaN; sbm3ln(SANum) = NaN; sbm3lnp(SANum) = NaN; sbm3lhe(SANum) = NaN; sbm3lhep(SANum) = NaN; sbm3hall(SANum) =NaN; sbm3cryovac(SANum) = NaN;
    sbm3t1(SANum) = NaN; sbm3t2(SANum) = NaN; sbm3t3(SANum) = NaN; sbm3t4(SANum) = NaN;
    sbm3t5(SANum) = NaN; sbm3t6(SANum) = NaN; sbm3t7(SANum) = NaN; sbm3t8(SANum) = NaN;
    
    sbm4i(SANum) = NaN; sbm4ln(SANum) = NaN; sbm4lnp(SANum) = NaN; sbm4lhe(SANum) = NaN; sbm4lhep(SANum) = NaN; sbm4hall(SANum) =NaN; sbm4cryovac(SANum) = NaN;
    sbm4t1(SANum) = NaN; sbm4t2(SANum) = NaN; sbm4t3(SANum) = NaN; sbm4t4(SANum) = NaN;
    sbm4t5(SANum) = NaN; sbm4t6(SANum) = NaN; sbm4t7(SANum) = NaN; sbm4t8(SANum) = NaN;

    if isempty(sbm1t1) && isempty(sbm2t1) && isempty(sbm3t1)
        t=0;
        sbm1i = sbm1inow; sbm1ln = sbm1lnnow; sbm1lnp = sbm1lnpnow; sbm1lhe = sbm1lhenow; sbm1lhep = sbm1lhepnow;
        sbm1hall = sbm1hallnow; sbm1cryovac = sbm1cryovacnow;
        sbm1t1 = sbm1t1now; sbm1t2 = sbm1t2now; sbm1t3 = sbm1t3now; sbm1t4 = sbm1t4now;
        sbm1t5 = sbm1t5now; sbm1t6 = sbm1t6now; sbm1t7 = sbm1t7now; sbm1t8 = sbm1t8now;
    
        sbm2i = sbm2inow; sbm2ln = sbm2lnnow; sbm2lnp = sbm2lnpnow; sbm2lhe = sbm2lhenow; sbm2lhep = sbm2lhepnow;
        sbm2hall = sbm2hallnow; sbm2cryovac = sbm2cryovacnow;
        sbm2t1 = sbm2t1now; sbm2t2 = sbm2t2now; sbm2t3 = sbm2t3now; sbm2t4 = sbm2t4now;
        sbm2t5 = sbm2t5now; sbm2t6 = sbm2t6now; sbm2t7 = sbm2t7now; sbm2t8 = sbm2t8now;

        sbm3i = sbm3inow; sbm3ln = sbm3lnnow; sbm3lnp = sbm3lnpnow; sbm3lhe = sbm3lhenow; sbm3lhep = sbm3lhepnow;
        sbm3hall = sbm3hallnow; sbm3cryovac = sbm3cryovacnow;
        sbm3t1 = sbm3t1now; sbm3t2 = sbm3t2now; sbm3t3 = sbm3t3now; sbm3t4 = sbm3t4now;
        sbm3t5 = sbm3t5now; sbm3t6 = sbm3t6now; sbm3t7 = sbm3t7now; sbm3t8 = sbm3t8now;

        sbm4i = sbm4inow; sbm4ln = sbm4lnnow; sbm4lnp = sbm4lnpnow; sbm4lhe = sbm4lhenow; sbm4lhep = sbm4lhepnow;
        sbm4hall = sbm4hallnow; sbm4cryovac = sbm4cryovacnow;
        sbm4t1 = sbm4t1now; sbm4t2 = sbm4t2now; sbm4t3 = sbm4t3now; sbm4t4 = sbm4t4now;
        sbm4t5 = sbm4t5now; sbm4t6 = sbm4t6now; sbm4t7 = sbm4t7now; sbm4t8 = sbm4t8now;
    end
    
    % h = figure(FigNum);
    % subfig(1,1,1, h);
    %%p = get(h, 'Position');
    %set(h, 'Position', FigurePosition);
    %clf reset;
    clf
    
    subplot(6,1,1)
    plot(t,sbm1i);
    legend(sprintf('I power supply (%.2f A)',sbm1inow),0);
    ylabel('I [A]');
    grid;
    if length(t)>1
        axis([min(t) max(t) 0 320]);
        ChangeAxesLabel(t, Days, DayFlag);
    end
    title(['SBM1 (sector 8) Temperatures ',titleStr]);
    set(gca,'XTickLabel','');
    
    subplot(6,1,2)
    plot(t,sbm1ln,t,sbm1lhe);
    legend(sprintf('LN level (%.1f cm)',sbm1lnnow),sprintf('LHe level (%.1f cm)',sbm1lhenow),'Location','SouthWest');
    ylabel('Liquid Level [cm]');
    grid;
    if length(t)>1
        axis([min(t) max(t) 0 35]);
        ChangeAxesLabel(t, Days, DayFlag);
    end
    set(gca,'XTickLabel','');
    
    subplot(6,1,3)
    plot(t,sbm1lnp, '-', t,sbm1lhep, '--');
    legend(sprintf('LN pressure (%.1f psi)',sbm1lnpnow),sprintf('LHe pressure (%.1f psi)',sbm1lhepnow),0);
    ylabel({'Liquid','Pressure [psi]'});
    grid;
    if length(t)>1
        axis([min(t) max(t) -15 8]);
        ChangeAxesLabel(t, Days, DayFlag);
    end
    set(gca,'XTickLabel','');
    
    subplot(6,1,4)
    semilogy(t,sbm1cryovac);
    legend(sprintf('cryo pressure (%.1e Torr)',sbm1cryovacnow),0);
    ylabel({'Cryostat','Pressure [Torr]'});
    grid;
    %axis tight
    %xaxis([min(t) max(t)])
    if length(t)>1
        axis([min(t) max(t) 1e-8 1e-5]);
        ChangeAxesLabel(t, Days, DayFlag);
    end
    set(gca,'XTickLabel','');
    
    subplot(6,1,5)
    plot(t,sbm1t7,t,sbm1t2,t,sbm1t6,...
        t,sbm1t4,t,sbm1t8);
    hh=legend(sprintf('stage 2 (%.2f K)',sbm1t7now),sprintf('upper coil (%.2f K)',sbm1t2now),sprintf('lower coil (%.2f K)',sbm1t6now), ...
        sprintf('yoke center 1 (%.2f K)',sbm1t4now),sprintf('yoke center 2 (%.2f K)',sbm1t8now),'Location','SouthWest');
    %set(hh, 'Units','Normalized', 'position',[.895 .26 .1 .1]);
    ylabel('T [K]');
    grid;
    if length(t)>1
        if max([sbm1t7 sbm1t2 sbm1t6 sbm1t4 sbm1t8])<5.2
            axis([min(t) max(t) 3.5 5.2]);
        else
            axis tight;
        end
        ChangeAxesLabel(t, Days, DayFlag);
    end
    set(gca,'XTickLabel','');
    
    subplot(6,1,6)
    plot(t,sbm1t3,t,sbm1t1,t,sbm1t5);
    hh=legend(sprintf('stage 1 (%.1f K)',sbm1t3now),sprintf('upper HTS lead (%.1f K)',sbm1t1now), ...
        sprintf('lower HTS lead (%.1f K)',sbm1t5now),'Location','SouthWest');
    %set(hh, 'Units','Normalized', 'position',[.859 .17 .14 .05]);
    %set(hh, 'Units','Normalized', 'position',[.87 .025 .11 .05]);
    ylabel('T [K]');
    grid;
    if length(t)>1
        if max([sbm1t3 sbm1t1 sbm1t5])<80
            axis([min(t) max(t) 40 80]);
        else
            axis tight;
        end
        ChangeAxesLabel(t, Days, DayFlag);
    end
    
    xlabel(xlabelstring);
    %    yaxesposition(1.20);
    orient tall
    
    print -f30 -dpng \\als-filer\physweb\csteier\sbm1_arplot
    
    
    %h = figure(FigNum);
    % subfig(1,1,1, h);
    %%p = get(h, 'Position');
    %set(h, 'Position', FigurePosition);
    % clf reset;
    %set(FigNum,'Visible','off')
    clf
    
    subplot(6,1,1)
    plot(t,sbm2i);
    legend(sprintf('I power supply (%.2f A)',sbm2inow),0);
    ylabel('I [A]');
    grid;
    if length(t)>1
        axis([min(t) max(t) 0 320]);
        ChangeAxesLabel(t, Days, DayFlag);
    end
    title(['SBM2 (sector 4) Temperatures ',titleStr]);
    set(gca,'XTickLabel','');
    
    subplot(6,1,2)
    plot(t,sbm2ln,t,sbm2lhe);
    legend(sprintf('LN level (%.1f cm)',sbm2lnnow),sprintf('LHe level (%.1f cm)',sbm2lhenow),'Location','SouthWest');
    ylabel('Liquid Level [cm]');
    grid;
    if length(t)>1
        axis([min(t) max(t) 0 35]);
        ChangeAxesLabel(t, Days, DayFlag);
    end
    set(gca,'XTickLabel','');
    
    subplot(6,1,3)
    plot(t,sbm2lnp, '-', t,sbm2lhep, '--');
    legend(sprintf('LN pressure (%.1f psi)',sbm2lnpnow),sprintf('LHe pressure (%.1f psi)',sbm2lhepnow),0);
    ylabel({'Liquid','Pressure [psi]'});
    grid;
    if length(t)>1
        axis([min(t) max(t) -15 8]);
        ChangeAxesLabel(t, Days, DayFlag);
    end
    set(gca,'XTickLabel','');
    
    subplot(6,1,4)
    semilogy(t,sbm2cryovac);
    legend(sprintf('cryo pressure (%.1e Torr)',sbm2cryovacnow),0);
    ylabel({'Cryostat','Pressure [Torr]'});
    grid;
    %axis tight
    %xaxis([min(t) max(t)])
    if length(t)>1
        axis([min(t) max(t) 1e-8 1e-5]);
        ChangeAxesLabel(t, Days, DayFlag);
    end
    set(gca,'XTickLabel','');
    
    subplot(6,1,5)
    plot(t,sbm2t7,t,sbm2t2,t,sbm2t6,...
        t,sbm2t4,t,sbm2t8);
    hh=legend(sprintf('stage 2 (%.2f K)',sbm2t7now),sprintf('upper coil (%.2f K)',sbm2t2now),sprintf('lower coil (%.2f K)',sbm2t6now), ...
        sprintf('yoke center 1 (%.2f K)',sbm2t4now),sprintf('yoke center 2 (%.2f K)',sbm2t8now),'Location','SouthWest');
    %set(hh, 'Units','Normalized', 'position',[.895 .26 .1 .1]);
    ylabel('T [K]');
    grid;
    if length(t)>1
        if max([sbm2t7 sbm2t2 sbm2t6 sbm2t4 sbm2t8])<5.2
            axis([min(t) max(t) 3.5 5.2]);
        else
            axis tight;
        end
        ChangeAxesLabel(t, Days, DayFlag);
    end
    set(gca,'XTickLabel','');
    
    subplot(6,1,6)
    plot(t,sbm2t3,t,sbm2t1,t,sbm2t5);
    hh=legend(sprintf('stage 1 (%.1f K)',sbm2t3now),sprintf('upper HTS lead (%.1f K)',sbm2t1now), ...
        sprintf('lower HTS lead (%.1f K)',sbm2t5now),'Location','SouthWest');
    %set(hh, 'Units','Normalized', 'position',[.859 .17 .14 .05]);
    %set(hh, 'Units','Normalized', 'position',[.87 .025 .11 .05]);
    ylabel('T [K]');
    grid;
    if length(t)>1
        if max([sbm2t3 sbm2t1 sbm2t5])<80
            axis([min(t) max(t) 40 80]);
        else
            axis tight;
        end
        ChangeAxesLabel(t, Days, DayFlag);
    end
    
    xlabel(xlabelstring);
    %    yaxesposition(1.20);
    orient tall

    print -f30 -dpng \\als-filer\physweb\csteier\sbm2_arplot
    
    %h = figure(FigNum);
    % subfig(1,1,1, h);
    %%p = get(h, 'Position');
    %set(h, 'Position', FigurePosition);
    %clf reset;
    %set(FigNum,'Visible','off')
    clf
    
    subplot(6,1,1)
    plot(t,sbm3i);
    legend(sprintf('I power supply (%.2f A)',sbm3inow),0);
    ylabel('I [A]');
    grid;
    if length(t)>1
        axis([min(t) max(t) 0 320]);
        ChangeAxesLabel(t, Days, DayFlag);
    end
    title(['SBM3 (SPARE) Temperatures ',titleStr]);
    set(gca,'XTickLabel','');
    
    subplot(6,1,2)
    plot(t,sbm3ln,t,sbm3lhe);
    legend(sprintf('LN level (%.1f cm)',sbm3lnnow),sprintf('LHe level (%.1f cm)',sbm3lhenow),'Location','SouthWest');
    ylabel('Liquid Level [cm]');
    grid;
    if length(t)>1
        axis([min(t) max(t) 0 35]);
        ChangeAxesLabel(t, Days, DayFlag);
    end
    set(gca,'XTickLabel','');
    
    subplot(6,1,3)
    plot(t,sbm3lnp, '-', t,sbm3lhep, '--');
    legend(sprintf('LN pressure (%.1f psi)',sbm3lnpnow),sprintf('LHe pressure (%.1f psi)',sbm3lhepnow),0);
    ylabel({'Liquid','Pressure [psi]'});
    grid;
    if length(t)>1
        axis([min(t) max(t) -15 8]);
        ChangeAxesLabel(t, Days, DayFlag);
    end
    set(gca,'XTickLabel','');
    
    subplot(6,1,4)
    semilogy(t,sbm3cryovac);
    legend(sprintf('cryo pressure (%.1e Torr)',sbm3cryovacnow),0);
    ylabel({'Cryostat','Pressure [Torr]'});
    grid;
    %axis tight
    %xaxis([min(t) max(t)])
    if length(t)>1
        axis([min(t) max(t) 1e-8 1e-5]);
        ChangeAxesLabel(t, Days, DayFlag);
    end
    set(gca,'XTickLabel','');
    
    subplot(6,1,5)
    plot(t,sbm3t7,t,sbm3t2,t,sbm3t6,...
        t,sbm3t4,t,sbm3t8);
    hh=legend(sprintf('stage 2 (%.2f K)',sbm3t7now),sprintf('upper coil (%.2f K)',sbm3t2now),sprintf('lower coil (%.2f K)',sbm3t6now), ...
        sprintf('yoke center 1 (%.2f K)',sbm3t4now),sprintf('yoke center 2 (%.2f K)',sbm3t8now),'Location','SouthWest');
    %set(hh, 'Units','Normalized', 'position',[.895 .26 .1 .1]);
    ylabel('T [K]');
    grid;
    if length(t)>1
        if max([sbm3t7 sbm3t2 sbm3t6 sbm3t4 sbm3t8])<5.2
            axis([min(t) max(t) 3.5 5.2]);
        else
            axis tight;
        end
        ChangeAxesLabel(t, Days, DayFlag);
    end
    set(gca,'XTickLabel','');
    
    subplot(6,1,6)
    plot(t,sbm3t3,t,sbm3t1,t,sbm3t5);
    hh=legend(sprintf('stage 1 (%.1f K)',sbm3t3now),sprintf('upper HTS lead (%.1f K)',sbm3t1now), ...
        sprintf('lower HTS lead (%.1f K)',sbm3t5now),'Location','SouthWest');
    %set(hh, 'Units','Normalized', 'position',[.859 .17 .14 .05]);
    %set(hh, 'Units','Normalized', 'position',[.87 .025 .11 .05]);
    ylabel('T [K]');
    grid;
    if length(t)>1
        if max([sbm3t3 sbm3t1 sbm3t5])<80
            axis([min(t) max(t) 40 80]);
        else
            axis tight;
        end
        ChangeAxesLabel(t, Days, DayFlag);
    end
    
    xlabel(xlabelstring);
    %    yaxesposition(1.20);
    orient tall
    
    print -f30 -dpng \\als-filer\physweb\csteier\sbm3_arplot
    
    %h = figure(FigNum);
    % subfig(1,1,1, h);
    %%p = get(h, 'Position');
    %set(h, 'Position', FigurePosition);
    %clf reset;
    %set(FigNum,'Visible','off')
    clf
    
    subplot(6,1,1)
    plot(t,sbm4i);
    legend(sprintf('I power supply (%.2f A)',sbm4inow),0);
    ylabel('I [A]');
    grid;
    if length(t)>1
        axis([min(t) max(t) 0 320]);
        ChangeAxesLabel(t, Days, DayFlag);
    end
    title(['SBM4 (sector 12) Temperatures ',titleStr]);
    set(gca,'XTickLabel','');
    
    subplot(6,1,2)
    plot(t,sbm4ln,t,sbm4lhe);
    legend(sprintf('LN level (%.1f cm)',sbm4lnnow),sprintf('LHe level (%.1f cm)',sbm4lhenow),'Location','SouthWest');
    ylabel('Liquid Level [cm]');
    grid;
    if length(t)>1
        axis([min(t) max(t) 0 35]);
        ChangeAxesLabel(t, Days, DayFlag);
    end
    set(gca,'XTickLabel','');
    
    subplot(6,1,3)
    plot(t,sbm4lnp, '-', t,sbm4lhep, '--');
    legend(sprintf('LN pressure (%.1f psi)',sbm4lnpnow),sprintf('LHe pressure (%.1f psi)',sbm4lhepnow),0);
    ylabel({'Liquid','Pressure [psi]'});
    grid;
    if length(t)>1
        axis([min(t) max(t) -15 8]);
        ChangeAxesLabel(t, Days, DayFlag);
    end
    set(gca,'XTickLabel','');
    
    subplot(6,1,4)
    semilogy(t,sbm4cryovac);
    legend(sprintf('cryo pressure (%.1e Torr)',sbm4cryovacnow),0);
    ylabel({'Cryostat','Pressure [Torr]'});
    grid;
    %axis tight
    %xaxis([min(t) max(t)])
    if length(t)>1
        axis([min(t) max(t) 1e-8 1e-5]);
        ChangeAxesLabel(t, Days, DayFlag);
    end
    set(gca,'XTickLabel','');
    
    subplot(6,1,5)
    plot(t,sbm4t7,t,sbm4t2,t,sbm4t6,...
        t,sbm4t4,t,sbm4t8);
    hh=legend(sprintf('stage 2 (%.2f K)',sbm4t7now),sprintf('upper coil (%.2f K)',sbm4t2now),sprintf('lower coil (%.2f K)',sbm4t6now), ...
        sprintf('yoke center 1 (%.2f K)',sbm4t4now),sprintf('yoke center 2 (%.2f K)',sbm4t8now),'Location','SouthWest');
    %set(hh, 'Units','Normalized', 'position',[.895 .26 .1 .1]);
    ylabel('T [K]');
    grid;
    if length(t)>1
        if max([sbm4t7 sbm4t2 sbm4t6 sbm4t4 sbm4t8])<5.2
            axis([min(t) max(t) 3.5 5.2]);
        else
            axis tight;
        end
        ChangeAxesLabel(t, Days, DayFlag);
    end
    set(gca,'XTickLabel','');
    
    subplot(6,1,6)
    plot(t,sbm4t3,t,sbm4t1,t,sbm4t5);
    hh=legend(sprintf('stage 1 (%.1f K)',sbm4t3now),sprintf('upper HTS lead (%.1f K)',sbm4t1now), ...
        sprintf('lower HTS lead (%.1f K)',sbm4t5now),'Location','SouthWest');
    %set(hh, 'Units','Normalized', 'position',[.859 .17 .14 .05]);
    %set(hh, 'Units','Normalized', 'position',[.87 .025 .11 .05]);
    ylabel('T [K]');
    grid;
    if length(t)>1
        if max([sbm4t3 sbm4t1 sbm4t5])<80
            axis([min(t) max(t) 40 80]);
        else
            axis tight;
        end
        ChangeAxesLabel(t, Days, DayFlag);
    end
    
    xlabel(xlabelstring);
    %    yaxesposition(1.20);
    orient tall
    
    set(30,'Visible','off')

    print -f30 -dpng \\als-filer\physweb\csteier\sbm4_arplot
    
    pause(60);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ChangeAxesLabel(t, Days, DayFlag)
xaxis([0 max(t)]);

if DayFlag
    if size(Days,2) > 1
        Days = Days'; % Make a column vector
    end
    
    MaxDay = round(max(t));
    set(gca,'XTick',[0:MaxDay]');
    %xaxis([0 MaxDay]);
    
    if length(Days) < MaxDay-1
        % Days were skipped
        set(gca,'XTickLabel',strvcat(num2str([0:MaxDay-1]'+Days(1)),' '));
    else
        % All days plotted
        set(gca,'XTickLabel',strvcat(num2str(Days),' '));
    end
    
    XTickLabelString = get(gca,'XTickLabel');
    if MaxDay < 20
        % ok
    elseif MaxDay < 40
        set(gca,'XTick',[0:2:MaxDay]');
        set(gca,'XTickLabel',XTickLabelString(1:2:MaxDay-1,:));
   elseif MaxDay < 63
      set(gca,'XTick',[0:3:MaxDay]');       
      set(gca,'XTickLabel',XTickLabelString(1:3:MaxDay-1,:));       
   elseif MaxDay < 80
      set(gca,'XTick',[0:4:MaxDay]');       
      set(gca,'XTickLabel',XTickLabelString(1:4:MaxDay-1,:));       
   end
end
