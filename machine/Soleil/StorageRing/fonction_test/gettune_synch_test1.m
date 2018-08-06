% lecture nus

nl=100; %Boucle
% fenetre en fréquence
f1=0.003;
f2=0.008;
mem=0;  % 0 normal  1: memorise signal  2: soustrait signal memorisé (pic 4 Khz)
if mem==1
    table_freq0=ones(1,8193)*0   ;
end


for i=1:nl

    temp=tango_read_attribute2('ANS/DG/BPM-TUNEX','FFTabs');table_nu  =temp.value;
    temp=tango_read_attribute2('ANS/DG/BPM-TUNEX','FFTord');table_freq=log10(temp.value);
    temp=tango_read_attribute2('ANS/RF/MasterClock','frequency');freq_rf=temp.value(1);
    temp=tango_read_attribute2('ANS-c03/RF/LLE.1','voltageRF');V1_rf=temp.value(1);
    temp=tango_read_attribute2('ANS-c03/RF/LLE.2','voltageRF');V2_rf=temp.value(1);

    n1=int16(f1/0.061/1e-3);
    n2=int16(f2/0.061/1e-3);

    if mem==2 % soustrait le signal de bruit
        table_freq=table_freq-table_freq0;
    end

    [C,I]=max(table_freq(n1 : n2));
    nmax=I+n1-1;

    freq=table_nu(nmax);
    amp=table_freq(nmax);
    fprintf('rf= %f V1=%g V2=%g  #########  nu = %g,   frequence =%g    amp =  %g\n',freq_rf,V1_rf,V2_rf, freq, freq*846000,amp)

    plot(table_nu,table_freq)
    grid on
    xlim([f1 f2])
    ylim([-13 0])
    txt1=['FREQ=' num2str(freq*846000)];
    txt2=['TUNE=' num2str(freq)];
    text(f1,-1,txt1,'HorizontalAlignment','left','FontSize',18)
    text(f1,-1.8,txt2,'HorizontalAlignment','left','FontSize',18)

    if mem==1 % cumul le signal de bruit
        table_freq0=table_freq0+table_freq;
    end
    pause(2)

end
table_freq0=table_freq0/nl;
