function assertTrue(desc, expr)
% Assert an expression is true
% desc - description of the failure
% expr - expression to evaluate

if(expr == 0)
    fail(desc, printstack);
end

