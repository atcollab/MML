function makeurl(h,url,varargin)
%MAKEURL Make a URL from a uicontrol of style text.
%   MAKEURL(h,url) adjusts the properties of the text style UICONTROL 
%   object to make it act like a typical URL hyperlink.  The hyperlink's
%   target is given by the string url.
%
%   MAKEURL(...,'ForeGroundColor',C1,'ClickedColor',C2) will set the
%   unclicked text color to C1 and the clicked text color to C2 where
%   C1 and C2 are valid colorspecs.  The default values are C1 = 'b'
%   and C2 = 'm'.
%   
%   Ex. 
%
%      h = uicontrol('style','text','string','MathWorks');
%      makeurl(h,'http://www.mathworks.com');

% Jordan Rosenthal, jr@ll.mit.edu
% Initial Version, 08-Dec-1999
%            Rev., 18-Dec-2001 Added -browser switch and changed email contact.

%----------------------------------------------------------------------------
% Default Parameters
%----------------------------------------------------------------------------
FOREGROUNDCOLOR = 'b';
CLICKEDCOLOR    = 'm';

%----------------------------------------------------------------------------
% Parse Inputs
%----------------------------------------------------------------------------
if nargin < 2, error('Not enough input arguments.'); end
if ~strcmp(get(h,'style'),'text'), error('The UICONTROL h must be of style text.'); end
if exist('varargin','var')
   L = length(varargin);
   if rem(L,2) ~= 0, error('Parameters/Values must come in pairs.'); end
   for i = 1:2:L
      switch lower(varargin{i}(1))
      case 'f', FOREGROUNDCOLOR = varargin{i+1};
      case 'c',    CLICKEDCOLOR = varargin{i+1};
      end
   end
end
%---  Add quotes around the color if given as a character  ---%
if ischar(CLICKEDCOLOR), CLICKEDCOLOR = ['''' CLICKEDCOLOR '''']; end

%----------------------------------------------------------------------------
% Swicth units and get the pertinent parameters
%----------------------------------------------------------------------------
OldUnits = get(h,'Units'); set(h,'Units','pixels');
Ext   = get(h,'Extent');
Pos   = get(h,'Pos');
Horiz = get(h,'HorizontalAlignment');

%----------------------------------------------------------------------------
% Add an underline by creating a 1 pixel high frame
%----------------------------------------------------------------------------
Bottom = Pos(2) + Pos(4) - Ext(4) + 2;
Width  = Ext(3);
Height = 1;
switch lower(Horiz)
case 'left'
   Left = Pos(1);
case 'center'
   Left = Pos(1) + Pos(3)/2 - Ext(3)/2;
case 'right'
   Left = Pos(1) + Pos(3) - Ext(3);
end
fPos = [Left Bottom Width Height];
hFrame = uicontrol('style','Frame','pos',fPos,'ForegroundColor',FOREGROUNDCOLOR);
setappdata(h,'hFrame',hFrame);

%----------------------------------------------------------------------------
% Setup callback
%----------------------------------------------------------------------------
ButtonDownFcn =  ...
   ['set([gcbo getappdata(gcbo,''hFrame'')],''ForeGroundColor'', ' CLICKEDCOLOR ');'];
ButtonDownFcn = [ ButtonDownFcn 'web(''' url ''',''-browser'');' ];

%----------------------------------------------------------------------------
% Adjust the properties and restore units
%----------------------------------------------------------------------------
set(h,'ForegroundColor',FOREGROUNDCOLOR, ...
   'ButtonDownFcn',ButtonDownFcn,'Enable','Inactive','Units',OldUnits);