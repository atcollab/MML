function ztec = ztec_setup(ztec)
% ztec = ztec_setup(ztec)

%%%%%%%%%%%%%%%%%%%%
% Setup Ztec Scope %
%%%%%%%%%%%%%%%%%%%%

if nargin < 1
    ztec = als_waveforms_setup('');
end

% MUX
if isfield(ztec.Device, 'MUX') && ~isempty(ztec.Device.MUX)
    % Set the mux
    setpv(ztec.Device.MUX.Ch1.Name, ztec.Device.MUX.Ch1.Value);
    setpv(ztec.Device.MUX.Ch2.Name, ztec.Device.MUX.Ch2.Value);
    setpv(ztec.Device.MUX.Trig.Name, ztec.Device.MUX.Trig.Value);
end


ScopeName = ztec.Device.Name;

% Set defaults
ChanNames = fieldnames(ztec.Device.Setup);
for i = 1:length(ChanNames)
   %fprintf('  %s\n', [ScopeName, ':', ChanNames{i}]);
    
    setpvonline([ScopeName, ':', ChanNames{i}], ztec.Device.Setup.(ChanNames{i}));
    
    % Just to be safe, I'm adding some delay after certain sets
    if any(strcmpi(ChanNames{i}, {'setOutCoerce','setHorzPoints','setHorzTime'}))
        pause(.05);
    end
    if any(strcmpi(ChanNames{i}, {'setRestoreState'}))
        pause(.5);  % test this???
    end
end
pause(.1);


% With coerce on, set twice (I'm not sure why)
% try
%     if getpvonline([ScopeName,':getOutCoerce'],'double')
%         % Note: setHorzTime and setHorzPoints maynot be in the ztec structure
%         setpvonline([ScopeName,':setHorzTime'],   ztec.Device.Setup.setHorzTime);
%         setpvonline([ScopeName,':setHorzPoints'], ztec.Device.Setup.setHorzPoints);
%         pause(.05);
%     end
% catch
% end


fprintf('   %s (%s)\n', ztec.Device.ScopeType, ztec.Device.Name);
fprintf('   setHorzPoints = %d\n', getpvonline([ScopeName,':setHorzPoints']));
fprintf('   getHorzPoints = %d\n', getpvonline([ScopeName,':getHorzPoints']));
fprintf('   setHorzTime   = %g sec (%g Hz)\n', getpvonline([ScopeName,':setHorzTime']), 1/getpvonline([ScopeName,':setHorzTime']));
fprintf('   getHorzTime   = %g sec (%g Hz)\n', getpvonline([ScopeName,':getHorzTime']), 1/getpvonline([ScopeName,':getHorzTime']));

% Sample rate (should also be getpvonline([ScopeName,':HorzRate')/1e6
fprintf('   HorzInterval  = %g sec (%g MHz sample rate)\n', getpvonline([ScopeName,':HorzInterval']), 1/getpvonline([ScopeName,':HorzInterval'])/1e6);


% Look for a coerce problem
if abs(getpvonline([ScopeName,':getHorzTime'])-ztec.Device.Setup.setHorzTime) > 1e10
    fprintf('   Coerce warning:\n');
    fprintf('   getHorzTime   = %g sec (%g Hz)\n', getpvonline([ScopeName,':getHorzTime']), 1/getpvonline([ScopeName,':getHorzTime']));
end

% Change ztec structure to what is really being used
ztec.Device.Setup.setHorzPoints = getpvonline([ScopeName,':getHorzPoints']);
ztec.Device.Setup.setHorzTime   = getpvonline([ScopeName,':getHorzTime']);   % HorzTime can differ be small amounts
ztec.Device.Setup.setHorzOffset = getpvonline([ScopeName,':getHorzOffset']);

% Should check if more sets are correct???

% getpvonline([ScopeName,':getInp1Range']);
% getpvonline([ScopeName,':getInp1Offset']);
% getpvonline([ScopeName,':getInp2Range']);
% getpvonline([ScopeName,':getInp2Offset']);
% getpvonline([ScopeName,':OpInitiateState'],'char')
