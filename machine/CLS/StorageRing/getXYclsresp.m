function [resp] = getYXclsresp(kickVal)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/getXYclsresp.m 1.2 2007/03/02 09:02:46CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
% getXYclsresp - will measure the X and Y response together using kicks
% in the horizontal and vertical direction.
%the input is :
% - kickVal  this is the amount of kick to apply to each of the correctors
% ----------------------------------------------------------------------------------------------

[tmp timeout error] = getam('VCM');
if error
    disp('Problem getting data from the VCM')
    return
else
    numcor = length(tmp);
end

numcor = numcor*2; % Both horizontal and vertical correctors. ASSUMING equal number.
numbpm = numcor; % ASSUMING square and have as many BPMs as correctors
maxcorrval = 5e6; % warns when trying to set above this value.

tempY = [];
tempX = [];
tempYmon = [];
tempXmon = [];
initVCor = getsp('VCM');
initHCor = getsp('HCM');
resp.full = zeros(numbpm,numcor);
avgOverTurns = 100;
wait_per_corrector = 5.0;  % seconds
wait_per_sample = 0.25; % seconds

% HH: Horizontal response given horizontal kicks
% VH: Vertical response given horizontal kicks
% HV: Horizontal response given vertical kicks
% VV: Vertical response given vertical kicks
HH_1 = [1:numcor/2]; HH_2 = [1:numbpm/2];
VH_1 = [1:numcor/2]; VH_2 = [numbpm/2 + 1:numbpm];
HV_1 = [numbpm/2 + 1:numbpm]; HV_2 = [1:numcor/2];
VV_1 = [numbpm/2 + 1:numbpm]; VV_2 = [numbpm/2 + 1:numbpm];

if ~exist('kickVal')
    kickVal = 200000;
end

% Start with horizontal correctors
for i=1:numcor/2
    fprintf('kicking with Horizontal corrector %d\n',i);
    tempXmon = getx;
    tempYmon = gety;

    if (initHCor(i) + kickVal) > maxcorrval
        reply = questdlg(['Kick value above set maximum. Apply this kick: ' num2str(maxcorval)], 'Warning: Maximum kick achieved');
        if ~strcmpi(reply,'yes')
            return
        end
    end
    setpv('HCM','Setpoint',initHCor(i) + kickVal,i);
    pause(wait_per_corrector);
    %get current Row only
    % normalize the response: should be row vector?
    % Eugene 7/12/03 Added averaging
    tmpY = 0;
    tmpX = 0;
    for j=1:avgOverTurns
        tmpX = tmpX + ((tempXmon - getx) / kickVal);
        pause(wait_per_sample);
        tmpY = tmpY + ((tempYmon - gety) / kickVal);
        pause(wait_per_sample);
    end
    Xresp(:,i) =  tmpX/avgOverTurns;
    Yresp(:,i) =  tmpY/avgOverTurns;
    
    %set corrector back to original setting
    setpv('HCM','Setpoint',initHCor(i),i);
end

resp.full(HH_1,HH_2) = Xresp;
resp.full(VH_1,VH_2) = Yresp;
resp.HH = Xresp;
resp.VH = Yresp;

% Next, y correctors
for i=1:numcor/2
    fprintf('kicking with Horizontal corrector %d\n',i);
    tempXmon = getx;
    tempYmon = gety;

    if (initVCor(i) + kickVal) > maxcorrval
        reply = questdlg(['Kick value above set maximum. Apply this kick: ' num2str(maxcorval)], 'Warning: Maximum kick achieved');
        if ~strcmpi(reply,'yes')
            return
        end
    end
    setpv('VCM','Setpoint',initVCor(i) + kickVal,i);
    pause(wait_per_corrector);
    %get current Row only
    % normalize the response: should be row vector?
    % Eugene 7/12/03 Added averaging
    tmpY = 0;
    tmpX = 0;
    for j=1:avgOverTurns
        tmpX = tmpX + ((tempXmon - getx) / kickVal);
        pause(wait_per_sample);
        tmpY = tmpY + ((tempYmon - gety) / kickVal);
        pause(wait_per_sample);
    end
    Xresp(:,i) =  tmpX/avgOverTurns;
    Yresp(:,i) =  tmpY/avgOverTurns;
    
    %set corrector back to original setting
    setpv('VCM','Setpoint',initVCor(i),i);
end

resp.full(HV_1,HV_2) = Xresp;
resp.full(VV_1,VV_2) = Yresp;
resp.HV = Xresp;
resp.VV = Yresp;

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/getXYclsresp.m  $
% Revision 1.2 2007/03/02 09:02:46CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
