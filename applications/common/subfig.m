function h = subfig(a, b, c, h)
%SUBFIG - Pops the current axes into a separate figure
%  h = subfig(s1, s2, s3, h_fig)

%  Written by Greg Portmann


if nargin < 3
    error('3 inputs required');
end
if nargin < 4
    h = figure;
else
    h = figure(h);
end

s = get(0, 'ScreenSize');

xbuf = .02 * s(3);
ybuf = .06 * s(4);

CommandWindowUnits = get(0,'Units');
FigUnits = get(h,'Units');
set(h,'Units', CommandWindowUnits);


Nx = 5;
Ny = 2;
if a == 1 && b == 1
    % For big screens this gets huge
    %set(h, 'Position',[Nx*xbuf  Ny*ybuf  s(3)-2*Nx*xbuf s(4)-2*Ny*ybuf]);
    
    % Inches
    Border = .15;
    WidthMaxInches = 8;
    HeightMaxInches = 11.5;
    set(0, 'Units','Inches');
    s = get(0, 'ScreenSize');
    
    if s(3) < WidthMaxInches
        WidthMaxInches = s(3)-2*Border;
    end
    if s(4) < HeightMaxInches
        HeightMaxInches = s(4)-2*Border-1.5;  % Menu and title bar need some extra room
    end

    HCenter = s(3)/2;
    VCenter = s(4)/2;
    set(h,'Units', 'Inches');
    set(h, 'Position', [HCenter-WidthMaxInches/2  VCenter-HeightMaxInches/2-.25 WidthMaxInches HeightMaxInches]);

    % Restore the command window units
    set(0, 'Units', CommandWindowUnits);

elseif a == 2 && b ==2
    if c == 1
        set(h, 'Position',[       xbuf    s(4)/2+.5*ybuf  s(3)/2-1*xbuf s(4)/2-2*ybuf]);
    elseif c == 2
        set(h, 'Position',[s(3)/2+xbuf/2  s(4)/2+.5*ybuf  s(3)/2-1*xbuf s(4)/2-2*ybuf]);
    elseif c == 3
        set(h, 'Position',[       xbuf              ybuf   s(3)/2-1*xbuf s(4)/2-2*ybuf]);
    elseif c == 4
        set(h, 'Position',[s(3)/2+xbuf/2            ybuf   s(3)/2-1*xbuf s(4)/2-2*ybuf]);
    end
elseif a == 1 && b ==2
    if c == 1
        set(h, 'Position',[       xbuf    Ny*ybuf  s(3)/2-1*xbuf s(4)-2*Ny*ybuf]);
    elseif c == 2
        set(h, 'Position',[s(3)/2+xbuf/2  Ny*ybuf  s(3)/2-1*xbuf s(4)-2*Ny*ybuf]);
    elseif c == 3
        set(h, 'Position',[       xbuf    Ny*ybuf  s(3)/2-1*xbuf s(4)-2*Ny*ybuf]);
    elseif c == 4
        set(h, 'Position',[s(3)/2+xbuf/2  Ny*ybuf  s(3)/2-1*xbuf s(4)-2*Ny*ybuf]);
    end
end

set(h,'Units', FigUnits);

