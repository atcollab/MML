function [Xm,Zm] = getboobpm(nbpmx,iend,istart)



for i=1:nbpmx
    xm = 0;
    zm = 0;
    if (i==23)       % cas de BPM HS
        Xm(i) = 0;Zm(i) = 0;
    else
        a = getbpmrawdata(i,'nodisplay','struct','NoGroup');
        Xm(i) = mean(a.Data.X(istart:iend)); % mm
        Zm(i) = mean(a.Data.Z(istart:iend)); % mm
    end
end
