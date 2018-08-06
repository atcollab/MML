function varargout = rload(action, varargin)
%enter real numbers into field of input structure

switch action
%...GenFig//ExecPar
%...DelFigure
%...getWord//GetElement//num
%=============================================================
case 'GenFig'
%=============================================================
% This function generates the figure which holds
% list of elements for real field selection by the user.
% Only re-draw figure after final OK (DeleteFigure)
name=varargin(1);    name=name{1};
avail=varargin(2);   avail=avail{1};
status=varargin(3);  status=status{1};
value=varargin(4);   value=value{1};
title=varargin(5);   title=title{1};
tag=varargin(6);     tag=tag{1};
tlist=varargin(1:4);   %temporary lists

%test if toggle panel already exists
h= findobj(0,'tag',['rload_' tag]);
if ~isempty(h) 
    delete(h); 
end

newFig = figure('Position',[100 400 900 550],...
		'UserData',tlist,...
		'NumberTitle','off',...
        'tag',['rload_' tag],...
		'Name',['Element Selection: ' title],...
    'MenuBar','none');
		
xpos = 20;   		%initial x and y offsets of the button
ypos = 530;  %330

for ind = 1:length(name)

	ypos = ypos - 20;
	if ypos < 50			%go to new column if full
		ypos = 510;  %310
		xpos = xpos + 180;
	end

        color='r';          %default
        
        if ~isempty(avail)
		if ~isempty(find(avail==ind))
			color = 'y';    %status ok ==> yellow
		end
        end
        
        if ~isempty(status)
		if ~isempty(find(status==ind))
			color = 'g';    %status ok ==> green
		end
        end
        
	uicontrol('Style','frame',...
	'Position',[xpos-1 ypos-1 72 22]);            %name frame
	uicontrol('Style','Text', ...
		'Position',[xpos ypos 70 20], ...
		'ForegroundColor','k', ...
		'BackgroundColor',color, ...
        'FontSize',9,...
		'String',name(ind,:));                   %name

	uicontrol('Style','frame',...
	'Position',[xpos+75-1 ypos-1 72 22]);       %value frames

  uicontrol('Style','Edit', ...                 %Edit boxes
		'Position',[xpos+75 ypos 70 20], ...
		'ForegroundColor','k', ...
		'BackgroundColor',color, ...
        'FontSize',9,...
		'tag',['rl' num2str(ind)],...
		'String',value(ind));
end   %end loop on elements

uicontrol('Style','pushbutton',...
          'Position',[10 10 200 30],...
          'String','Load Values',...
          'Callback','rload(''LoadValues'')',...
          'Tag','rload',...
          'Userdata',tag);                         %Load New Values
      
%%%%%%%%
delta=1.0;
uicontrol('Style','frame',...
          'Position',[250-delta 10-delta 80+2*delta 30+2*delta]);                 %All Values Same Frame

      uicontrol('Style','text',...
          'Position',[250 10 80 30],...
          'String','All Values Same:');           %All Values Same Text
      
uicontrol('Style','edit',...
          'Position',[350 10 50 30],...
          'String','NaN',...
          'Tag','allvalues',...
          'Callback','rload(''AllValues'')');      %All Values Same
%%%%%%%%

uicontrol('Style','pushbutton',...
          'Position',[550 10 60 30],...
          'String','Cancel',...
          'Callback','delete(gcf)');               %Cancel button

%=============================================================
case 'AllValues'                             % *** AllValues ***
%=============================================================
h=findobj(gcf,'tag','allvalues');

%retrieve value
val=get(h,'String');
val=str2num(val);
if isnan(val)
    return
end

%load value into all fields
tlist = get(gcf,'UserData');    
name=tlist{1};
avail=tlist{2};
status=tlist{3};

for ind = 1:length(name)
    if find(ind==avail) & find(ind==status)
	  rh=findobj(gcf,'tag',['rl' num2str(ind)]);
      set(rh,'String',num2str(val));
   end
end




%=============================================================
case 'LoadValues'                             % *** LoadValues ***
%=============================================================
%Callback of the 'LoadValues' button in the GenFig
tlist = get(gcf,'UserData');    
name=tlist{1};
avail=tlist{2};
status=tlist{3};
value=tlist{4};

% for ind = 1:length(name)
% 	  rh=findobj(gcf,'tag',['rl' num2str(ind)]);
%       value(ind)=str2num(get(rh,'String'));
% end   
for ind = 1:length(name)
	  rh=findobj(gcf,'tag',['rl' num2str(ind)]);
      val=str2double(get(rh,'String'));
      
      %only load into value array if 'val' is a valid real number
  if isnan(val) | ~isnumeric(val) | ~length(val)==1
      %flush the bad string out of the edit; replace with current value
      set(rh,'String',value(ind));
      disp(['Warning: Invalid load value entry: ', name(ind,:)]);
      orbgui('LBox',['Warning: Invalid load value entry: ', name(ind,:)]);
  else
      value(ind)=val;
  end
      

end   
tlist=[{tlist{1}} {tlist{2}} {tlist{3}} {value}];
set(gcf,'UserData',tlist);      
hload=findobj(0,'Tag','rload'); %get handle of 'load' button
hload=gco;
tag=get(hload,'Userdata');      %get tag of caller from load button Userdata
h=findobj(0,'Tag',tag);         %get handle of caller
instr=get(h,'Userdata');        %get instruction set from caller
eval(instr);                    %evaluate instruction set

%=============================================================
otherwise
disp('Warning: no CASE found in rload');
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
