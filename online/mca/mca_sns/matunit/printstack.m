function stack = printstack(pop)

if nargin == 0, pop=3; end
[stack,where] = dbstack;
pop = min(pop,length(stack));
stack = stack(pop:length(stack));
output = '';
fmt = '    at %s:%d';
for i = 1:length(stack)
    output = [output sprintf(fmt, stack(i).name, stack(i).line)];
    fmt = '\n    at %s:%d';
end
stack = output;
