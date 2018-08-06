clear g
clear f
clear Freq
%-- OPEN Connection --%
g=visa('ni','GPIB0::1::INSTR'); %-- GPIB0 Address 1 use NI-GPIB vendor --%
fopen(g);

%-- Send Command for Config. --%
fprintf(g,'SW500MSRB1KZVB1KZ'); %-- Sweep 500 ms RBW 1kHz VBW 1 kHz --%
fprintf(g,'RE10DMMGTL40DM'); %-- Ref.Level -10 dBm TG. Level -40 dBm --%
% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Get_current_pushbutton.

%-- Find f0 and fs --%
%fprintf(g,'MOSHARFRFA118.008MZFB119.8518MZ'); %-- Marker Off,Average Off, Free Run, Start 118.008 MHz Stop 119.8518 MHz --%
fprintf(g,'MOSHARFRCF118.008MZSP60KZ'); %-- Marker Off,Average Off, Free Run, Center Freq. 118.008 MHz Span Freq. 60 kHz --%
pause(3);
fprintf(g,'AR16HZ'); %-- Average 64 --%
pause(11); %-- Waiting on M/C Average Observe from Actual control (can adj.) --%
fprintf(g,'SI'); %-- Single Start:Stop Average --%
pause(1);
fprintf(g,'MOSHPS'); %--Marker Off,Enter mode Next Peak Search --%
fprintf(g,'2'); %-- Detect only Positive Peak --%
fprintf(g,'MF'); %-- Query Marker Frequency --%
d=fscanf(g); %-- Read --%
f(1,1)=sscanf(d,'%*s %f %*s'); %-- Keep it in f variable column 1--%
fprintf(g,'MFLD73C40E0099DC'); %-- Query Maker level --%
l=fscanf(g); %-- Read --%
f(1,2)=sscanf(l,'%f %*s'); %-- Keep it in f variable column 2 --%
fprintf(g,'PSMF'); %-- Next Peak search and Query Marker Frequency --%
d=fscanf(g);
f(2,1)=sscanf(d,'%*s %f %*s');
fprintf(g,'MFLD73C40E0099DC');
l=fscanf(g);
f(2,2)=sscanf(l,'%f %*s');
i=2;
while f(i,1)~=f(i-1,1) %-- Query until Frequency not change --%
    i=i+1;
    fprintf(g,'PSMF');
    d=fscanf(g);
    f(i,1)=sscanf(d,'%*s %f %*s');
    fprintf(g,'MFLD73C40E0099DC');
    l=fscanf(g);
    f(i,2)=sscanf(l,'%f %*s');
end
fprintf(g,'MK'); %-- EXIT Neak Peak Search Mode --%
f(i,:)=[]; %-- Delete Last row --%
Freq=sortrows(f,[1 2]); %-- Sort data by Frequency then Level --%
[c,s]=max(Freq(:,2)); %-- Find Max Level and Index --%

%%% f0 is the RF frequency %%%
f0=Freq(s,1);%-- Defind f0 as Frequency at Max Level index -%
fnew=Freq(s+1:i-1,:);
Freq2=sortrows(fnew,[1 2]);
[c,s]=max(Freq2(:,2));

%%% fs is the synchrotron frequency %%%
fs=Freq2(s,1);
fclose(g);
clear g;