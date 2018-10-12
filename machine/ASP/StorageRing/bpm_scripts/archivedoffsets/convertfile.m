load archivedoffsets.mat

for i=1:length(archivedoffsets.xcomment)
    clear offsetdata
    offsetdata.xoffsets = archivedoffsets.xoffsets(:,i);
    offsetdata.yoffsets = archivedoffsets.yoffsets(:,i);
    offsetdata.comment = sprintf('x: %s   y: %s',...
        archivedoffsets.xcomment{i}, archivedoffsets.ycomment{i});
    offsetdata.datatime = archivedoffsets.xdatatimestr{i};

    prefix = sprintf('archivedoffsets_%04d',i);
    try
        t = datenum(offsetdata.datatime,'dd-mmm-yyyy HH:MM:SS');
        fname = appendtimestamp(prefix,datevec(t));
    catch
        fname = prefix;
    end
    
    save(fname,'offsetdata');
end