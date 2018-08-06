fid = fopen('TEST.bpm','r+');
fid2 = fopen('TLS.bpm','w');
tline = fgetl(fid);
fprintf(fid2,'%s\n',tline);
tline = fgetl(fid);
fprintf(fid2,'%s\n',tline);
tline = fgetl(fid);
i = 1;
while ischar(tline)
% disp(tline);
if  isempty(tline)==0
    DataX = sprintf('%.6f',ConfigMonitor.BPMx.Monitor.Data(i));
    DataY = sprintf('%.6f',ConfigMonitor.BPMy.Monitor.Data(i));
    spos = getspos('BPMx');
    fprintf(fid2,'%s\n',[DataX,' ',DataY,' ',sprintf('%.6f',spos(i))]);
    i = i+1;
else
    fprintf(fid2,'%s\n',tline);
end
tline = fgetl(fid);
end
fclose(fid);
fclose(fid2);