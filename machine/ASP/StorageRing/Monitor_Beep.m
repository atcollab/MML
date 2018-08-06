function monitor_beep()

% This simple program monitors the Required Channels in the Linac/Booster system to determine
% when the devices being observed have tripped. These devices include Booster RF
% status, Linac Klystron 01 status, Linac Klystron 02 status and the Linac
% Gun status. This file can be easily modified for other devices. A file is created 
filename = 'file.cam'; % (change filename here)
% which records which device
% tripped, although not the specific cause, and at what time it occured.
% Where applicable the Voltage and Current are also recorded. The file is 
% created so that previous information will not be overwritten. This
% information is also displayed on the screen.


beep on; % ensure the system buzzer is accessable
pause on;

%Open Channel Access
h1 = mcaopen(['LI-RF-GUN-01:STATE']);
h2 = mcaopen(['LI-RF-GUN-01:ILKSUM']);
h3 = mcaopen(['LI-RF-AMPL-01:ILKSUM']);
h4 = mcaopen(['LI-RF-AMPL-02:ILKSUM']);
h5 = mcaopen(['LI-RF-AMPL-01:PFN:HV']);
h6 = mcaopen(['LI-RF-AMPL-02:PFN:HV']);
h7 = mcaopen(['LI-RF-GUN-01:I01']);
h8 = mcaopen(['LI-RF-GUN-01:V04']);
h9 = mcaopen(['LI-RF-GUN-01:ILK16']);
h10 = mcaopen(['LI-RF-GUN-01:HV']);
h11 = mcaopen(['BS_RF_LLRF:RF_STATUS']);


%Klystron 2 interlocks
% h2 = mcaopen(['LI-AS-RF-02:ILK01']);
% h3 = mcaopen(['LI-AS-RF-02:ILK02']);
% h4 = mcaopen(['LI-AS-RF-02:WG:ILK01']);
% %Klystron 1 interlocks
% h5 = mcaopen(['LI-AS-RF-01:ILK01']);
% h6 = mcaopen(['LI-AS-RF-01:ILK02']);
% h7 = mcaopen(['LI-AS-RF-01:WG:ILK01']);

fid = fopen(filename, 'a'); % Creat a handle for the open file

% scrsz = get(0,'ScreenSize');
% figure('Position',[1 scrsz(4)/8 scrsz(3)/8 scrsz(4)/8])

c=fix(clock);
fprintf(fid,'\ryear month day hour minute second \n');
fprintf(fid,'Started: ');
fprintf(fid,'%d ',c);
fprintf(fid,'\n');
% fclose(fid);
disp('Started at');
disp(c);

while 1 % Caution infinite loop, ** need a way to get out **
% while ~waitforbuttonpress  
% while ~getkey

%Get Monitoring Information

linac_gun_state = mcaget(h1);
klystron01_ilk = mcaget(h3);
klystron02_ilk = mcaget(h4);
linac_gun_ilk = mcaget(h2);
linac_gun_v = mcaget(h8);
linac_gun_i = mcaget(h7);
linac_gun_hwilk = mcaget(h9);
% linac_gun_hv = mcaget(10);
klystron01_hv = mcaget(h5);
klystron02_hv = mcaget(h6);

booster_rf_status = mcaget(h11);


% disp('Linac Gun State is ');
% disp(linac_gun_state);


if (klystron01_ilk ~= 0)
    disp('Klystron 01 is ');
    disp(klystron01_ilk);
    c = fix(clock);
    disp(c);
%     fid = fopen(filename, 'a');
    fprintf(fid,'Klystron01 failed: ');
    fprintf(fid,'%d ',c);
    fprintf(fid,'\n');
%     fclose(fid);
    beeper();
end    
if (klystron02_ilk ~= 0)
    disp('Klystron 02 is ');
    disp(klystron02_ilk);
    c = fix(clock);
    disp(c);
%     fid = fopen(filename, 'a');
    fprintf(fid,'Klystron02 failed: ');
    fprintf(fid,'%d ',c);
    fprintf(fid,'\n');
%     fclose(fid);
    beeper();
end
if (linac_gun_ilk ~= 0) % click LI-RF-GUN-01 reset if this causes trouble
    disp('Linac Gun Sum Interlock is ');
    disp(linac_gun_ilk);
    c = fix(clock);
    disp(c);
%     fid = fopen(filename, 'a');
    fprintf(fid,'Linac Gun Sum Interlocked: ' );
    fprintf(fid,'%d ',c);
    fprintf(fid,'\n');
%     fclose(fid);
    beeper();
end
if (klystron01_hv < 35)
    disp('Klystron 01 HV is');
    disp(klystron01_hv);
    c = fix(clock);
    disp(c);
%     fid = fopen(filename, 'a');
    fprintf(fid,'Klystron01 HV failed (%i): ',klystron01_hv);
    fprintf(fid,'%d ',c);
    fprintf(fid,'\n');
