function assertFalse(desc, expr)
% Assert an expression is false
% desc - description of the failure
% expr - expression to evaluate

if(expr ~= 0)
    fail(desc, printstack);
end

