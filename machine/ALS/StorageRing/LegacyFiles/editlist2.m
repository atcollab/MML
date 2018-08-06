function newList = editlist2(List, ListName, CheckList)
% newList = editlist2(List)
% newList = editlist2(List, InfoString)
% newList = editlist2(List, InfoString, CheckList)
% newList = editlist2(FamilyName)
%
% Allows one to easily edit a element or device list 
% Inputs:  List       = list to edit
%          InfoString = informational string {optional}
%          CheckList  = 0 - don't check, else check
%          FamilyName = if input 1 is a family name (string), then the 
%                       the family list will be used.
%
% Note:  Closing the window will result in no change to the list


if nargin < 1 
   error('At least 1 input is required.')
end

if nargin < 2
   ListName = '';
end

if ischar(List)
   newList = editlist(getlist(List),List);
   return
end

if nargin < 3
   CheckList = ones(max(size(List)),1);
end
if ~ischar(ListName)
   CheckList = ListName;   
   ListName = '';
end

if length(CheckList) ~= max(size(List))
   error('List and CheckList must have the same max(size).');
end


if isunix
   ScaleFactor = 8;
   ButtonHeight  = 20;
else
   ScaleFactor = 7;
   ButtonHeight  = 16;
end


if size(List,2) == 2
   % Column vector
   RowVectorFlag = 0;
   ButtonWidth = round(ScaleFactor*length(sprintf('%s(%d,%d)', ListName, max(List)))+10);
elseif size(List,1) == 1
   % Row vector
   List = List';
   RowVectorFlag = 1;
   ButtonWidth = round(ScaleFactor*length(sprintf('%s(%d,%d)', ListName, max(List)))+10);
elseif size(List,2) == 1
   % Column vector
   RowVectorFlag = 0;
   ButtonWidth = round(ScaleFactor*length(sprintf('%s(%d,%d)', ListName, max(List)))+10);
elseif size(List,2) > 2
   % More than 2 columns is a problem
   error('Input list must be 1 or 2 columns.')
end
if ButtonWidth < 75
   ButtonWidth = 75;
end


n = size(List,1);
col = ceil(n/40);
row = ceil(n/col);


FigWidth = col*ButtonWidth + (col-1)*3 + 6;
FigHeight  = 3+(row+1)*ButtonHeight;


% Change figure position
set(0,'Units','pixels');
p=get(0,'screensize');

h0 = figure( ...
   'Color',[0.8 0.8 0.8], ...
   'HandleVisibility','On', ...
   'Interruptible', 'on', ...
   'MenuBar','none', ...
   'Name',['Edit ', ListName, ' List'], ...
   'NumberTitle','Off', ...
   'Units','pixels', ...   
   'Position',[30 p(4)-FigHeight-40 FigWidth FigHeight], ...
   'Resize','on', ...
   'Userdata', [], ...
   'Tag','EditListFigure');

k = 1;
for j = 1:col
   for i = 1:row
      
      if size(List,2) == 2
         liststring = sprintf('%s(%d,%d)', ListName, List(k,1), List(k,2));
      else
         liststring = sprintf('%s(%d)', ListName, List(k,1));
      end
      
      if CheckList(k)
         EnableFlag = 1;
      else
         EnableFlag = 0;
      end
      
      h(k) = uicontrol('Parent',h0, ...
         'Callback','', ...
         'Enable','On', ...
         'FontName', 'MS Sans Serif', ...
         'FontSize', [8], ...
         'FontUnits', 'points', ...
         'Interruptible','Off', ...
         'Position',[6+(j-1)*(ButtonWidth+3) 3+(row-i+1)*ButtonHeight ButtonWidth-6 ButtonHeight], ...
         'Style','radio', ...
         'String',liststring, ...
         'Value',EnableFlag, ...
         'Userdata',List(k,:), ...
         'Tag','Radio1');
      k = k + 1;
      if k > n
         break
      end    
   end
end

%#function editlistcallback

h1 = uicontrol(...
   'Parent',h0, ...
   'Callback','editlistcallback',...
   'Enable','On', ...
   'Interruptible','Off', ...
   'Position',[3 3+0*ButtonHeight FigWidth-6 ButtonHeight], ...
   'String','Change List', ...
   'userdata', h, ...
   'Tag','EditListClose');


waitfor(gcf,'userdata');
newList=get(gco,'userdata');

if gcf == h0
   close(h0);
else
   % If the figure is closed (not changed) return the old list
   i = find(CheckList);
   newList = List(i,:);
end

if RowVectorFlag
   newList = newList';
end










