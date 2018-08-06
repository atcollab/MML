function Output1 = addmenustruct(InputStruct, h, Command, LabelString, ParentLabelString)
%ADDMENUSTRUCT - Adds a menu bar to view and edit a structure
%  addmenustruct(handle)

%  Written by Greg Portmann

Output1 = [];

if nargin < 1
    error('Structure input required');
end
if nargin < 2
    h = gcf;
end
if nargin < 3
    Command = 'Build';
end


switch lower(Command)
    case 'build'
        
        if nargin < 4
            LabelString = inputname(1);
        end
        if nargin < 5
            ParentLabelString = 'Edit';
        end
        
        if strcmpi(get(h,'Type'), 'figure')
            h_childen = get(gcf,'children');
            EditMenuFlag = 0;
            for i = 1:length(h_childen)
                if strcmpi(get(h_childen,'label'), ParentLabelString)
                    EditMenuFlag = 1;
                    h = h_childen(i);
                    break;
                end
            end
            if ~EditMenuFlag
                % Make an edit menu
                h = uimenu(h, 'Label', ParentLabelString, 'Callback','');
            end
            hmenu = uimenu(h, 'Label', LabelString, 'Callback','');
        elseif strcmpi(get(h,'Type'), 'uimenu')
            if isempty(findstr(get(h, 'Label'), 'Middle Layer'))
                hmenu = uimenu(h, 'Label', LabelString, 'Callback','');    
            else
                hmenu = h;
            end
        else
            hmenu = h;
        end
        
        Output1 = hmenu;
        
        DataStructure0 = getad;
        if isempty(DataStructure0)
            error('Middle layer initialization needed');
        end
        
        
        % Build middle menu tree
        DataStructFieldName1 = fieldnames(DataStructure0);
        for i = 1:length(DataStructFieldName1)   
            DataStructure1 = DataStructure0.(DataStructFieldName1{i});
            if isstruct(DataStructure1)
                hmenu1 = uimenu(hmenu, 'Label',DataStructFieldName1{i}, 'Callback','');       
                DataStructFieldName2 = fieldnames(DataStructure1);
                for j = 1:length(DataStructFieldName2)
                    DataStructure2 = DataStructure1.(DataStructFieldName2{j});
                    if isstruct(DataStructure2)
                        hmenu2 = uimenu(hmenu1, 'Label',DataStructFieldName2{j}, 'Callback','');       
                        DataStructFieldName3 = fieldnames(DataStructure2);
                        for k = 1:length(DataStructFieldName3)
                            DataStructure3 = DataStructure2.(DataStructFieldName3{k});
                            if isstruct(DataStructure3)
                                hmenu3 = uimenu(hmenu2, 'Label',DataStructFieldName3{k}, 'Callback','');
                                DataStructFieldName4 = fieldnames(DataStructure3);
                                for l = 1:length(DataStructFieldName4)
                                    hmenu4 = uimenu(hmenu3, 'Label', DataStructFieldName4{l});
                                    set(hmenu4,'UserData', {DataStructure3.(DataStructFieldName4{l}) , DataStructFieldName1{l}, DataStructFieldName2{k}, DataStructFieldName3{k}, DataStructFieldName4{i}});      
                                    set(hmenu4,'Callback', 'addmenustruct(gcbo,''Action'')');
                                end
                            else
                                hmenu3 = uimenu(hmenu2, 'Label',DataStructFieldName3{k});
                                set(hmenu3,'UserData', {DataStructure3, DataStructFieldName1{i}, DataStructFieldName2{j}, DataStructFieldName3{k}});      
                                set(hmenu3,'Callback', 'addmenustruct(gcbo,''Action'')');
                            end
                        end
                    else
                        hmenu2 = uimenu(hmenu1, 'Label',DataStructFieldName2{j});
                        set(hmenu2,'UserData', {DataStructure2, DataStructFieldName1{i}, DataStructFieldName2{j}});      
                        set(hmenu2,'Callback', 'addmenustruct(gcbo,''Action'')');
                    end
                end
            else
                hmenu1 = uimenu(hmenu, 'Label', DataStructFieldName1{i});                   
                set(hmenu1,'UserData', {DataStructure1, DataStructFieldName1{i}});      
                set(hmenu1,'Callback', 'addmenustruct(gcbo,''Action'')');
            end
        end
        
    case 'action'
        
        Data = get(h, 'UserData');
        %Label = get(h, 'Label');
        TitleString = sprintf('%s ',Data{2:end});
        AddOpts.Resize='on';
        AddOpts.WindowStyle='normal';
        AddOpts.Interpreter='tex';

        if isnumeric(Data{1})
            answer = inputdlg({sprintf('Change %s',TitleString)}, 'Edit Middle Layer Parameter', size(Data{1},1), {num2str(Data{1})}, AddOpts);
            if isempty(answer)
                return
            end
            Data{1} = str2num(answer{1});
            set(h, 'UserData', Data);
            %setfamilydata(Data{1:end});
        elseif strcmpi(Data{2},'Directory')
            answer = uigetdir(Data{1}, sprintf('Change directory location for %s', Data{3}));
            if answer == 0
                return
            end
            Data{1} = answer;
            set(h, 'UserData', Data);
            %setfamilydata(Data{1:end});
        elseif ischar(Data{1})
            answer = inputdlg({sprintf('Change %s',TitleString)}, 'Edit Middle Layer Parameter', size(Data{1},1), {num2str(Data{1})}, AddOpts);
            if isempty(answer)
                return
            end
            Data{1} = answer{1};
            set(h, 'UserData', Data);
            %setfamilydata(Data{1:end});
        end
        
    case {'noaction', 'no action'}
end