function plot(s, MLObj)
%PLOT - Plot a middle layer object
%
%  Written by Greg Portmann


if nargin == 1
    MLObj = s;
end

FamilyNameCell = fieldnames(MLObj);
N = length(FamilyNameCell);

for i = 1:N
    
    s = getspos(MLObj.(FamilyNameCell{i}));
    
    if i == 1
        clf reset
    end
    subplot(N,1,i);
    
    plot(s, MLObj.(FamilyNameCell{i}).Data, '.-');
    xlabel('Position [meters]');
    ylabel(sprintf('%s [%s]', MLObj.(FamilyNameCell{i}).FamilyName, MLObj.(FamilyNameCell{i}).UnitsString));
    %title(sprintf('%s', MLObj.(FamilyNameCell{i}).DataDescriptor));
    
    if N == 1 & ~isempty(MLObj.(FamilyNameCell{i}).TimeStamp)
        addlabel(1,0, datestr(MLObj.(FamilyNameCell{i}).TimeStamp,0));
    end
end