function fig = intlat(varargin)
% INTLAT is a Graphical User Interface that allows to 
% interactively select an element in THERING and  view/modify 
% its properties

global THERING FAMLIST


if nargin == 0 	% first call - create GUI
   
   DIRECTION = -1;	% -1: clockwise  +1 counter clockwise
   STARTANGLE = pi; 
   
   NE = length(THERING);
   x2d = zeros(1,NE+1);
   y2d = zeros(1,NE+1);
   a2d = zeros(1,NE+1); % angle of orbit in radians 
   a2d(1) = STARTANGLE;
   for en = 1:NE-1
      if isfield(THERING{en},'BendingAngle') 
         ba = DIRECTION*THERING{en}.BendingAngle; % bending angle in radians
      else
         ba = 0;
      end
      if ba == 0
         L1 = THERING{en}.Length;
         L2 = 0;
      else
         L1 = THERING{en}.Length*sin(ba)/ba;
         L2 = THERING{en}.Length*(1-cos(ba))/ba;   
      end
      
      x2d(en+1) = x2d(en) + L1*cos(a2d(en)) - L2*sin(a2d(en));
      y2d(en+1) = y2d(en) + L1*sin(a2d(en)) + L2*cos(a2d(en));
      a2d(en+1)=a2d(en) + ba;
   end
   x2d(NE+1) = x2d(1);
   y2d(NE+1) = y2d(1);
   a2d(NE+1) = a2d(1);
   
   X0 = (max(x2d)+min(x2d))/2;
   Y0 = (max(y2d)+min(y2d))/2;	
   x2d = x2d - X0;
   y2d = y2d - Y0;
   
   xscale=max(x2d)-min(x2d);
   yscale=max(y2d)-min(y2d);
   
   
   % Variables that control GUI appearence
   AxesWidth = 300; % screen points
   AxesHeight = AxesWidth*yscale/xscale;
   ListBoxWidth = 140;
   ListBoxHeight = 100;
   OX = 20; 
   OY = 20;
   
   SpaceX = 20;
   SpaceY = 5;
   
   
   
   ButtonWidth = 60;
   ButtonHeight = 20;
   
   
   
   h0 = figure('Color',[0.8 0.8 0.8], ...
      'PaperPosition',[18 180 576 432], ...
      'PaperUnits','points', ...
      'Units','points', ...
      'Position',[50 50 660 450], ...
      'Tag','Fig1', ...
      'ToolBar','none');
   h1 = axes('Parent',h0, ...
      'Units','points', ...
      'CameraUpVector',[0 1 0], ...
      'Color',[1 1 1], ...
      'Position',[OX OY AxesWidth AxesHeight], ...
      'Tag','Axes1', ...
      'DataAspectRatioMode','manual', ... 
      'DataAspectRatio',[1 1 1], ...
      'PlotBoxAspectRatioMode','manual', ... 	
      'PlotBoxAspectRatio',[xscale yscale 1], ...
      'XColor',[0 0 0], ...
      'YColor',[0 0 0], ...
      'ZColor',[0 0 0]);
   a1 = h1;
   
   
   % get the names of all families in the FAMLIST	
   
   fams2display = cell(size(FAMLIST));
   for i=1:length(fams2display)
      fams2display{i} = FAMLIST{i}.FamName;
   end
   
   famlist = uicontrol('Parent',h0, ...
      'Units','points', ...
      'BackgroundColor',[1 1 1], ...
      'Max',3, ...
      'Position',[OX OY+AxesHeight+SpaceY ListBoxWidth ListBoxHeight], ...
      'String',fams2display, ...
      'Style','listbox', ...
      'Tag','Listbox1', ...
      'UserData','[ ]', ...
      'Value',[1 2]);
   
   
   % get the list of all possible field names of elements in THERING
   
   fields2display = fieldnames(THERING{1});
   nnew = length(fields2display);
   for i = 2:length(THERING)
      
      newones = fieldnames(THERING{i}); 	% Get list of fields in the next element
      for j = 1:length(newones);	% Check if there are any new names not includes in fields2display
         isnew = strcmp(newones{j}, fields2display)';   
         if ~sum(isnew)
            nnew = nnew+1;
            fields2display{nnew} = newones{j};
         end
      end
   end
   
   fieldlist = uicontrol('Parent',h0, ...
      'Units','points', ...
      'BackgroundColor',[1 1 1], ...
      'Max',3, ...
      'Position',[OX+ListBoxWidth+SpaceX OY+AxesHeight+SpaceY ListBoxWidth ListBoxHeight], ...
      'String',fields2display, ...
      'Style','listbox', ...
      'Tag','ListBox2', ...
      'UserData','[ ]', ...
      'Value',[1 2 3]);
   
   % Draw buttons
   
   b1 = uicontrol('Parent',h0, ...
      'Units','points', ...
      'String','Zoom',...
      'callback','zoom',...
      'Position',[OX+AxesWidth+SpaceX OY ButtonWidth ButtonHeight], ...
      'Tag','Pushbutton1');
   
   b2 = uicontrol('Parent',h0, ...
      'Units','points', ...
      'Position',[OX+AxesWidth+SpaceX+ButtonWidth OY ButtonWidth ButtonHeight], ...
      'String','2-D', ...
      'Tag','Pushbutton2');
   
   b3 = uicontrol('Parent',h0, ...
      'Units','points', ...
      'Position',[OX+AxesWidth+SpaceX+2*ButtonWidth   OY ButtonWidth ButtonHeight], ...
      'String','Save',...
      'Tag','Pushbutton3');
   
   b4 = uicontrol('Parent',h0, ...
      'Units','points', ...
      'Callback','close(gcbf);',...
      'Position',[OX+AxesWidth+SpaceX+3*ButtonWidth   OY ButtonWidth ButtonHeight], ...
      'String','Exit',...
      'Tag','Pushbutton4');
   
   
   
   
   
   
   
   %Draw orbit and elements
   spos = findspos(THERING,1:NE);
   line(x2d,y2d); 
   grid on
   handles2elements=zeros(1,NE);         	
   xcorners = [-1 -1  1  1];
   ycorners = [ 1  1 -1 -1];
   
   BPMWIDTH=.15;
   QUADWIDTH = 0.5;
   SEXTWIDTH=0.4;
   BENDWIDTH =0.8;
   
   for i = 1:NE
      if strncmp(THERING{i}.FamName,'QF',2)
         vertx = [ x2d(i), x2d(i+1), x2d(i+1), x2d(i)] + QUADWIDTH*xcorners*sin(a2d(i));
         verty = [y2d(i), y2d(i+1), y2d(i+1), y2d(i)] + QUADWIDTH*ycorners*cos(a2d(i));
         handles2elements(i)=patch(vertx,verty,'r');
         
      elseif strncmp(THERING{i}.FamName,'Q',1)
         vertx = [ x2d(i), x2d(i+1), x2d(i+1), x2d(i)] + QUADWIDTH*xcorners*sin(a2d(i));
         verty = [y2d(i), y2d(i+1), y2d(i+1), y2d(i)] +  QUADWIDTH*ycorners*cos(a2d(i));
         handles2elements(i)=patch(vertx,verty,'blue');
      end
      
      
      if strncmp(THERING{i}.FamName,'CA',2)
         vertx = [ x2d(i), x2d(i+1), x2d(i+1), x2d(i)] + QUADWIDTH*xcorners*sin(a2d(i));
         verty = [y2d(i), y2d(i+1), y2d(i+1), y2d(i)] + QUADWIDTH*ycorners*cos(a2d(i));
         handles2elements(i)=patch(vertx,verty,'g');
      end   
      
      if strncmp(THERING{i}.FamName,'SF',2)
         vertx = [ x2d(i), x2d(i+1), x2d(i+1), x2d(i)] +   SEXTWIDTH*xcorners*sin(a2d(i));
         verty = [y2d(i), y2d(i+1), y2d(i+1), y2d(i)] +   SEXTWIDTH*ycorners*cos(a2d(i));
         handles2elements(i)=patch(vertx,verty,'m');
      end
      if strncmp(THERING{i}.FamName,'SD',2)
         vertx = [ x2d(i), x2d(i+1), x2d(i+1), x2d(i)] +   SEXTWIDTH*xcorners*sin(a2d(i));
         verty = [y2d(i), y2d(i+1), y2d(i+1), y2d(i)] +   SEXTWIDTH*ycorners*cos(a2d(i));
         handles2elements(i)=patch(vertx,verty,'g');
      end
      
      if strncmp(THERING{i}.FamName,'BPM',3)
         vertx = [x2d(i)-BPMWIDTH, x2d(i)         , x2d(i)+BPMWIDTH, x2d(i)         ] + BPMWIDTH*[1-cos(a2d(i))      -sin(a2d(i)) -1*(1-cos(a2d(i))) sin(a2d(i))];
         verty = [y2d(i),          y2d(i)+BPMWIDTH, y2d(i),          y2d(i)-BPMWIDTH] + BPMWIDTH*[ -sin(a2d(i)) -1*(1-cos(a2d(i)))      sin(a2d(i)) 1-cos(a2d(i))];
         handles2elements(i)=patch(vertx,verty,'k');
         
      elseif strncmp(THERING{i}.FamName,'B',1)
         vertx = [x2d(i), x2d(i+1), x2d(i+1), x2d(i)] + BENDWIDTH*xcorners*sin((a2d(i)+a2d(i+1))/2);
         verty = [y2d(i), y2d(i+1), y2d(i+1), y2d(i)] + BENDWIDTH*ycorners*cos((a2d(i)+a2d(i+1))/2);
         handles2elements(i)=patch(vertx,verty,'y');
      end
   end
   
   
   
   ToDisplay = {'FamName' 'Length' 'K'};
   
   for i = 1:NE
      if	handles2elements(i)~=0
         h = handles2elements(i);
         set(h,'UserData',{i spos(i) ToDisplay});
         set(h,'ButtonDownFcn','intlat getelem' )
      end
   end
   
   set(h0,'HandleVisibility','Callback');
   set(h0,'HandleVisibility','on');   % major zoom error in matlab
   
   
