function fill_cam_buckets
% fill_cam_buckets.m
%
% Christoph Steier, September 2010

if getpv('sr:user_beam')
    error('This routine should only be used, if the user beam shutters are closed (because it makes use of full booster frequency)');
end
    
try
    goalcurr = getpv('Topoff_goal_current_SP');          % current to keep [mA]
    if (goalcurr>500) || (goalcurr<17)
        goalcurr=500;
        setpv('Topoff_goal_current_SP',goalcurr);
    end
    goalcurr_cam = getpv('Topoff_cam_goal_current_SP');        % target current for cam_bucket [mA]
    if (goalcurr_cam>6) || (goalcurr_cam<1)
        goalcurr_cam=5;
        setpv('Topoff_cam_goal_current_SP',goalcurr_cam);
    end
    
    % Use this for dual cam buckets
    cam_bucket = [150 318];        % target bucket for camshaft bunch (1-328)
    
    gunwidth = 12;           % gunwidth for 4 gun bunches in ns
    
%     startbias=getpv('EG______BIAS___AC01');
%     startbias = 40;
%     if startbias>50
%         startbias=40;
%     end
    
    start_inj_trig=getpv('BR1_____TIMING_AM00');
    if abs(start_inj_trig-5000)>500
        start_inj_trig=5000;
    end
    
    injtrigdelta=getpv('Topoff_cam_inj_field_delta_SP');
    if isnan(injtrigdelta) || (injtrigdelta>70) || (injtrigdelta<5)
        injtrigdelta=35;
    end
    
    enable_disable_triggers(1);
    
    % Switching bucket loading from table mode to direct bucket control
    fprintf('Bucket loading is controlled directly by this program\n');
    setpv('SR01C___TIMING_AC11',0);
    setpv('SR01C___TIMING_AC13',0);
    
    fprintf('Filling bucket %d\n',cam_bucket(1));
    setpv('SR01C___TIMING_AC08',cam_bucket(1));
    
    fprintf('Setting gun width to %d ns\n',gunwidth);
    setpv('GTL_____TIMING_AC02',gunwidth+1);
    pause(2);
    setpv('GTL_____TIMING_AC02',gunwidth);
    
    fprintf('Setting booster injection field trigger to %d for single bunch (delta = %d)\n',start_inj_trig+injtrigdelta,injtrigdelta);
    setpv('BR1_____TIMING_AC00',start_inj_trig+injtrigdelta);

    fprintf('Putting in LTB TV3 and switching video channel so that you can confirm whether there is only one LINAC bunch\n');
    setpv('ltb_video_mux',6);
    setpv('LTB_____TV3____BC16',255);
    setpv('LTB_____TV3LIT_BC17',255);

    StartFlag = questdlg({'This function will fill the cam buckets','Gunwidth has been set automatically.',' ','Have you checked whether there is only one bunch on LTB TV3?'},'Single Bunch','Yes','No','No');

    setpv('LTB_____TV3____BC16',0);
    setpv('LTB_____TV3LIT_BC17',0);

    pause(0.5);
    
    if strcmp(StartFlag,'Yes')
        
        while (getdcct<goalcurr) && (getpv('Cam1_current')<goalcurr_cam)
            fprintf('Opening LTB TV6 paddle (if not already open) ...\n');
            setpv('LTB_____TV6____BC19',0);
            pause(1.44);
            fprintf('Cam 1 current = %.1f mA (goal = %.1f was read from Topoff_cam_goal_current_SP PV)\n',getpv('Cam1_current'),goalcurr_cam);
        end
        
        fprintf('Putting LTB TV6 paddle into linac beam\n');
        setpv('LTB_____TV6____BC19',255);
        pause(2);
        
        fprintf('Filling bucket %d\n',cam_bucket(2));
        setpv('SR01C___TIMING_AC08',cam_bucket(2));
        
        fprintf('Setting gun width to %d ns\n',gunwidth);
        setpv('GTL_____TIMING_AC02',gunwidth+1);
        pause(2);
        setpv('GTL_____TIMING_AC02',gunwidth);
        pause(0.5);
        
        while (getdcct<goalcurr) && (getpv('Cam2_current')<goalcurr_cam)
            fprintf('Opening LTB TV6 paddle (if not already open) ...\n');
            setpv('LTB_____TV6____BC19',0);
            pause(1.44);
            fprintf('Cam 2 current = %.1f mA (goal = %.1f was read from Topoff_cam_goal_current_SP PV)\n',getpv('Cam2_current'),goalcurr_cam);
        end
        
    end
    
    fprintf('Putting LTB TV6 paddle into linac beam\n');
    setpv('LTB_____TV6____BC19',255);
    pause(2);
    
    fprintf('Setting booster injection field trigger to %d for multi bunch\n',start_inj_trig);
    setpv('BR1_____TIMING_AC00',start_inj_trig);
    pause(0.5);
    exit_cleanup
    disp('Exiting ...');
    
