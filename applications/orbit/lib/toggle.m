function varargout = toggle(action, varargin)

switch action

%toggle(''GenFig'',names,istatus,iavail,ifit,title,templisttag];
%=============================================================
case 'GenFig'
%=============================================================
% Generates the figure which holds
% Radio buttons for element selection by the user.
% Only re-draw figure after final OK (delParFig)
name=varargin(1);     name=char(name{1});
status=varargin(2);   status=status{1};
avail=varargin(3);    avail=avail{1};
isel=varargin(4);     isel=isel{1};
title=varargin(5);    title=title{1};
tag=varargin(6);      tag=tag{1};
tlist=varargin(1:4);   %temporary lists

%test if toggle panel already exists
h= findobj(0,'tag',['toggle_' tag]);
if ~isempty(h) 
    delete(h); 
end



newFig = figure('Position',[100 400 800 350],...
		'UserData',tlist,...
		'NumberTitle','off',...
        'tag',['toggle_' tag],...
		'Name',['Element Selection: ' title],...
        'MenuBar','none');
		
xpos = 20;   		%initial x and y offsets of the button
ypos = 330;

for ind = 1:length(name)

	ypos = ypos - 20;
	if ypos < 50			%go to new column if full
		ypos = 310;
		xpos = xpos + 120;
	end

    %default no status
            val = 0;        %bad status or not available ==> red
            color = 'r';
            uitype='text';
            uicall=' ';

        if ~isempty(avail)
		  if ~isempty(find(avail==ind))
			val = 0;
			color = 'y';    %is available      ==> yellow
            uitype='radiobutton';
            uicall='toggle(''ToggleElem'')'; 
		  end
        end

        if ~isempty(avail) & ~isempty(isel)
		  if ~isempty(find(avail==ind)) & ...
             ~isempty(find(isel==ind))
			val = 1;
			color = 'g';    %available and on ==> green
            uitype='radiobutton';
            uicall='toggle(''ToggleElem'')';
		  end
        end

		if ~isempty(avail) & ~isempty(status)
          if  isempty(find(status==ind)) | ...
              isempty(find(avail==ind))
          end
        end

	uicontrol('Style','frame',...
	'Position',[xpos-1 ypos-1 72 22]);
	uicontrol('Style',uitype, ...
		'Position',[xpos ypos 70 20], ...
		'BackgroundColor',color, ...
		'String',name(ind,:), ...
		'Value',val,...
		'Callback',uicall,...			
		'tag',['tg' num2str(ind)]);				
end   %end loop on elements

uicontrol('Style','pushbutton',...
          'Position',[10 10 200 30],...
          'String','Load Selection',...
          'Callback','toggle(''LoadSelection'')',...
          'Tag','loadtoggle',...
          'Userdata',tag);                         %Load New Values
uicontrol('Style','pushbutton',...
          'Position',[300 10 80 30],...
          'String','Select All',...
          'Callback','toggle(''SelectAll'')');     %Select All
uicontrol('Style','pushbutton',...
          'Position',[400 10 80 30],...
          'String','Select None',...
          'Callback','toggle(''SelectNone'')');    %Select None
uicontrol('Style','pushbutton',...
          'Position',[500 10 60 30],...
          'String','Cancel',...
          'Callback','delete(gcf)')                %Cancel button
      
%=============================================================
case 'LoadSelection'                   % *** LoadSelection ***
%=============================================================
%Callback of the 'LoadSelection' button in the GenFig
 tlist = get(gcf,'UserData');    
 name=tlist{1};
 status=tlist{2};
 avail=tlist{3};
 isel=tlist{4};
% 
% % for ind = 1:length(name)
% %       if ~isempty(find(status==ind)) 
% % 		  h=findobj(gcf,'tag',['tg' num2str(ind)]);
% %           value(ind)=get(h,'Value');
% %       end
% % end   
% tlist=[tlist{1} tlist{2} tlist{3} isel];
% set(gcf,'UserData',tlist);      
h1=findobj(0,'Tag','loadtoggle');   %get handle of 'load' button
tag=get(h1,'Userdata');         %get tag of calling gui
h1=findobj(0,'Tag',tag);        %get handle of calling gui
instr=get(h1,'Userdata');       %get instruction set from calling gui
eval(instr)      %evaluate instruction set

