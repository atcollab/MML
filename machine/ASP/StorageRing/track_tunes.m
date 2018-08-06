function track_tunes(current_tunes,fixtunes2,varargin)

increment = 0;
if nargin > 2 && ischar(varargin{1}) && strcmpi(varargin{1},'increment')
    increment = 1;
end

% xtune_pv = 'CR01:GENERAL_ANALOG_02_MONITOR';
% xtune_handle = mcacheckopen(xtune_pv);
% ytune_pv = 'CR01:GENERAL_ANALOG_03_MONITOR';
% ytune_handle = mcacheckopen(ytune_pv);
% if xtune_handle == 0
%     error('Cant open channel to xtune');
% end
% if ytune_handle == 0
%     error('Cant open channel to xtune');
% end


% fixtunes2 = [0.29 0.216 0];
%  current_tunes = [mcaget(xtune_handle) mcaget(ytune_handle) 0];
% current_tunes = [0.2913 0.2145 0.00];
% current_tunes = [getam('TUNE')' 0];
delta_nu = fixtunes2 - current_tunes;
delta_nu(3) = 0;

% fprintf('\n Current fractional tunes are: [%6.3f %6.3f] dispersion = %6.7f\n', current_tunes);
% fprintf(' Delta fractional tunes are: [%6.3f %6.3f]  dispersion = %6.7f\n', delta_nu);

% Inverse Jacobian measured using the model.
Jinv = [...
    0.130094898781898,0.000379003570963,0.100529311940219;...
    -0.105532343683691,-0.139777190998969,-0.004112213885454;...
    0.022078330803986,0.029242080859334,-0.054916466546098;];

% Order QFA QDA QFB
initk = [1.7619022 -1.0859714 1.5444376]';

% Fit the tunes but don't change the dispersion, therefore the last element
% is zero.
deltak = Jinv*[delta_nu]';

percentage_change = deltak./initk;

% Read current setpoints
currentquads = [];
currentquads(:,1) = getsp('QFA','Hardware');
currentquads(:,2) = getsp('QDA','Hardware');
currentquads(:,3) = getsp('QFB','Hardware');

% Calculate percentage changes
deltacurrentquads(:,1) = percentage_change(1).*currentquads(:,1);
deltacurrentquads(:,2) = percentage_change(2).*currentquads(:,2);
deltacurrentquads(:,3) = percentage_change(3).*currentquads(:,3);

if max(percentage_change) > 0.05
    % If greater than 5% change then ask for confirmation
    switch questdlg('Change in quads > 5%%. Are you sure?','Tune Tracking Question',...
                'Yes','No','Yes');
        case 'No'
            disp('No changes made. goodbye');
            return
    end
end
% fprintf(' Change in currents are: %6.3f (QFA) %6.3f (QDA) %6.3f (QFB)\n',...
%     deltacurrentquads(1,:));

if increment
    % In 10 incremental steps
    finished = 0;
    i = 0;
    while ~finished
        setsp('QFA',currentquads(:,1) + deltacurrentquads(:,1)*(i/10),'Hardware');
        setsp('QDA',currentquads(:,2) + deltacurrentquads(:,2)*(i/10),'Hardware');
        setsp('QFB',currentquads(:,3) + deltacurrentquads(:,3)*(i/10),'Hardware');
        switch questdlg(sprintf('Continue with tracking tunes? Step %d/10',i),'Tune Tracking Question',...
                'Continue','Backstep','Finished','Continue');
            case 'Continue'
                i = i + 1;
            case 'Backstep'
                i = i - 1;
            case 'Finished'
                finished = 1;
        end
    end
else
%     switch questdlg('Apply new tunes?','Tune Tracking Question',...
%                 'Yes','No','No');
%         case 'Yes'
% Apply quad values completely
if max(percentage_change) > 0.05
    % Do in two steps
    setsp('QFA',currentquads(:,1) + deltacurrentquads(:,1)*0.5,'Hardware');
    setsp('QDA',currentquads(:,2) + deltacurrentquads(:,2)*0.5,'Hardware');
    setsp('QFB',currentquads(:,3) + deltacurrentquads(:,3)*0.5,'Hardware');
    pause(1);
    setsp('QFA',currentquads(:,1) + deltacurrentquads(:,1),'Hardware');
    setsp('QDA',currentquads(:,2) + deltacurrentquads(:,2),'Hardware');
    setsp('QFB',currentquads(:,3) + deltacurrentquads(:,3),'Hardware');
else
    setsp('QFA',currentquads(:,1) + deltacurrentquads(:,1),'Hardware');
    setsp('QDA',currentquads(:,2) + deltacurrentquads(:,2),'Hardware');
    setsp('QFB',currentquads(:,3) + deltacurrentquads(:,3),'Hardware');
end
%         otherwise
%             disp('Not applying changes. Goodbye');
%     end
end
    
return



% Some measurements taken on the 11/10/06
mf = 1387.866895;
Initatunes = [407.4654	286.44708]./mf;
Finaltunes = [400.8038	289.77786]./mf;
% Delta Tune due to QFA
J(1:2,1) = ([492.95544	223.16226]-[325.3061	350.8421])./mf;
% Delta Dispersion due to QFA
J(3,1) = -0.003501+0.003327;

% Delta Tune due to QDA
J(1:2,2) = ([384.14996	354.1729] - [425.2295	225.3827])./mf;
% Delta Dispersion due to QDA
J(3,2) = 0.01104+0.02191;

% Delta Tune due to QFB
J(1:2,3) = ([548.800	190.400] - [277.7620	385.5622])./mf;
% Delta Dispersion due to QFB
J(3,3) = -0.1851-0.08853;
