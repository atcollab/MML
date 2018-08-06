function fail(msg, stack)
%fail(msg, stack)
% Raise a failure with the given message and context
if nargin == 1
    stack = printstack;
end
msg=sprintf('%s\n%s', msg, stack);
lastwarn(msg);
error(sprintf('FAIL: %s', msg));
