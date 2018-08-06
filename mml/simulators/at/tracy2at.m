function FileNameOutput = tracy2at(FileNameInput)
%TRACY2AT - Reads at Tracy lattice file and converts it to AT

if nargin < 1
    FileNameInput = uigetfile('*.lat', 'Tracy input file');
end

[fidinput, errmsg]  = fopen(FileNameInput,'r');
if fidinput==-1
    error('Could not open input file');
end

FileNameOutput = FileNameInput;
i = findstr(FileNameInput,'.');
if isempty(i)
    i = length(FileNameInput);
else
    FileNameOutput(i:end) = [];
end
FileNameOutput = lower([FileNameOutput, '.m']);
[fidout, errmsg]  = fopen(FileNameOutput,'w');
if fidout==-1
    error('Could not open output file');
end

% Header info
fprintf(fidout, 'function %s\n', FileNameOutput(1:end-2));
fprintf(fidout, '% AT lattice converted from Tracy file %s\n', FileNameInput);
fprintf(fidout, 'fprintf(''   Loading AT lattice (%%s)\\n'', mfilename);\n');
fprintf(fidout, '\n');
fprintf(fidout, 'global FAMLIST THERING\n');


fprintf(fidout, 'FAMLIST=cell(0);\n');

fprintf(fidout, 'AP = aperture(''AP'',[-0.035, 0.035, -0.017, 0.017],''AperturePass'');\n');



tline = LocalReadLine(fidinput);