catch
    fprintf('Setting booster injection field trigger to %d for multi bunch\n',start_inj_trig);
    setpv('BR1_____TIMING_AC00',start_inj_trig);
    exit_cleanup
    setpv('LTB_____TV3____BC16',0);
    setpv('LTB_____TV3LIT_BC17',0);
    disp('Exiting ...');
end

return
        

%-------------------------------------------------
function enable_disable_triggers(varargin)
if nargin~=1
    fprintf('enable_disable_triggers: You need to provide one input argument\n');
    return
end


if varargin{1}==0
    % GUN trigger
    setpv('GTL_____TIMING_BC00',0);
    % Booster Injection Kicker
    setpv('BR1_____KI_P___BC17',0);
    % Booster Extraction Bump Magnets (3 magnets)
    setpv('BR2_____BUMP_P_BC21',0);
    % Booster Extraction Kicker
    setpv('BR2_____KE_P___BC17',0);
    % Booster extraction thin septum
    setpv('BR2_____SEN_P__BC22',0);
    % Booster extraction thick septum
    setpv('BR2_____SEK_P__BC23',0);
    % SR injection thick septum
    setpv('SR01S___SEK_P__BC23',0);
    % SR injection thin septum
    setpv('SR01S___SEN_P__BC22',0);
    % SR injection bumps (4 magnets)
    setpv('SR01S___BUMP1P_BC22',0);
elseif varargin{1}==1
    % GUN trigger
    setpv('GTL_____TIMING_BC00',1);
    % Booster Injection Kicker
    setpv('BR1_____KI_P___BC17',1);
    % Booster Extraction Bump Magnets (3 magnets)
    setpv('BR2_____BUMP_P_BC21',1);
    % Booster Extraction Kicker
    setpv('BR2_____KE_P___BC17',1);
    % Booster extraction thin septum
    setpv('BR2_____SEN_P__BC22',1);
    % Booster extraction thick septum
    setpv('BR2_____SEK_P__BC23',1);
    % SR injection thick septum
    setpv('SR01S___SEK_P__BC23',1);
    % SR injection thin septum
    setpv('SR01S___SEN_P__BC22',1);
    % SR injection bumps (4 magnets)
    setpv('SR01S___BUMP1P_BC22',1);
end
return

%-------------------------------------------------
function exit_cleanup(varargin)
fprintf('Putting LTB TV6 paddle into linac beam\n');
setpv('LTB_____TV6____BC19',255);
pause(2);
fprintf('Re-enabling injector and SR injection triggers\n');
% GUN trigger
setpv('GTL_____TIMING_BC00',1);
% Booster Injection Kicker 
setpv('BR1_____KI_P___BC17',1);
% Booster Extraction Bump Magnets (3 magnets)
setpv('BR2_____BUMP_P_BC21',1);
% Booster Extraction Kicker 
setpv('BR2_____KE_P___BC17',1);
% Booster extraction thin septum
setpv('BR2_____SEN_P__BC22',1);
% Booster extraction thick septum
setpv('BR2_____SEK_P__BC23',1);
% SR injection thick septum
setpv('SR01S___SEK_P__BC23',1);
% SR injection thin septum
setpv('SR01S___SEN_P__BC22',1);
% SR injection bumps (4 magnets)
setpv('SR01S___BUMP1P_BC22',1);
% Switch bucket timing control back to table
fprintf('Bucket timing control switched back to table, i.e. SRinject\n');
setpv('SR01C___TIMING_AC11',255);
setpv('SR01C___TIMING_AC13',255);

if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
    fprintf('Setting gun width to 12 ns\n');
    setpv('GTL_____TIMING_AC02',12);
else
    fprintf('Setting gun width to 36 ns\n');
    setpv('GTL_____TIMING_AC02',36);
end
pause(1);
return


