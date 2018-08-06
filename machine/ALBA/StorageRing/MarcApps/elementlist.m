nmax=length(THERING);
blist=[0];
bmax=1;
qlist=[0];
qmax=1;
clist=[0];
cmax=1;
slist=[0];
smax=1;
for i=1:nmax,
    Elem=THERING{i};
    if isfield(Elem,'BendingAngle') & Elem.BendingAngle
       blist(bmax)=i;
       bmax = bmax + 1;
    elseif isfield(Elem,'K') 
        qlist(qmax)=i;
        qmax=qmax + 1; 
    elseif  isfield(Elem,'MaxOrder') & Elem.PolynomB(3)
        slist(smax)=i;
        smax = smax +1 ;
    elseif isequal(Elem.PassMethod,'CorrectorPass')
        clist(cmax)=i;
        cmax = cmax + 1;
    end
end
        
    
