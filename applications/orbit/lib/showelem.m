function showelem
%response to the buttondownfcn for elements in the display bar

ElementIcons=getappdata(0,'ElementIcons');

index=get(gcbo,'Userdata');           %userdata holds index of element in THERING
                                      %userdata loaded in function elementiconpatch
AO=getao;


    NameBoxWidth = 70;
    NameBoxHeight = 14;

    EditBoxWidth = 60;
    EditBoxWidth2 = 40;
    EditBoxHeight = 14;

    SpaceX =20;
    SpaceY = 15;
   
p = findobj(0,'tag','hobj');
if ~isempty(p) delete(p); end
    
h0 = figure('Color', [0.8 0.8 0.8], ...
	    'PaperPosition',[18 180 576 432], 'Units','points', 'Position',[30 30 600 200], ...
	    'Tag', 'hobj',... 
        'ToolBar','none','MenuBar','none','NumberTitle','off','Visible','off',...
        'Name','Element Display');
    
%Get Names for THERING(index) and ElementIcon(index) combined
global THERING
Element=structmerge(ElementIcons{index},THERING{index});

%get number of fields for Element, eliminate coordinates, Roll
Names = fieldnames(Element);
names=cell2struct(Names',Names',2);
names=rmfield(names,{'xpts'; 'ypts'; 'color'; 'elementimage';});
if isfield(names,'R1') | isfield(names,'R2') names=rmfield(names,{'R1'; 'R2';}); end  %remove rotation matrices for now
Names=struct2cell(names);
NumFields = length(Names);  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the following block of code is taken verbatim from intelem
% 9/13/03 changed THERING{index} to Element
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Handles = cell(1,NumFields);
TextHandles = zeros(1,NumFields);
    
    % Create editable text controls for each field
    % If a field is an MxN  matrix (Multipole coefficients) 
    % create MxN text controls for each element of the matrix

    LastPos = 0;

    for i = 1:NumFields
   
        FieldData = getfield(Element,Names{NumFields-i+1});
        [M,N] = size(FieldData);
        Name = Names{NumFields-i+1};
        UD.FieldName = Name;
    
        LastPos = LastPos + SpaceY  + (M-1)*EditBoxHeight;
   
        % One Static Text control per field 
        TextHandles(i) = uicontrol('Parent',h0, 'Units','points', ...
	        'BackgroundColor',[0.8 0.8 0.8], ...
            'FontSize',8, ...
	        'FontSize',8 , ...
	        'ListboxTop',0, ...
	        'Position',[SpaceX  LastPos  NameBoxWidth  NameBoxHeight], ...
            'String',Name, ...
            'HorizontalAlignment','right', ...
	        'Style','text', ...
            'Tag','StaticText1');

	
	    if isnumeric(FieldData)
            for m = 1:M
                UD.M = m;
                for n = 1:N
                    UD.N = n;
                    EditHandles{i}(m,n)=uicontrol('Parent',h0, 'Units','points', ...
            	        'BackgroundColor',[1 1 1], 'FontSize',8 , ...
     			        'Position',[2*SpaceX+NameBoxWidth+(n-1)*EditBoxWidth2 ,  LastPos-(m-1)*EditBoxHeight,  EditBoxWidth2, EditBoxHeight], ...
                        'Style','edit', ...
            	        'String',sprintf('%.6f',FieldData(m,n)),'HorizontalAlignment','right', ...      
                        'UserData',UD,...
                        'Callback','intelem sync', ...
                        'Tag','EditText1');
                end
   	        end  
        elseif ischar(FieldData)
            UD.M = 1;
            UD.N = 1;
            EditHandles{i}=uicontrol('Parent',h0,'Units','points', ...
                'BackgroundColor',[1 1 1],'FontSize',8 , ...
                'Position',[2*SpaceX+NameBoxWidth LastPos  100 EditBoxHeight],'Style','edit', ...
                'String',FieldData, 'HorizontalAlignment','left', ...
                'UserData',UD, ...
                'Callback','intelem sync', ...
      	        'Tag','EditText1');
        end     
    end

    set(h0,'HandleVisibility','on','Visible','on');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end block of code from intelem
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H = get(h0,'Position');
H(4) = LastPos+40;
set(h0,'Position',H);

%make pushbutton to show elememt image
uicontrol('Style', 'Pushbutton', 'Units', 'Normalized', 'Position', [.8 .5 .1 .1],...
'Tag', 'showimage', 'String', 'Show Image', 'Callback', 'showimage(''showimage'')','Userdata',index);

%axes for jpeg image display
ha = axes('Units','pixels',...
    'Color', [1 1 1], ...   
    'Box','on',...
    'Visible','Off',...
    'Position',[600 10 100 100],...
    'XTickLabelMode','Manual',...
    'XTickLabel',[],...
    'YTickLabelMode','Manual',...
    'YTickLabel',[]);