%=============================================================
case 'ToggleElem'                         % *** ToggleElem ***
%=============================================================
% Callback for each radio button. 
% Toggle the radio color

ind = get(gcbo,'tag');            %tag of radio button
ind = str2num(ind(3:length(ind)));

%plot is unaffected until the 'OK' button is pushed.
tlist = get(gcf,'UserData');    
tindx=tlist{4};
if get(gcbo,'Value') == 1         %radio button true
   set(gcbo,'BackgroundColor','g');
   tindx=sort([tindx ind]);
end
if get(gcbo,'Value') == 0         %radio button false
   set(gcbo,'BackgroundColor','y');
   tindx(find(tindx==ind))=0;     %set element to zero
   tindx=tindx(find(tindx));
 end
   tindx=tindx(find(tindx));

tlist=[{tlist{1}} {tlist{2}} {tlist{3}} {tindx}];
set(gcf,'UserData',tlist);

%=============================================================
case 'SelectAll'                      % *** SelectAll ***
%=============================================================
tlist = get(gcf,'UserData');    
name=tlist{1};
status=tlist{2};
avail=tlist{3};
tindx=[];

for ind = 1:length(name)
      if ~isempty(find(avail==ind)) & ...
         ~isempty(find(status==ind))  %available & status ok
		   h=findobj(gcf,'tag',['tg' num2str(ind)]);
        set(h,'BackGroundColor','g','Value',1);
        tindx(ind)=ind;
      end
end   
tindx=tindx(find(tindx));
tlist=[{tlist{1}} {tlist{2}} {tlist{3}} {tindx}];
set(gcf,'UserData',tlist);

%=============================================================
case 'SelectNone'                      % *** SelectNone ***
%=============================================================
tlist = get(gcf,'UserData');    
name=tlist{1};
status=tlist{2};
avail=tlist{3};
tindx=[];

for ind = 1:length(name)
      if ~isempty(find(avail==ind)) & ...
         ~isempty(find(status==ind)) %available & status ok
		   h=findobj(gcf,'tag',['tg' num2str(ind)]);
        set(h,'BackGroundColor','y','Value',0);
      end
end   
tlist=[{tlist{1}} {tlist{2}} {tlist{3}} {tindx}];
set(gcf,'UserData',tlist);      

%=============================================================
otherwise
disp('Warning: no CASE found in toggle');
disp(action);
end   %	End Switchyard





%********************
function [word,k] = getWord(line, i)
%********************

%getWord reads one 'word' or token at a time from a line of char.

%Input: line is the line being read, i is the pointer to the index
%        within that line.

%Output:word is the token being returned to the main program.
%       k is the returned value of i for the main to keep track of.


word = [];

if ~isempty(line)

while line(i) == ' '
  i = i + 1;
end

while line(i) ~= ' ' 
  word = [word line(i)];
  i = i+1;

  if i > length(line)
	break;
  end
end

end

k = i;



%*************************
function [index,num,k] = getElmnt(line,i)
%*************************

% getElmnt reads the values stored for a specific element in the file
% for use in the array.

% Input: line is the line of text from the file being read.
%        i is the index pointer in that line.

% Output:index and num are data returned to the main program.
%        index is the element index (ex: ibpmx)
%        num is the data for that element (ex: 1.83E-01).

%        k is the value of i returned to the main program 
%        to keep track of things. 

                  
while line(i) == ' '
	i = i + 1;
end

index = [];
while ~(line(i) == ' ') & ~(line(i) == '-')
	index = [index line(i)];
	i = i + 1;
end
index = str2num(index);

if line(i) == ' '
	i = i + 1;
end

num = [];
while line(i) ~= ' '
	num = [num line(i)];
	i = i + 1;

	if i > length(line)
		break;
	end
end
num = sci2num(num);

k = i;



%********************* 
function num = sci2num(str)
%*********************

%Transforms a number from scientific notation to standard form 
%for the program to manipulate.

a = [];

i = 1;
while str(i) ~= 'E'
	a = [a str(i)];
	i = i + 1;
end

a = str2num(a);

sign = str(i + 1);
i = i + 2;

p = [str(i) str(i + 1)];
p = str2num(p);

if sign == '+'
	num = a*(10^p);
else
	num = a*(10^(p * -1));
end   
