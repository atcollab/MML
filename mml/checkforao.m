function checkforao
%CHECKFORAO - Run aoinit if no middle layer is present 
%  checkforao

AO = getao;
if isempty(AO)
    aoinit;
end