elseif nargin>1
   error('To many input arguments');
   
else   % 1 string argument - recursive callback section
   command = varargin{1};
   switch lower(command)
   case 'elemdisplay'
      EUD = (get(gcbo,'UserData'));
      intelem(EUD{1},EUD{3});
   case 'putelem'  
      
      
   case 'getelem'
      
      
      
      EUD = (get(gcbo,'UserData'));
      index = EUD{1};	% Get position index of the element that requested 'getelem' 
      
      NameBoxWidth = 70;
      NameBoxHeight = 14;
      EditBoxWidth = 100*1.2;
      EditBoxWidth2 = 40;
      EditBoxHeight = 14*1.2;
      SpaceX =20;
      SpaceY = 18;
      DOX = 320;
      DOY = 50;
      
      LastPos = 0;
      
      FieldsListHandle = findobj(gcbf,'Tag','ListBox2');
      AllFields = get(FieldsListHandle,'String');
      Selected = get(FieldsListHandle,'Value');
      [SelectedFields{1:length(Selected)}]= deal(AllFields{Selected});
      LSF = length(SelectedFields);
      Fields2Display = {};
      NumMatch = 0;
      for i = 1:LSF
         if isfield(THERING{index}, SelectedFields{i})
            NumMatch = NumMatch+1;
            Fields2Display{NumMatch} = SelectedFields{i};
         end
      end
      
      % Clear display of the previousl element data
      % before displaying the newly requested element information
      get(gcbf,'UserData');
      delete(get(gcbf,'UserData'));
      
      TextHandles = zeros(1,NumMatch);        
      NumEditHandles = 0;
      EditHandles = 0;
      
      for i = 1:NumMatch
         
         FieldData = getfield(THERING{index},Fields2Display{NumMatch-i+1});
         [M,N] = size(FieldData);
         LastPos = LastPos + SpaceY  + (M-1)*EditBoxHeight;
         
         
         % One Static Text control per field 
         TextHandles(i) = uicontrol('Parent',gcbf, ...
            'Units','points', ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'FontSize',8, ...
            'FontSize',8 , ...
            'ListboxTop',0, ...
            'Position',[DOX  DOY+LastPos  NameBoxWidth  NameBoxHeight], ...
            'String',Fields2Display{NumMatch-i+1}, ...
            'HorizontalAlignment','right', ...
            'Style','text', ...
            'Tag','StaticText1');
         
         % Create editable text controls
         localtestvar  = 1;
         if isnumeric(FieldData)
            for m = 1:M
               for n = 1:N
                  NumEditHandles = NumEditHandles+1;
                  EditHandles(NumEditHandles) = uicontrol('Parent',gcbf, ...
                     'Units','points', ...
                     'BackgroundColor',[1 1 1], ...
                     'FontSize',8, ...
                     'Position',[DOX+NameBoxWidth+SpaceX+(n-1)*EditBoxWidth2 , ...
                                 DOY+LastPos-(m-1)*EditBoxHeight,  EditBoxWidth2, EditBoxHeight], ...
                     'String',sprintf('%f',FieldData(m,n)), ...
                     'UserData',{index Fields2Display{NumMatch-i+1} m n}, ...
                     'Callback','SynchWithTHERING', ...
                     'HorizontalAlignment','right', ...
                     'Style','edit', ...
                     'Tag','editbox');    
                  
                  
                  
               end
            end
         elseif ischar(FieldData)
            NumEditHandles = NumEditHandles+1;
            EditHandles(NumEditHandles) = uicontrol('Parent',gcbf, ...
               'Units','points', ...
               'BackgroundColor',[1 1 1], ...
               'FontSize',8, ...
               'Position',[DOX+NameBoxWidth+SpaceX  DOY+LastPos  EditBoxWidth  EditBoxHeight], ...
               'String',FieldData, ...
               'UserData',{index Fields2Display{NumMatch-i+1} 1 1}, ...
               'Callback','SynchWithTHERING', ...
               'HorizontalAlignment','left', ...
               'Style','edit', ...
               'Tag','editbox');    
         end              
      end
      % Save in handles to all objects that need to be replaced
      % with another element or a different set of fields 
      % Store in the UserData field of the figure object
      set(gcbf,'UserData',[ TextHandles EditHandles] );
   end   
end


if nargout > 0, fig = h0; end

