function rmsFit = qualFit(x1,y1,co)
%QUALFIT - Calcule l'écart type de la distance entre la parabole calculée
%et les données expériementales
%
%  INPUTS
%  1  x1
%  2. x2
%  3. co
%
%  OUPUTS
%  1. rmsfit
%
%  See Also bba_last

%co=polyfit(x1,y1,2)

for i=1:length(x1),
    cub(1) = 2*co(1)^2;
    cub(2) = 3*co(1)*co(2);
    cub(3) = co(2)^2+2*co(1)*(co(3)-y1(i))+1;
    cub(4) = co(2)*(co(3)-y1(i))-x1(i);

    solcub = roots(cub);

    [res,ind] = sort([abs(solcub(1)-x1(i)) abs(solcub(2)-x1(i)) abs(solcub(3)-x1(i))]);

    xres = solcub(ind(1));
    yres = parabole(x1(i),co);
    x1(i);
    y1(i);

    dist(i) = sqrt((x1(i)-xres)^2+(y1(i)-yres)^2);
end

dist;

rmsFit = std(dist);
