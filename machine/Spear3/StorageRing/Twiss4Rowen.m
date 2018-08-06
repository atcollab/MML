%compute Twiss parameters at downstream end of downstream dipole in G17
%and upstream end of upstream dipole in G18
%
global THERING
sp3v82;
Optics=GetTwiss(THERING,0);

for ii=1:length(THERING)
    
    if strcmpi(THERING{ii}.FamName,'MIKE')
        %disp([THERING{ii}.FamName])
        disp([Optics.name(ii,:)])
        disp(['betax=' num2str(Optics.betax(ii))]);
        disp(['alfax=' num2str(Optics.alfax(ii))]);
        disp(['gammax=' num2str(Optics.gammax(ii))]);
        disp(['phix=' num2str(Optics.phix(ii))]);
        disp(['etax=' num2str(Optics.etax(ii))]);
        disp(['etapx=' num2str(Optics.etapx(ii))]);
        disp(['betay=' num2str(Optics.betay(ii))]);
        disp(['alfay=' num2str(Optics.alfay(ii))]);
        disp(['gammay=' num2str(Optics.gammay(ii))]);
        disp(['phiy=' num2str(Optics.phiy(ii))]);
        disp(['etay=' num2str(Optics.etay(ii))]);
        disp(['etapy=' num2str(Optics.etapy(ii))]);
    end
end