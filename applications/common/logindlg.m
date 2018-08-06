function [varargout]=logindlg(Title, LoginName)
%LOGINDLG - Get the login name and password from a dialog box
%  [Login, Password] = logindlg(Title)
%
%  Author: Jeremy Smith
%  Date: September 24, 2005
%  Version: 1.1
%  Tested on: Matlab 7.0.4.365 (R14) Service Pack 2
%  Description: custom login dialog because Matlab doesn't have an option
%              for characters in an edit field to be replaced by asterixes
%              (password security)


% Changelist:
%   1.1: -Added positioning code so it'll display in the center of the screen
%        -If only one output is specified the password will be returned
%            instead of the login as in Version 1.0
%        -Escape will not only close the dialog if neither edit box is active
%        -When the dialog appears the first edit box will be active
%        -Added a few more comments
%        -Removed the clc, it was left in by mistake in Version 1.0
%
%   Portmann - added a default input for login name


% Input Error Check
if nargin < 1 || nargin == 1 && ischar(Title) == 0
    Title = 'Login';
end

if nargin < 2
    LoginName = '';
end

% Output Error Check
if nargout > 2
    error('Too many output arguments.')
end

% Get Properties
Color = get(0,'DefaultUicontrolBackgroundcolor');

% Determine the size and position of the login interface
set(0,'Units','characters')
Screen = get(0,'screensize');
Position = [Screen(3)/2-17.5 Screen(4)/2-4.75 35 9.5];
set(0,'Units','pixels')

% Create the GUI
gui.main = dialog('HandleVisibility','on',...
    'IntegerHandle','off',...
    'Menubar','none',...
    'NumberTitle','off',...
    'Name','Login',...
    'Tag','logindlg',...
    'Color',Color,...
    'Units','characters',...
    'Userdata','logindlg',...
    'Position',Position);

% Set the title
if ischar(Title) == 1
    set(gui.main,'Name',Title,'Closerequestfcn',{@Cancel,gui.main},'Keypressfcn',{@Escape,gui.main})
end

% Texts
gui.login_text = uicontrol(gui.main,'Style','text','FontSize',8,'HorizontalAlign','left','Units','characters','String','Login','Position',[1 7.65 20 1]);
gui.password_text = uicontrol(gui.main,'Style','text','FontSize',8,'HorizontalAlign','left','Units','characters','String','Password','Position',[1 4.15 20 1]);

% Edits
gui.edit1 = uicontrol(gui.main,'Style','edit','FontSize',8,'HorizontalAlign','left','BackgroundColor','white','Units','characters','String',LoginName,'Position',[1 6.02 33 1.7]);
gui.edit2 = uicontrol(gui.main,'Style','edit','FontSize',8,'HorizontalAlign','left','BackgroundColor','white','Units','characters','String','','Position',[1 2.52 33 1.7],'Callback',{@OK,gui.main},'KeyPressfcn',{@KeyPress_Function},'Userdata','');

% Buttons
gui.OK = uicontrol(gui.main,'Style','push','FontSize',8,'HorizontalAlign','left','Units','characters','String','OK','Position',[12 .2 10 1.7],'Callback',{@OK,gui.main});
gui.Cancel = uicontrol(gui.main,'Style','push','FontSize',8,'HorizontalAlign','left','Units','characters','String','Cancel','Position',[23 .2 10 1.7],'Callback',{@Cancel,gui.main});

setappdata(0,'logindlg',gui) % Save handle data
setappdata(gui.main,'Check',0) % Error check setup. If Check remains 0 an empty cell array will be returned

if isempty(LoginName)
    uicontrol(gui.edit1) % Make the first edit box active
else
    uicontrol(gui.edit2) % Make the second edit box active
end

% Pause the GUI and wait for a button to be pressed
uiwait(gui.main)

Check = getappdata(gui.main,'Check'); % Check to see if a button was pressed

% Format output
if Check == 1
    Login = get(gui.edit1,'String');
    Password = get(gui.edit2,'Userdata');
    
    if nargout == 1 % If only one output specified output Password
        varargout(1) = {Login};
    elseif nargout == 2 % If two outputs specified output both Login and Password
        varargout(1) = {Login};
        varargout(2) = {Password};
    end
else % If OK wasn't pressed output nothing
    if nargout == 1
        varargout(1) = {[]};
    elseif nargout == 2
        varargout(1) = {[]};
        varargout(2) = {[]};
    end
end

delete(gui.main) % Close the GUI
setappdata(0,'logindlg',[]) % Erase handles from memory

%% Hide Password
function KeyPress_Function(h,eventdata)
% Function to replace all characters in the password edit box with
% asterixes
password = get(h,'Userdata');
key = get(gcf,'currentkey');
if isempty(strfind(key,'backspace')) == 0
    password = password(1:end-1); % Delete the last character in the password
elseif isempty(strfind(key,'return')) == 0
    % Don't add 'return' to the password
else
    password = [password get(gcf,'currentcharacter')]; % Add the typed character to the password
end
ch = get(gcf,'currentcharacter'); % Get the typed character

SizePass = size(password); % Find the number of asterixes
if SizePass(2) > 0
    asterix(1,1:SizePass(2)) = '*'; % Create a string of asterixes the same size as the password
    set(h,'String',asterix) % Set the text in the password edit box to the asterix string
else
    set(h,'String','')
end

set(h,'Userdata',password) % Store the password in its current state

%% Cancel
function Cancel(h,eventdata,fig)
uiresume(fig)

%% OK
function OK(h,eventdata,fig)
% Set the check and resume
setappdata(fig,'Check',1)
uiresume(fig)

%% Escape
function Escape(h,eventdata,fig)
% Close the login if the escape button is pushed and neither edit box is
% active
key = get(fig,'currentkey');

if isempty(strfind(key,'escape')) == 0 && h == fig
    Cancel([],[],fig)
end