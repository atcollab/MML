function Largeur_MeV = largeur_pourcentage(xdata,ydata,pourcentage)

Itot = trapz(xdata,ydata);
Ipartielle = 0;
j = 0;
i = 1;
size = length(ydata);

while abs(Ipartielle/Itot) < pourcentage
 %while abs(Ipartielle/Itot) < 0.3173  
    if ydata(size-j) < ydata(i)
        Ipartielle = Ipartielle + ydata(size-j)*(xdata(size-j)-xdata(size-j-1));
        j = j+1;
    else
        Ipartielle = Ipartielle + ydata(i)*(xdata(i+1)-xdata(i));
        i = i+1;
    end

end

ifinal = i;
jfinal = j;
Largeur_MeV = xdata(size-jfinal)-xdata(ifinal);
[Y,I] = max(ydata);
dpsurp = 100 * Largeur_MeV / xdata(I);
toto = 1;


% val=sprintf('%2.2f',dpsurp);
% ResultsStr = get(handles.listbox1,'String');
% ResultsStr = {ResultsStr{:},...
%     [],['Largeur du spectre  : (Epeack = ',sprintf('%2.3f',xdata2(I)),' MeV)'],...
%     ['68 % des e- dans ',val,' % de Epeack']}';
% set(handles.listbox1,'String',ResultsStr);