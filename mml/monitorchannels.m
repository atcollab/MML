function [Out1, Out2, Out3, Out4, Out5, Out6, Out7, Out8, Out9, Out10] = monitorchannels(In1, In2, In3, In4, In5, In6, In7, In8, In9, In10);
%MONITORCHANNELS - Monitor a groups of families or channel names
%  [Out1, Out2, ... , t] = monitor(FuncStr1, FuncStr2, ... , t);
%   
%  INPUTS
%  1. FuncStr1, FuncStr2, ... - functions to be evaluated (max. 9) (string)
%                              (must return a scalar or column vector)
%  2. t - time (row vector) 
%
%  OUTPUTS 
%  1. tout (row vector) - time at the start of each set of measurements,
%                         tout will be the last output matrix
%
%  NOTES
%  1. One should compare tout to t, to varify timing accuracy.
%  2. This function can also be done by getpv using cell arrays.
%
%  EXAMPLES
%  1. [BPMx, BPMy, tout]     = Monitor('getx', 'gety', t);
%  2. [VCMam, Current, tout] = Monitor('getam(''VCM'')', 'getdcct', t);

%  Written by Greg Portmann


if nargin > 10
    error('10 inputs maximum');
end

FuncNum = nargin - 1;
eval(['t = In',num2str(nargin),';']);

if nargout < nargin 
    disp('WARNING:  Not enough outputs arguments!');
end

% Create data arrays
if nargout >=1 & FuncNum >= 1
    a = eval(In1);
    Out1 = zeros(size(a,1), size(t,2));
end
if nargout >=2 & FuncNum >= 2
    a = eval(In2);
    Out2 = zeros(size(a,1), size(t,2));
end
if nargout >=3 & FuncNum >= 3
    a = eval(In3);
    Out3 = zeros(size(a,1), size(t,2));
end
if nargout >=4 & FuncNum >= 4
    a = eval(In4);
    Out4 = zeros(size(a,1), size(t,2));
end
if nargout >=5 & FuncNum >= 5
    a = eval(In5);
    Out5 = zeros(size(a,1), size(t,2));
end
if nargout >=6 & FuncNum >= 6
    a = eval(In6);
    Out6 = zeros(size(a,1), size(t,2));
end
if nargout >=7 & FuncNum >= 7
    a = eval(In7);
    Out7 = zeros(size(a,1), size(t,2));
end
if nargout >=8 & FuncNum >= 8
    a = eval(In8);
    Out8 = zeros(size(a,1), size(t,2));
end
if nargout >=9 & FuncNum >= 9
    a = eval(In9);
    Out9 = zeros(size(a,1), size(t,2));
end

% Read once to setup channels (for SCA)
i=1;
if nargout >=1 & FuncNum >= 1
    Out1(:,i) = [eval(In1)];
end
if nargout >=2 & FuncNum >= 2
    Out2(:,i) = [eval(In2)];
end
if nargout >=3 & FuncNum >= 3
    Out3(:,i) = [eval(In3)];
end
if nargout >=4 & FuncNum >= 4
    Out4(:,i) = [eval(In4)];
end
if nargout >=5 & FuncNum >= 5
    Out5(:,i) = [eval(In5)];
end
if nargout >=6 & FuncNum >= 6
    Out6(:,i) = [eval(In6)];
end
if nargout >=7 & FuncNum >= 7
    Out7(:,i) = [eval(In7)];
end
if nargout >=8 & FuncNum >= 8
    Out8(:,i) = [eval(In8)];
end
if nargout >=9 & FuncNum >= 9
    Out9(:,i) = [eval(In9)];
end


% Get data
%t0 = clock;
t0 = gettime;
for i = 1:size(t,2);
    %tout(1,i) = etime(clock,t0);
    while gettime-t0 < t(i)-.002
    end
    
    tout(1,i) = gettime-t0;
    
    if nargout >=1 & FuncNum >= 1
        Out1(:,i) = [eval(In1)];
    end
    if nargout >=2 & FuncNum >= 2
        Out2(:,i) = [eval(In2)];
    end
    if nargout >=3 & FuncNum >= 3
        Out3(:,i) = [eval(In3)];
    end
    if nargout >=4 & FuncNum >= 4
        Out4(:,i) = [eval(In4)];
    end
    if nargout >=5 & FuncNum >= 5
        Out5(:,i) = [eval(In5)];
    end
    if nargout >=6 & FuncNum >= 6
        Out6(:,i) = [eval(In6)];
    end
    if nargout >=7 & FuncNum >= 7
        Out7(:,i) = [eval(In7)];
    end
    if nargout >=8 & FuncNum >= 8
        Out8(:,i) = [eval(In8)];
    end
    if nargout >=9 & FuncNum >= 9
        Out9(:,i) = [eval(In9)];
    end
end

% Output number for tout
if nargout > FuncNum
    OutStr = ['Out',num2str(FuncNum+1)];
    eval([OutStr,'=tout;']);
end
