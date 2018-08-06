function [bl r_str] = new_block(loop,s_data,fid,n_e,e_list,n_b,b_list)
% [bl r_str] = new_block(loop,s_data,fid,n_e,e_list,n_b,b_list)
% Decode the line/block data with inputs: "s_data", "fid", "n_e", "e-list", "n_b" and "b_list".
% loop is used to indicate the loop-level of this recursive function.
% n_e: number of elements
% e_list: list of ap_element (including name)
% n_b: number of blocks
% b_list: list of block name
% Return the "bl" which is an array and each element in array is an index in e_list.
% Return the remainder of input "str" for further use.
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also known as Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Terminology and Category: init_lattice
%------------------------------------------------------------------------------
% block_label: line = [(][interger-number*][(][element_name block_name,][); &... !...]
% Replace function: seqreverse([0 1 2 3 4 5 6 7 8 9]) = [9 8 7 6 5 4 3 2 1 0]
% By using the function: reverse_list([0 1 2 3 4 5 6 7 8 9]) = [9 8 7 6 5 4 3 2 1 0]
% left_parenthesis (
% left_bracket [
%--------------------------------------------------------------------------
left_right = 0;
value = 1;
%disp(['new_block with loop=' num2str(loop)])
if (nargin ~= 7)
    display(['ERROR (arguments): [bl r_str] = new_block(loop,s_data,fid,n_e,e_list,n_b,b_list)']);
    error('Check the arguments.');
end
if fid == -1
    error('Please check the file-identity "fid" in the new_block(...,fid,...)!' );
end

% dc.type: 1) word 2) integer 3) separator 4) comment
% dc = decoding(1,str,'',0,'1234567890',9,',=-*();','&!');
% decoding(mode=1,...) decodes one data each time
% decoding(mode=0,...) decodes all data at once
bl = [];
block = [];
new_str = 0;
terminator = 0; % control the while loop
str = s_data;
r_str = str;
while terminator ~= 1
    % decoding(mode=1,...) decodes one data each time.
    %display(str)
    %display(terminator)
    [answer dc] = get_something(str,'',0,'-1234567890',10,',=*();','&!');
    if answer == 0 % end-of-str
        terminator = 1;
    else % dc.n == 1
        r_str = dc.r;
        str = r_str;
        find = 0;
        switch dc.type(1)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case 1 % label
                label = dc.data{1};
                for i = 1:n_b
                    % search the label in the beamline/block list
                    idx = strmatch(label,b_list(i).Name,'exact');
                    if ~isempty(idx)
                        block = [block b_list(i).List];
                        find = 1;
                        break
                    end
                end
                if find == 0
                    % search the label in the element list
                    id = elem_find(e_list,lower(label)); % OOP: id = ap_search(e_list,label);
                    if id > 0
                        block = [block id];
                        find = 1;
                    end
                end
                if find == 0
                    disp('ERROR: [bl r_str] = new_block(loop,s_data,fid,n_e,e_list,n_b,b_list)')
                    disp([label '@' s_data])
                    error('Syntex ERROR: undefined "label".')
                else
                    find = 0;
                end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
            case 2 % integer
                value = dc.data{1}
                str = r_str;
                [yn da] = get_something(str,'',0,'-1234567890',10,',=*();','&!');
                if yn == 0
                    disp('ERROR: [bl r_str] = new_block(loop,s_data,fid,n_e,e_list,n_b,b_list)')
                    disp(str)
                    error('Syntex ERROR: not an integer "number"!')
                else
                    r_str = da.r;
                    if da.type(1) ~= 3
                        disp('ERROR: [bl r_str] = new_block(loop,s_data,fid,n_e,e_list,n_b,b_list)')
                        disp(s_data)
                        error('After an "integer", the character "*" is needed.')
                    else
                        if da.data{1} ~= '*'
                            disp('ERROR: [bl r_str] = new_block(loop,s_data,fid,n_e,e_list,n_b,b_list)')
                            disp([da.data{1} '@' s_data])
                            error('After an "integer", the character "*" is needed.')
                        else
                            str = r_str;
                            [tf dd] = get_something(str,'',0,'-1234567890',10,',=*();','&!');
                            if tf == 0
                                disp('ERROR: bl = new_block(loop,s_data,fid,n_e,e_list,n_b,b_list)')
                                disp(['After *,' dd.data{1} '@' str])
                                error('After an "integer*", no data is found.')
                            else
                                r_str = dd.r;
                                str = r_str; %%%%%%%%%%
                                if dd.type(1) == 1
                                    label = dd.data{1};
                                    for i = 1:n_b
                                        % search the label in block list
                                        idx = strmatch(label,b_list(i).Name,'exact');
                                        if ~isempty(idx)
                                            if value < 0
                                                temp = reverse_list(b_list(i).List);
                                                repeat = -value;
                                            else
                                                temp = b_list(i).List;
                                                repeat = value;
                                            end
                                            %display(temp)
                                            %display(block)
                                            %display(repeat)
                                            for ic = 1:repeat
                                                block = [block temp];
                                            end
                                            disp(['value(' num2str(value) ')*block'])
                                            %display(block)
                                            find = 1;
                                            break
                                        end
                                    end
                                    if find == 0
                                        for i = 1:n_e
                                            % search the label in element list
                                            idx = strmatch(label,e_list(i).Name,'exact');
                                            if ~isempty(idx)
                                                if value < 0
                                                    repeat = -value;
                                                else
                                                    repeat = value;
                                                end
                                                for ic = 1:repeat
                                                    block = [block i];
                                                end
                                                disp(['value(' num2str(value) ')*element'])
                                                %display(block)
                                                find = 1;
                                                break
                                            end
                                        end
                                    end
                                    if find == 0
                                        disp('ERROR: [bl r_str] = new_block(loop,s_data,fid,n_e,e_list,n_b,b_list)')
                                        disp([label '@value*label' s_data])
                                        error('Syntex ERROR: undefined "label".')
                                    else
                                        find = 0;
                                    end
                                elseif dd.type(1) == 3
                                    if dd.data{1} == '('
                                        str = dd.r;
                                        [sub_list r_str] = new_block(loop+1,str,fid,n_e,e_list,n_b,b_list);
                                        str = r_str;
                                        if value < 0
                                            temp = reverse_list(sub_list);
                                            repeat = -value;
                                        else
                                            temp = sub_list;
                                            repeat = value;
                                        end
                                        for ic = 1:repeat
                                            block = [block temp];
                                        end
                                        disp(['value(' num2str(value) ')*(sub_beamline)'])
                                        %display(block)
                                    else
                                        disp('ERROR: bl = new_block(loop,s_data,fid,n_e,e_list,n_b,b_list)')
                                        disp(['After *,' dd.data{1} '@' s_data])
                                        error('After an "integer*", the character "(".')
                                    end
                                else
                                    disp('ERROR: bl = new_block(loop,s_data,fid,n_e,e_list,n_b,b_list)')
                                    disp(['After *,' dd.data{1} '@' s_data])
                                    error('After an "integer*", the character "(" or a "label" is expected.')
                                end
                            end
                        end
                    end
                end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case 3 % seperator ',' '=' ';' '(' ')'
                switch dc.data{1}
                    case ';' % terminator
                        if loop ~= 0
                            disp('ERROR: bl = new_block(loop,s_data,fid,n_e,e_list,n_b,b_list)')
                            disp(s_data)
                            error('Syntex ERROR')
                        else
                            terminator = 1;
                        end
                    case '('
                        [temp r_str] = new_block(loop+1,str,fid,n_e,e_list,n_b,b_list);
                        str = r_str;
                        %display(temp)
                        %display(block)
                        block = [block temp];
                    case ')'
                        if loop < 1
                            disp('ERROR: bl = new_block(loop,s_data,fid,n_e,e_list,n_b,b_list)')
                            disp(s_data)
                            error('Syntex ERROR')
                        else % take it as a terminator
                            terminator = 1;
                        end
                    otherwise
                        % skip 
                end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case 4 % comment
                comment = dc.data{1};
                if comment(1) == '&'
                    new_str = 1;
                    while (feof(fid) == 0) && (new_str == 1)
                        str = fgetl(fid);
                        sss = strtrim(str);
                        nnn = length(sss);
                        for qqq = 1:nnn
                            ccc = sss(qqq);
                            if (ccc < 33) || (ccc == 127)
                                continue
                            elseif ccc == '!'
                                break
                            else
                                new_str = 0;
                                break
                            end
                        end
                    end
                else % When comment character '!' does not locate at the beginning, take it as terminator. 
                    terminator = 1;
                end
            otherwise
        end % end-of-switch
    end
end
if terminator ~= 1
    error('The new_block is terminated unnormally.')
else
    %display(block)
    bl = block;
    %display(loop)
    %display(s_data)
    terminator = 0;
end
return