ao=getao;

%quadfam={'QF' 'QD' 'QFA'};
quadfam={'QF' 'QD'};

for ii=1:length(quadfam)
   for jj=1:length(getfamilydata(quadfam{ii},'ElementList'));
    k0=getsp(quadfam{ii},elem2dev(quadfam{ii},jj),'physics');
    setsp(quadfam{ii},(k0+0.04*randn),elem2dev(quadfam{ii},jj),'physics');
    k=getsp(quadfam{ii},elem2dev(quadfam{ii},jj),'physics');
    disp([quadfam{ii} ' element ' num2str(jj) ' value ' num2str(k0)])
   end
end

plotbeta