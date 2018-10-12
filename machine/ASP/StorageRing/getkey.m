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
