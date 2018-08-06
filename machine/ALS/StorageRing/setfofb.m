function ErrorFlag = setfofb(Command)
%SETFOFB - Set the fast orbit feedback on or off
%
%  ErrorFlag = setfofb(Command)
%
%  INPUTS
%  1. Command - On or true   -> Turn FOFB On
%               Off or false -> Turn FOFB Off
%               
%  OUTPUTS
%  1. ErrorFlag
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fast orbit feedback control %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if nargin == 0
    Command = '';
end


ErrorFlag = 0;


% String inputs
if ischar(Command)
    if strcmpi(Command, 'On')
        Command = 1;
    elseif strcmpi(Command, 'Off')
        Command = 0;
    else
        ErrorFlag = 1;
        fprintf('   Command unknown for setfofb.\n');
        return;
    end
end


if Command

    % Turn FOFB On
    setpv('SR01____FFBON__BC00',2);
    pause(2);
    
    setpv('SR01____FFBON__BC00',1);
    pause(2);
    
    % Check on state
    FOFBOnStatus = [
        getam('SR01____FFBON__BM00') getam('SR02____FFBON__BM00') getam('SR03____FFBON__BM00')...
        getam('SR04____FFBON__BM00') getam('SR05____FFBON__BM00') getam('SR06____FFBON__BM00')...
        getam('SR07____FFBON__BM00') getam('SR08____FFBON__BM00') getam('SR09____FFBON__BM00')...
        getam('SR10____FFBON__BM00') getam('SR11____FFBON__BM00') getam('SR12____FFBON__BM00')];
    
    if any(FOFBOnStatus==0) | any(FOFBOnStatus==2)
        % Failure: Open FOFB loop
        setpv('SR01____FFBON__BC00', 2);
        ErrorFlag = 1;

        disp('************************************************************************************************************');
        disp('** Problem turning on Fast Orbit Feedback system...                                                       **');
        disp('** Check status of ffbsecXX crates - but remember that a crate reboot will turn off Quads in that sector! **');
        disp('** Suggest disabling the "Fast Orbit Correction" checkbox and starting Orbit Feedback again.              **');
        disp('************************************************************************************************************');
    else
        fprintf('   Starting Fast Orbit Feedback at %.0f Hz.\n', getam('SR01____FFBFREQAM00'));
    end

else
    
    % Turn FOFB Off
    setpv('SR01____FFBON__BC00', 2);
    fprintf('   Stopping Fast Orbit Feedback.\n');

end