while ischar(tline)

    if any(strcmpi(tline,{'', ' ', '-1', 'FileNameInput'}))
        %fprintf('IGNORING:  %s\n', tline);
    
    elseif ~isempty(findstr(tline, 'define lattice'))
        %fprintf('IGNORING:  %s\n', tline);
    
    elseif ~isempty(findstr(tline, 'ring type'))
        %fprintf('IGNORING:  %s\n', tline);

    elseif ~isempty(findstr(tline, '{'))
        % Need to ignor until the closing '}'  % ???

    elseif ~isempty(findstr(tline, 'Energy'))
        fprintf(fidout, '%s\n',tline);

    elseif ~isempty(findstr(tline, 'Marker'))
        % MP: Marker;
        i1 = findstr(tline, ':');
        Family = tline(1:i1(1)-1);
        fprintf(fidout, '%s = monitor(''%s'',''IdentityPass'');\n', deblank(Family), deblank(Family));

    elseif ~isempty(findstr(tline, 'Beam Position Monitor'))
        i1 = findstr(tline, ':');
        Family = tline(1:i1(1)-1);
        fprintf(fidout, '%s = monitor(''%s'',''IdentityPass'');\n', deblank(Family), deblank(Family));

    elseif ~isempty(findstr(tline, 'Drift'))
        %D0:    Drift, L = 4.27863333;
        i1 = findstr(tline, ':');
        i2 = findstr(tline, ',');
        i3 = findstr(tline, '=');
        i4 = findstr(tline, ';');

        Family = tline(1:i1(1)-1);
        L = str2double(tline(i3(1)+1:i4-1));
        
        fprintf(fidout, '%s=drift(''%s'', %f, ''DriftPass'');\n', deblank(Family), deblank(Family), L);

    elseif ~isempty(findstr(tline, 'Corrector'))
        %HCM: Corrector, Horizontal, Method= Meth;
        %VCM: Corrector, Vertical, Method= Meth;
        %HCM=corrector('HCM',0,[0,0],'CorrectorPass');
        i1 = findstr(tline, ':');
        i2 = findstr(tline, ',');
        i3 = findstr(tline, '=');
        i4 = findstr(tline, ';');

        Family = tline(1:i1(1)-1);
        %L = str2double(tline(i3(1)+1:i2(2)-1));  % No thick correctors???
        fprintf(fidout, '%s=corrector(''%s'', 0, [0 0], ''CorrectorPass'');\n', deblank(Family), deblank(Family));

    elseif ~isempty(findstr(tline, 'Quadrupole'))
        %QF: Quadrupole, L = 0.3, K = 1.579687874666792,  N = Nquad, Method = Meth;
        %QF=quadrupole('QF',0.3,1.579687874666792,'StrMPoleSymplectic4Pass');
        i1 = findstr(tline, ':');
        i2 = findstr(tline, ',');
        i3 = findstr(tline, '=');
        i4 = findstr(tline, ';');

        Family = tline(1:i1(1)-1);
        L = str2double(tline(i3(1)+1:i2(2)-1));
        K = str2double(tline(i3(2)+1:i2(3)-1));

        fprintf(fidout, '%s=quadrupole(''%s'', %f, %f, ''StrMPoleSymplectic4Pass'');\n', deblank(Family), deblank(Family), L, K);

    elseif ~isempty(findstr(tline, 'Sextupole'))
        %S1:  Sextupole, L = 0.000000, K = -1.972553, N = 1, Method = Meth;
        %S1 = sextupole('S1',0.000000, -1.972553,'StrMPoleSymplectic4Pass');
        i1 = findstr(tline, ':');
        i2 = findstr(tline, ',');
        i3 = findstr(tline, '=');
        i4 = findstr(tline, ';');

        Family = tline(1:i1(1)-1);
        L = str2double(tline(i3(1)+1:i2(2)-1));
        K2 = str2double(tline(i3(2)+1:i2(3)-1));
        delL = 1e-8;
        if L == 0
            fprintf(fidout, '%s=sextupole(''%s'', %f, %f, ''StrMPoleSymplectic4Pass'');\n', deblank(Family), deblank(Family), delL, K2/delL);
        else
            fprintf(fidout, '%s=sextupole(''%s'', %f, %f, ''StrMPoleSymplectic4Pass'');\n', deblank(Family), deblank(Family), L, K2);
        end
        
    elseif ~isempty(findstr(tline, 'Bending'))
        %B1: Bending, L = 2.62, T =  6.0000,    T1 =  3.000, T2 =  3.0000, N = Nbend, Method = Meth;
        %B1 = rbend('B1',2.1794796,0.392699081,0.19634954,0.19634954,0,'BndMPoleSymplectic4Pass');
        i1 = findstr(tline, ':');
        i2 = findstr(tline, ',');
        i3 = findstr(tline, '=');
        i4 = findstr(tline, ';');

        Family = tline(1:i1(1)-1);
        L = str2double(tline(i3(1)+1:i2(2)-1));
        BendingAngle = str2double(tline(i3(2)+1:i2(3)-1));   % Tracy->Degrees   AT->Radian
        EntranceAngle = str2double(tline(i3(3)+1:i2(4)-1));  % Tracy->Degrees   AT->Radian
        ExitAngle = EntranceAngle;
        K = 0;
        fprintf(fidout, '%s=rbend(''%s'', %f, %f*pi/180, %f*pi/180, %f*pi/180, %f, ''BndMPoleSymplectic4Pass'');\n', deblank(Family), deblank(Family), L, BendingAngle, EntranceAngle, ExitAngle, K);
        
    elseif ~isempty(findstr(tline, 'Multipole'))
        % TPW: Multipole, N = 1, Method = Meth, HOM = (2, 0.0, 0.0, 3, 0.0, 0.0);
        i1 = findstr(tline, ':');
        i2 = findstr(tline, ',');
        i3 = findstr(tline, '=');
        i4 = findstr(tline, ';');

        %         % MULTIPOLE('FAMILYNAME',Length [m],PolynomA,PolynomB,'METHOD')
        %         fprintf(fidout, '%s=multipole(''%s'', %f, %f, %f, ''StrMPoleSymplectic4Pass'');\n', tline(1:i1(1)-1), tline(1:i1(1)-1), ...
        %             str2double(tline(i3(1)+1:i2(2)-1)), str2double(tline(i3(2)+1:i2(3)-1)), str2double(tline(i3(3)+1:i2(4)-1)) );

        % Multipole needs work, use Marker for now???
        fprintf(fidout, '%s = monitor(''%s'',''IdentityPass'');\n', tline(1:i1(1)-1), tline(1:i1(1)-1));

    elseif ~isempty(findstr(tline, 'Cavity'))
        % CAV: Cavity, Frequency = c0/C*h_rf, Voltage = 5.00e6, Harnum = h_rf;
        i1 = findstr(tline, ':');
        i2 = findstr(tline, ',');
        i3 = findstr(tline, '=');
        i4 = findstr(tline, ';');

        Family = tline(1:i1(1)-1);
        L = 0; % ???
        MVolts = str2double(tline(i3(2)+1:i2(3)-1));

        % Hopefully c0, C, h_rf are defined (this looks Johan specific, not Tracy)
        fprintf(fidout, '%s=rfcavity(''%s'', 0, %f, %f, %f, ''CavityPass'');\n', deblank(Family), deblank(Family), MVolts, c0/C*h_rf, h_rf);

    elseif ~isempty(findstr(tline, 'CELL'))
        % ???

    elseif ~isempty(findstr(tline, ':'))
        i1 = findstr(tline, ':');
        tline(i1)='=';
        tline = [tline(1:i1) '[' tline(i1+1:end)];
        tline(end:end+1)='];';

        if ~isempty(findstr(tline, 'INV'))
            i = findstr(tline, 'INV');
            for j = length(i):-1:1
                tline(i(j):i(j)+2) = [];
                tline = [tline(1:i(j)-1) 'reverse' tline(i(j):end)];
            end
        end
        
        % Need to look for '*' and expand???

        fprintf(fidout, '%s\n\n',tline);
        
    else
        % try to evaluate the line to pick up any constants that may be present
        try
            %fprintf(fidout, '%s\n',tline);
            eval(tline);
        catch
        end
    end


    tline = LocalReadLine(fidinput);
end


fprintf(fidout, 'buildlat(RING);\n');  % Hopefully it's called RING in all Tracy input files
fprintf(fidout, 'evalin(''caller'',''global THERING FAMLIST GLOBVAL'');\n');
fprintf(fidout, 'THERING = setcellstruct(THERING, ''Energy'', 1:length(THERING), Energy*1e9);\n');
%fprintf(fidout, 'setcavity off;\n');
%fprintf(fidout, 'setradiation off;\n');
fprintf(fidout, 'clear global FAMLIST\n');
fprintf(fidout, 'evalin(''base'',''clear LOSSFLAG'');\n');


% Compute total length and RF frequency
fprintf(fidout, 'L0_tot = findspos(THERING, length(THERING)+1);\n');
fprintf(fidout, 'fprintf(''   L0 = %%.6f\\n'', L0_tot);\n');



fclose(fidinput);
fclose(fidout);



function OutLine = LocalReadLine(fid)
LastChar = '';
OutLine = '';

while isempty(LastChar) || (LastChar~=';' && LastChar~='}')
    tline = fgetl(fid);

    % Remove blanks at the end
    for i = length(tline):-1:1
        if tline(i) == ' ';
            tline(i) = [];
        else
            break;
        end
    end

    if ~ischar(tline)
        OutLine = tline;
        break;
    end
    OutLine = [OutLine tline];
    if ~isempty(OutLine)
        LastChar = OutLine(end);
    end
end

