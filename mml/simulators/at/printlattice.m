function varargout = printlattice(varargin)
%PRINTLATTICE - Simple printout of the elements of the model
%  printlattice(THERING,[format,index,'filename'])
%
%  Reads THERING and give a simple printout of the elements to standard out
%  (screen). If INDEX is specified only those elements in the INDEX will be
%  printed out and if FILENAME is specified the output will also be printed
%  to file and not printed to standard out (screen). Nothing is returned by
%  PRINTLATTICE.
%
%  FORMAT determines how the output should look.
%    'element'  -  element by element simple output (default)
%    'input'    -  list of unique elements followed by element position
%
%  See also plottwiss, drawlattice

%  Written by Eugene Tan


global THERING

% parse headers
index = [];
filename = '';
element = 1;
input = 0;
for i=nargin:-1:1
    if iscell(varargin{i})
        THERING = varargin{i};
    elseif ischar(varargin{i})
        switch varargin{i}
            case 'element'
                element = 1;
            case 'input'
                input = 1;
            otherwise
                filename = varargin{i};
        end
    elseif isnumeric(varargin{i})
        index = varargin{i};
    else
        fprintf('Input parameter number %d ignored\n',i);
    end
end


% need to specify thering to use
if isempty(THERING)
    error('AT model not found');
end


% if index is not specified by the user then print all the elements
if isempty(index)
    index = 1:length(THERING);
end

if isempty(filename)
    % standard output
    fid = 1;
else
    % open file and write to it
    fid = fopen(filename,'w');
end


if input
    % cycle through index and determine unique elements
    famnames = {};
    uniqueindex = [];
    elementline = {};
    for i=index
        elementline{end+1} = THERING{i}.FamName;
        if isempty(strmatch(THERING{i}.FamName,strvcat(famnames)))
            famnames{end+1,1} = THERING{i}.FamName;
            uniqueindex(end+1) = i;
        end
    end
    index = uniqueindex;
end

% Information header
fprintf(fid,'   === Element Definitions ===\n\n');
fprintf(fid,'   DRIFT      POS  LENGTH\n');
fprintf(fid,'   MARKER     POS  LENGTH\n');
fprintf(fid,'   QUAD       POS  LENGTH  K\n');
fprintf(fid,'   MULTIPOLE  POS  LENGTH  NORMAL_POLY\n');
fprintf(fid,'   BEND       POS  LENGTH  ANGLE  ENTRANCE  EXIT  NORMAL_POLY\n');
fprintf(fid,'\n');

L = findspos(THERING, 1:length(THERING));

for i=index
    elstring = [sprintf('%10s ',THERING{i}.FamName) ' '];
    switch THERING{i}.PassMethod
        case {'DriftPass'}
            elstring = [elstring sprintf('%10s %11.6f %10.7f\n','DRIFT', L(i), THERING{i}.Length)];
        case {'IdentityPass'}
            elstring = [elstring sprintf('%10s %11.6f %10.7f\n','MARKER', L(i),THERING{i}.Length)];
        case {'AperturePass'}
            elstring = [elstring sprintf('%10s %11.6f\n','Aperture', L(i))];
        case {'CavityPass'}
            elstring = [elstring sprintf('%10s %11.6f %10.7f %10.1f\n',...
                'CAVITY', L(i), THERING{i}.Length, THERING{i}.Frequency)];
        case {'CorrectorPass'}
            elstring = [elstring sprintf('%10s %11.6f %10.7f %10.7f %10.7f\n',...
                'CORRECTOR', L(i), THERING{i}.Length, THERING{i}.KickAngle)];
        case {'QuadLinearPass'}
            elstring = [elstring sprintf('%10s %11.6f %10.7f %10.7f\n',...
                'QUAD', L(i), THERING{i}.Length,THERING{i}.PolynomB(2))];
        case {'StrMPoleSymplectic4Pass' 'StrMPoleSymplectic4RadPass'}
            elstring = [elstring sprintf('%10s %11.6f %10.7f ','MULTIPOLE', L(i), THERING{i}.Length) ...
                sprintf('%10.7f ', THERING{i}.PolynomB) sprintf('\n')];
        case {'BendLinearPass' 'BndMPoleSymplectic4Pass','BndMPoleSymplectic4RadPass'}
            elstring = [elstring sprintf('%10s %11.6f %10.7f %10.7f %10.7f %10.7f ',...
                'BEND', L(i), THERING{i}.Length,THERING{i}.BendingAngle, THERING{i}.EntranceAngle, THERING{i}.ExitAngle) ...
                sprintf('%10.7f ', THERING{i}.PolynomB) sprintf('\n')];
        otherwise
            elstring = [elstring sprintf('%10s %11.6f (#%d)\n', 'UNKNOWN ELEMENT', L(i), i')];
            %fprintf('   UNKNOWN ELEMENT (#%d)\n', i);
    end
    fprintf(fid,'%s',elstring);
end

if input
    fprintf(fid,'\n\n === Element Arrangement === \n\n');
    elstring = '';
    for i=1:length(elementline)
        elstring = [elstring sprintf('%10s ',elementline{i})];
        if mod(i,5) == 0
            fprintf(fid,'%s\n',elstring);
            elstring = '';
        end
    end
    fprintf(fid,'%s\n',elstring);
end

if fid ~= 1
    fclose(fid);
end