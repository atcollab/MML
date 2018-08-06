function [passres, failres, warnres] = runner(tests, printresult)
% Run through a list of tests and return results
% tests - list of the tests as function handles
% printresult - flag to print a report statement after each test
% passres - vector indicating which tests passed
% failres - vector indicating which tests failed
% warnres - vector indicating which tests had a warning
%
% Timothy Wall
% Oculus Technologies Corporation
% Copyright (c) 2005 Timothy Wall
%------------------------------------------------------------------------

if nargin == 1 
    printresult = 1;
elseif nargin == 0
    error('Please provide a list of test functions');
end
n = length(tests);

warning off
clear passres failres warnres;
passres = zeros(n,1);
failres = zeros(n,1);
warnres = zeros(n,1);
results = { };

tic;
total=0;
for testh = tests
    testname = func2str(testh);
    lastwarn(''); lasterr('');

    result = '';
    try
        fprintf('.');
        % TODO: use new invocation "test()" in newer versions
        feval(testh); 
        total = total + 1;
        % special-case check for framework error-producing tests
        if ~strcmp(lastwarn,'') & isempty(strfind(testname,'XError'))
            result = sprintf('ERROR: %s: %s\n', testname, lastwarn);
            warnres(total) = 1;
            fprintf('E');
        else
            passres(total) = 1;
            fprintf('.');
        end
    catch
        % ignore improperly scanned functions where the
        % error message is "Undefined function 'testname'" (6.1)
        % or "Undefined function or variable 'testname'" (7+)
        if isempty(strfind(lasterr,sprintf('''%s''', testname)))
            total = total + 1;
            % if an assert didn't produce the error, use the original
            % error message
            if isempty(strfind(lasterr,'FAIL:'))
                if ~isempty(strfind(testname,'XError'))
                    type='';
                    passres(total) = 1;
                    fprintf('.');
                else
                    type='ERROR';
                    msg = lasterr;
                    warnres(total) = 1;
                    fprintf('E');
                end
            else
                type='FAIL';
                msg = lastwarn;
                failres(total) = 1;
                fprintf('F');
            end
            if ~strcmp(type,'')
                result = sprintf('%s: %s: %s\n', type, testname, msg);
            end
        else
            %disp(sprintf('ignore ''%s''', testname));
            fprintf('\b');
        end
    end
    if ~strcmp('', result)
        results(length(results)+1) = cellstr(result);
    end

    if mod(total,40) == 0, fprintf('\n'); end
end
fprintf('\nTime: %.3fs\n', toc);

passres(total+1:n) = [];
failres(total+1:n) = [];
warnres(total+1:n) = [];

if printresult
    if length(results) > 0
        fprintf('There were %d failures and %d errors:\n', ...
                sum(failres), sum(warnres));
    end
    for i=1:length(results)
        fprintf('%s\n', char(results(i)));
    end
end
if sum(failres) | sum(warnres)
    fprintf('FAILURES!!!\n');
    fprintf('Tests run: %d,  Failures: %d,  Errors %d\n', ...
            total, sum(failres), sum(warnres));
else
    fprintf('OK (%d tests)\n', total);
end