%     fclose(fid);
    beeper();
end
if (klystron02_hv < 35)
    disp('Klystron 02 HV is');
    disp(klystron02_hv);
    c = fix(clock);
    disp(c);
%     fid = fopen(filename, 'a');
    fprintf(fid,'Klystron02 HV failed (%i): ',klystron02_hv);
    fprintf(fid,'%d ',c);
    fprintf(fid,'\n');
%     fclose(fid);
    beeper();
end
if (linac_gun_v < 6)|(linac_gun_i < 1)|(linac_gun_hwilk ~= 0) %|(linac_gun_hv < 88)
    disp('Linac Gun has Problems');
    disp(linac_gun_v);
    disp(linac_gun_i);
    disp(linac_gun_hwilk);
    disp(linac_gun_hv);
    c = fix(clock);
    disp(c);
%     fid = fopen(filename, 'a');
    fprintf(fid,'Linac Gun failed (V: %i) (I: %i): ',linac_gun_v,linac_gun_i);
    fprintf(fid,'%d ',c);
    fprintf(fid,'\n');
%     fclose(fid);
    beeper();
end
if (booster_rf_status ~= 1)
    disp('Booster RF Status is');
    disp(booster_rf_status);
    c = fix(clock);
    disp(c);
%     fid = fopen(filename, 'a');
    fprintf(fid,'Booster RF failed: ');
    fprintf(fid,'%d ',c);
    fprintf(fid,'\n');
%     fclose(fid);
    beeper_booster_RF();    

end % end if's

pause(2);

end % end while

beep off;
pause off;

c = fix(clock);
disp('Ended at');
disp(c);

% fid = fopen(filename, 'a');
fprintf(fid,'Ended:   ');
fprintf(fid,'%d ',c);
fprintf(fid,'\n');
fclose(fid);    % Close the Opened File

%Close Channel Access
mcaclose(h1);
mcaclose(h2);
mcaclose(h3);
mcaclose(h4);
mcaclose(h5);
mcaclose(h6);
mcaclose(h7);
mcaclose(h8);
mcaclose(h9);
mcaclose(h10);
mcaclose(h11);

function beeper()

    beep;
    pause(0.25);
    beep;
    pause(1);
    beep;
    pause(1);
    beep;
    pause(0.25);
    beep;
    pause(1.5);
%     beep;
%     pause(1);
%     beep;
%     pause(0.25);
%     beep;
%     pause(5);

function beeper_booster_RF()

    beep;
    pause(0.25);
    beep;
    pause(0.25);
    beep;
    pause(0.25);
    beep;
    pause(1.25);
    beep;
    pause(2);

    
function ch = getkey(m) 

% GETKEY - get a single keypress
%   CH = GETKEY waits for a keypress and returns the ASCII code. Accepts
%   all ascii characters, including backspace (8), space (32), enter (13),
%   etc, that can be typed on the keyboard. CH is a double.
%
%   CH = GETKEY('non-ascii') uses non-documented matlab 6.5 features to
%   return a string describing the key pressed so keys like ctrl, alt, tab
%   etc. can also be used. CH is a string.
%
%   This function is kind of a workaround for getch in C. It uses a modal, but
%   non-visible window, which does show up in the taskbar.
%   C-language keywords: KBHIT, KEYPRESS, GETKEY, GETCH
%
%   Examples:
%
%    fprintf('\nPress any key: ') ;
%    ch = getkey ;
%    fprintf('%c\n',ch) ;
%
%    fprintf('\nPress the Ctrl-key: ') ;
%    if strcmp(getkey('non-ascii'),'control'),
%      fprintf('OK\n') ;
%    else
%      fprintf(' ... wrong key ...\n') ;
%    end
%
%  See also INPUT, CHAR

% (c) 2005 Jos
% email jos @ jasen .nl
% Feel free to (ab)use, modify or change this contribution


% Determine the callback string to use
if nargin == 1,
    if strcmp(lower(m),'non-ascii'),
        callstr = ['set(gcbf,''Userdata'',get(gcbf,''Currentkey'')) ; uiresume '] ;
    else       
        error('Argument should be the string ''non-ascii''') ;
    end
else
    callstr = ['set(gcbf,''Userdata'',double(get(gcbf,''Currentcharacter''))) ; uiresume '] ;
end

% Set up the figure
% May be the position property  should be individually tweaked to avoid visibility
fh = figure('keypressfcn',callstr, ...
    'windowstyle','modal',...    
    'position',[0 0 1 1],...
    'Name','GETKEY', ...
    'userdata','timeout') ; 
try
    % Wait for something to happen
    uiwait ;
    ch = get(fh,'Userdata') ;
catch
    % Something went wrong, return and empty matrix.
    ch = [] ;
end
close(fh) ;
    