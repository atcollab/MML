function stringExpression = configparser_fn(functionName,nb)
% configparser_fn - Contructs a expression for TangoParser
%
%  INPUTS
%  1. functionName - 'Mean' - mean value expression
%                 - 'Rms'  - rms value expression
%  2. nb - Number of terms for computing the expression
%
%  OUTPUTS
%  1. stringExpression - Expression for tangoparser formula input
%
%  See also configparser
if nb <2
    error('nb too small')
end

switch functionName
    case 'Mean'
        % set expression
        stringExpression = [];
        for k=1:nb,
            if k ~= nb && k ~= 1
                stringExpression = [stringExpression 'x' num2str(k) '+'];
            elseif k == 1
                stringExpression = ['(' stringExpression 'x' num2str(k) '+'];
            elseif k == nb
                stringExpression = [stringExpression 'x' num2str(k) ')/' num2str(nb)];
            end
        end
    case 'Rms'
        muExpression = [];
        x2Expression = [];
        for k=1:nb,
            if k ~= nb && k ~= 1
                muExpression = [muExpression 'x' num2str(k) '+'];
                x2Expression = [x2Expression 'x' num2str(k) '*' 'x' num2str(k) '+'];
            elseif k == 1
                muExpression = ['(' muExpression 'x' num2str(k) '+'];
                x2Expression = ['(' x2Expression 'x' num2str(k) '*' 'x' num2str(k) '+'];
            elseif k == nb
                muExpression = [muExpression 'x' num2str(k) ')/' num2str(nb)];
                x2Expression = [x2Expression 'x' num2str(k) '*' 'x' num2str(k) ')/' num2str(nb)];
            end
        end
        stringExpression = [ num2str(nb) '/' num2str(nb-1) '*(' x2Expression '-' muExpression '*' muExpression ')'];
    otherwise
        error('Unknown function')
end
