function out = betty(b)

% Reads in a file and cycles the magnets according to that files specifications.
% The three files to use are btsdata.m ltbdata.m and srdata.m
% Example: betty('ltbdata.m') is a correct input. If you recieve the
% message 'Oops I did it again' then the input was incorrect in some way.

%  Opens input file and allows it to be read
fid = fopen(b,'r');

% Takes the input and switches to the appropriate section
switch lower(b)
    case {'btsdata.m'}
        disp('Which dipole do you wish to cycle?')
        answer = input('[bts31\\bts32\\bts33\\bts34]: ','s');

        for i = 1:4
            dag{i} = fgetl(fid);
            loop(i) = getsp(dag{i});

        end
        for k = 1:4
            nab{k} = fgetl(fid);

        end
        for j = 1:4
            it{j} = fgetl(fid);
            min(j) = str2num(it{j});

        end
        for n = 1:4
            igin{n} = fgetl(fid);
            max(n) = str2num(igin{n});

        end

        switch lower(answer)
            case {'bts31'}
                i = 1;

            case {'bts32'}
                i = 2;

            case {'bts33'}
                i = 3;

            case {'bts34'}
                i = 4;

            otherwise
                disp('Oops I did it again')
                return;
        end;

        % Sets the dipoles to zero and displays current monitor values

        %         setsp(dag{i}, min(i));
        disp('Commencing thoughts')
        disp(dag{i})
        pause(6)
        rdbk(i) = getpv(nab{i});
        disp(rdbk(i))


        pause(3)

        % Sets the dipoles to maximum and displays current monitor values
        %         setsp(dag{p}, max(p));
        disp('Thinking.......')
        disp(dag{i})
        pause(6)
        rdbk(i) = getpv(nab{i});
        disp(rdbk(i))


        pause(3)

        % Sets the dipoles to saved set points and displays current monitor values
        %             setsp(dag{i}, loop(i));
        disp('Still thinking......')
        disp(dag{i})
        pause(6)
        rdbk(i) = getpv(nab{i});
        disp(rdbk(i))

    case {'ltbdata.m'}
        for i = 1:3
            dag{i} = fgetl(fid);
            loop(i) = getsp(dag{i});

        end


        for k = 1:3
            nab{k} = fgetl(fid);

        end
        for j = 1:3
            it{j} = fgetl(fid);
            min(j) = str2num(it{j});


        end
        for n = 1:3
            igin{n} = fgetl(fid);
            max(n) = str2num(igin{n});

        end

        for m = 1:11
            dag1{m} = fgetl(fid);
            loop1(m) = getsp(dag1{m});

        end


        for p = 1:11
            nab1{p} = fgetl(fid);

        end
        for q = 1:11
            it1{q} = fgetl(fid);
            min1(q) = str2num(it1{q});


        end
        for g = 1:11
            igin1{g} = fgetl(fid);
            max1(g) = str2num(igin1{g});

        end

        disp('Which magnets do you wish to cycle?')
        answer = input('[quads\\dipoles]: ','s');

    case {'quads'}

        for i = 1:11
            %        setsp(dag1{m}, min1(m));
            disp('commencing thoughts')
            disp(dag1{i})
            pause(6)
            rdbk(i) = getpv(nab1{i});
            disp(rdbk(i))
        end

        pause(3)

        for i = 1:11
            %             setsp(dag1{p}, max1(p));
            disp('Thinking.......')
            disp(dag1{i})
            pause(6)
            rdbk(i) = getpv(nab1{i});
            disp(rdbk(i))
        end;

        pause(3)

        for i = 1:11
            %             setsp(dag1{q}, loop1(q));
            disp('Still thinking......')
            disp(dag1{i})
            pause(6)
            rdbk(i) = getpv(nab1{i});
            disp(rdbk(i))
        end;

    case {'dipoles'}

        disp('Which dipole do you wish to cycle?')
        answer = input('[ba11\\ba12\\bb1]: ','s');

        for i = 1:3
            dag{i} = fgetl(fid);
            loop(i) = getsp(dag{i});

        end


        for k = 1:3
            nab{k} = fgetl(fid);

        end
        for j = 1:3
            it{j} = fgetl(fid);
            min(j) = str2num(it{j});


        end
        for n = 1:3
            igin{n} = fgetl(fid);
            max(n) = str2num(igin{n});

        end
        switch lower(answer)
            case {'ba11'}
                i = 1;
            case {'ba12'}
                i = 2;
            case {'bb1'}
                i = 3;
            otherwise
                disp('Oops I did it again.')
        end;

        %        setsp(dag{m}, min(m));
        disp('commencing thoughts')
        disp(dag{i})
        pause(6)
        rdbk(i) = getpv(nab{i});
        disp(rdbk(i))


        pause(3)


        %             setsp(dag{p}, max(p));
        disp('Thinking.......')
        disp(dag{i})
        pause(6)
        rdbk(i) = getpv(nab{i});
        disp(rdbk(i))


        pause(3)


        %             setsp(dag{q}, loop(q));
        disp('Still thinking......')
        disp(dag{i})
        pause(6)
        rdbk(i) = getpv(nab{i});
        disp(rdbk(i))


    case {'srdata.m'}

        for i = 1:8
            dag{i} = fgetl(fid);
            loop{i} = getsp(dag{i});
            disp(loop(i))
        end

        for j = 1:8
            it{j} = fgetl(fid);
            min(j) = str2num(it{j});

            disp(it{j})
        end

        for n = 1:8
            igin{n} = fgetl(fid);
            max(n) = str2num(igin{n});
            disp(igin{n})
        end

        for m = 1:8
            %             setsp(dag{m}, min(m));
            disp('commencing thoughts')
            disp(dag{m})
            pause(6)
            rdbk{m} = getpv(dag{m});
            disp(rdbk{m})
        end

        for p = 1:8
            %             setsp(dag{p}, max(p));
            disp('Thinking.......')
            disp(dag{p})
            pause(6)
            rdbk{p} = getpv(dag{p});
            disp(rdbk{p})
        end

        for q = 1:8
            %             setsp(dag{q}, loop(q));
            disp('Still thinking......')
            disp(dag{q})
            pause(6)
            rdbk{q} = getpv(dag{q});
            disp(rdbk{q})
        end

    otherwise
        disp('Oops I did it again.')
        return;

end;
fclose(fid);


