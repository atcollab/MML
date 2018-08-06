function assertEquals(desc, expected, actual, optTol)
% Assert two values are equal, raising an error if they are not
% assertEquals(desc, v1, v2) : strict equality
% assertEquals(desc, v1, v2, tol) : specify tolerance
% desc - description of the failure
% expected - expected result
% actual - actual result
% optTol - optional tolerance

tol = 0;
if nargin == 4, tol = optTol; end

lastwarn('');
pass = 0;

if isempty(expected)
    pass = isempty(actual);
elseif isempty(actual)
    pass = 0;
elseif length(class(expected)) ~= length(class(actual)) ...
       | class(expected) ~= class(actual)
    pass = 0;
elseif length(expected) ~= length(actual)
    pass = 0;
elseif length(size(expected)) ~= length(size(actual)) ...
       | size(expected) ~= size(actual)
    pass = 0;
else
    try
        result = abs(expected-actual) > tol;
        pass = sum(result(:)) == 0;
    catch
        lasterr('');
        if iscellstr(expected)
            pass = strcmp(toString(expected), toString(actual));
        elseif ischar(expected)
            v1 = char(expected);
            v2 = char(actual);
            compare = strcmp(v1, v2);
            pass = sum(compare(:)) == length(compare);
        else
            error(sprintf('Compare type "%s" not handled', class(expected)));
        end
    end
end

if ~pass 
    msg = sprintf('%s expected:<%s> but was:<%s>', ...
                  desc, toString(expected), toString(actual));
    fail(msg, printstack);
end

function str = toString(obj) 
% Format an object for dislpay
str = '';

if isnumeric(obj) | islogical(obj)
    str = num2str(obj);
elseif iscellstr(obj)
    spc = '';
    sz = size(obj);
    if sz(1) == length(obj), tr=';'; else tr=''; end
    for i = 1:length(obj)
        str = [ str spc '''' obj{i} '''' ];
        spc = [tr ' '];
    end
else
    str = char(obj);
end

