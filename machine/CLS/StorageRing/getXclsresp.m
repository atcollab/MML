function [Xresp, Yresp] = getXclsresp(kickVal)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/getXclsresp.m 1.2 2007/03/02 09:02:26CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
%the input is :
% - kickVal  this is the amount of kick to apply to each of the correctors
%create an output file to save the workspace
% ----------------------------------------------------------------------------------------------

FileName = 'WKSPCE';
DirectoryName = getfamilydata('Directory','BPMData');
FileName = appendtimestamp(FileName, clock);
[FileName, DirectoryName] = uiputfile('*.mat','Save all of the workspace (including the Yresp and Xresp data)', [DirectoryName FileName]);
[DirectoryName, DirectoryErrorFlag] = gotodirectory(DirectoryName);

[tmp timeout error] = getam('HCM');
if error
    disp('Problem getting data from the HCM')
    return
else
    numcor = length(tmp);
end

% Eugene Hack to only get first 20
% numcor = 20;

tempY = [];
Yresp = zeros(48,numcor);
Xresp = zeros(48,numcor);
tempYmon = [];
tempXmon = [];
initXCor = getsp('HCM');
avgOverTurns = 3;

if ~exist('kickVal')
    kickVal = 200000;
end

for i=1:numcor
    fprintf('measuring Vertical element %d\n',i);
    tempXmon = getx;
    tempYmon = gety;

    setpv('HCM','Setpoint',initXCor(i) + kickVal,i);
    pause(3.0);
    %get current Row only
    % normalize the response: should be row vector?
    % Eugene 7/12/03 Added averaging
    tmpx = 0;
    tmpy = 0;
    for j=1:avgOverTurns
        tmpx = tmpx + ((tempXmon - getx) / kickVal);
        pause(0.25)
        tmpy = tmpy + ((tempYmon - gety) / kickVal);
        pause(0.25);
    end
    Xresp(:,i) =  tmpx/avgOverTurns;
    Yresp(:,i) =  tmpy/avgOverTurns;
    
    %set corrector back to original setting
    setpv('HCM','Setpoint',initXCor(i),i);
    pause(3.0);
% disp('calculating y respmatrix')
end

%save workspace
save(FileName);

%plot the two responses
%figure; contour(Xresp); title('X Response from X kick of %d',kickVal);
%figure; contour(Yresp); title('Y Response from X kick of %d',kickVal);


% 
% Yresp = [1 3 76 2 5 7 2;
%          2 5 1  43 5 1 4;
%          1 4 1 3 4 6 7 ;
%          1 4 1 3 5 3 4;
%          6 2 6 21 5 1 63;
%          2 6 4 6 8 0 4;
%          2 4 6 3 5 8 12;]
%      
% assignin('base','Yresponsematrix',Yresp)

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/getXclsresp.m  $
% Revision 1.2 2007/03/02 09:02:26CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
