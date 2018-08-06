sp3v81f
global THERING
Optics = GetTwiss(THERING,0.0);
indx=ATIndex(THERING);
icor=indx.COR;
ibpm=indx.BPM;
ikick=indx.KICKER;
indx=sort([icor ibpm ikick]);

disp('name    phix   phiy   betax   betay')
for k=1:length(indx)
    j=indx(k);
    phix=num2str(Optics.phix(j));
    phiy=num2str(Optics.phiy(j));
    bx=num2str(Optics.betax(j));
    by=num2str(Optics.betay(j));
    disp([Optics.name(j,:),'  ',phix,'  ', phiy,'  ',bx,'  ',by]);
end
