% test nod
% cas bande etroite : reserre le sweep fréquence min max centré sur nombre
% d'onde
% cas bande large   : les fixes à 100 et 400 kHz par défaut

%mode =0  bande etroite
%mode =1  bande large

mode=0;
% cas bande étroite
if (mode==0)
    dnux=0.04;
    dnuz=0.04;
    FFTaverage=uint16(5);
    fprintf('*********Mode bande etroite**************\n')
    %plan H
        temp=tango_read_attribute2('ANS/DG/BPM-TUNEX','NuRaw');tunex=temp.value;
        tunex=0.2
        freq=352202000/416;
        f0=tunex*freq;
        f1=(tunex-dnux)*freq;
        f2=(tunex+dnux)*freq;
        tango_write_attribute2('ANS-C14/DG/NOE.H','SweepStartFrequency',f1);
        tango_write_attribute2('ANS-C14/DG/NOE.H','SweepStopFrequency',f2);
        tango_write_attribute2('ANS/DG/BPM-TUNEX','FFTAveraging',FFTaverage);
        fprintf('Freq Shaker Plan H start beam stop : %g %g %g\n',f1,f0,f2)
    %plan V
        temp=tango_read_attribute2('ANS/DG/BPM-TUNEZ','NuRaw');tunez=temp.value;
        tunez=0.295
        freq=352202000/416;
        f0=tunez*freq;
        f1=(tunez-dnuz)*freq;
        f2=(tunez+dnuz)*freq;
        tango_write_attribute2('ANS-C14/DG/NOE.V','SweepStartFrequency',f1);
        tango_write_attribute2('ANS-C14/DG/NOE.V','SweepStopFrequency',f2);
        tango_write_attribute2('ANS/DG/BPM-TUNEZ','FFTAveraging',FFTaverage);
        fprintf('Freq Shaker Plan V start beam stop : %g %g %g\n',f1,f0,f2)

%cas large bande
elseif(mode==1)
    f1=100000;
    f2=400000;
     fprintf('*********Mode bande large*********\n')
    %plan H
       temp=tango_read_attribute2('ANS/DG/BPM-TUNEX','NuRaw');tunex=temp.value;
       freq=352202000/416;
       f0=tunex*freq;
       tango_write_attribute2('ANS-C14/DG/NOE.H','SweepStartFrequency',f1);
       tango_write_attribute2('ANS-C14/DG/NOE.H','SweepStopFrequency',f2);
       fprintf('Freq Shaker Plan H start beam stop : %g %g %g\n',f1,f0,f2)
    %plan V
       temp=tango_read_attribute2('ANS/DG/BPM-TUNEZ','NuRaw');tunez=temp.value;
       freq=352202000/416;
       f0=tunez*freq;
       tango_write_attribute2('ANS-C14/DG/NOE.V','SweepStartFrequency',f1);
       tango_write_attribute2('ANS-C14/DG/NOE.V','SweepStopFrequency',f2);
       fprintf('Freq Shaker Plan V start beam stop : %g %g %g\n',f1,f0,f2)
end

