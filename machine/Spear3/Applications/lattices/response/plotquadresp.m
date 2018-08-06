clear all;
indx=1:90;
spear3quadresp;
ibpm  = FINDCELLS(THERING, 'FamName', 'BPM');
spos=findspos(THERING,ibpm);

dwell=1;
x0=60; dx=170; y0=50; dy=120;
delx=200; dely=150;

load qxmat;
qxmat=1000*qxmat;
load qymat;
qymat=1000*qymat;


%
%now calculate rms disturbance due to random quadrupole distrubutions
%gain for each family is sqrt(sum(r12*r12)) across a row of matrix
%qx/ymat matrices have 90 rows (bpms) 130 columns (family groups)
%first compute individual family gains (all quads in family move independently)
%then compute gain for all quadrupoles (all qauds in ring move independently)
%
%next compute girder gain (all girders move independently)
%finally compute cell gain (all cells move independently)

%===================================
% RMS quad family gains - HORIZONTAL
%===================================
%plot RMS orbit distortion when all quadrupoles move with same sigma
uicontrol('Style','pushbutton',...	
   'Position',[100 300 500 100],...
   'BackgroundColor',[1 1 1],...
   'String','Quad family gains - horizontal',...
   'FontSize',20,'FontWeight','demi');

pause;
clf;

matindx=1;
for ii=1:3         %index on rows
for jj=1:3         %index on columns
hh=axes('Units','pixels',...
	'Color', [1 1 1],'Box','on','NextPlot','add',...
	'Position',[x0+(jj-1)*delx y0+(3-ii)*dely dx dy]);
set(hh,'YLim',[0,25],'Xlim',[0,235],...
'Color',[1 1 1],'NextPlot','add','Visible','on',...
'FontSize',6);
plotindx=(ii-1)*3+jj;
istart=matindx;
matindx=matindx+magindx{plotindx}.NumKids;
istop=matindx-1;
line('XData',spos,'YData',...
sqrt(diag(qxmat(:,istart:istop)*qxmat(:,istart:istop)') ),'Color','r');
end    %end jj
end    %end ii
pause;

%===================================
% RMS dipole family gains - HORIZONTAL
%===================================
%plot RMS orbit distortion when all dipoles move with same sigma
uicontrol('Style','pushbutton',...	
   'Position',[100 300 500 100],...
   'BackgroundColor',[1 1 1],...
   'String','Dipole family gains - horizontal',...
   'FontSize',20,'FontWeight','demi');

pause;
clf;

clf;

ii=1;
for jj=1:2         %index on columns
hh=axes('Units','pixels',...
	'Color', [1 1 1],'Box','on','NextPlot','add',...
	'Position',[x0+(jj-1)*delx y0+(3-ii)*dely dx dy]);
set(hh,'YLim',[0,25],'Xlim',[0,235],...
'Color',[1 1 1],'NextPlot','add','Visible','on',...
'FontSize',6);
plotindx=jj;
istart=matindx;   %begins at 95 from above
matindx=matindx+magindx{9+plotindx}.NumKids;   %dipoles are families 10,11
istop=matindx-1;
line('XData',spos,'YData',...
sqrt(diag(qxmat(:,istart:istop)*qxmat(:,istart:istop)') ),'Color','r');
end    %end jj
pause;

%========================================
% RMS gains with all magnets - HORIZONTAL
%========================================
%plot RMS orbit distortion when all magnets move with same sigma
uicontrol('Style','pushbutton',...	
   'Position',[100 300 500 100],...
   'BackgroundColor',[1 1 1],...
   'String','Total magnet gains - horizontal',...
   'FontSize',20,'FontWeight','demi');

pause;
clf;

matindx=1;
for ii=1:1         %index on rows
for jj=1:1         %index on columns
hh=axes('Units','pixels',...
	'Color', [1 1 1],'Box','on','NextPlot','add',...
	'Position',[x0 y0 580 400]);
set(hh,'YLim',[0,50],'Xlim',[0,235],...
'Color',[1 1 1],'NextPlot','add','Visible','on',...
'FontSize',6);
line('XData',spos,'YData',...
sqrt(diag(qxmat*qxmat') ),'Color','r');
end    %end jj
end    %end ii
%	'Position',[x0+(jj-1)*delx y0+(3-ii)*dely dx dy]);

pause;

%===================================
% RMS quad family gains - VERTICAL
%===================================
%plot RMS orbit distortion when all quadrupoles move with same sigma
uicontrol('Style','pushbutton',...	
   'Position',[100 300 500 100],...
   'BackgroundColor',[1 1 1],...
   'String','Quad family gains - vertical',...
   'FontSize',20,'FontWeight','demi');

pause;
clf;

matindx=1;
for ii=1:3         %index on rows
for jj=1:3         %index on columns
hh=axes('Units','pixels',...
	'Color', [1 1 1],'Box','on','NextPlot','add',...
	'Position',[x0+(jj-1)*delx y0+(3-ii)*dely dx dy]);
set(hh,'YLim',[0,25],'Xlim',[0,235],...
'Color',[1 1 1],'NextPlot','add','Visible','on',...
'FontSize',6);
plotindx=(ii-1)*3+jj;
istart=matindx;
matindx=matindx+magindx{plotindx}.NumKids;
istop=matindx-1;
line('XData',spos,'YData',...
sqrt(diag(qymat(:,istart:istop)*qymat(:,istart:istop)') ),'Color','r');
end    %end jj
end    %end ii
pause;

%===================================
% RMS dipole family gains - VERTICAL
%===================================
%plot RMS orbit distortion when all dipoles move with same sigma
uicontrol('Style','pushbutton',...	
   'Position',[100 300 500 100],...
   'BackgroundColor',[1 1 1],...
   'String','Dipole family gains - vertical',...
   'FontSize',20,'FontWeight','demi');

pause;
clf;

ii=1;
for jj=1:2         %index on columns
hh=axes('Units','pixels',...
	'Color', [1 1 1],'Box','on','NextPlot','add',...
	'Position',[x0+(jj-1)*delx y0+(3-ii)*dely dx dy]);
set(hh,'YLim',[0,25],'Xlim',[0,235],...
'Color',[1 1 1],'NextPlot','add','Visible','on',...
'FontSize',6);
plotindx=jj;
istart=matindx;   %begins at 95 from above
matindx=matindx+magindx{9+plotindx}.NumKids;   %dipoles are families 10,11
istop=matindx-1;
line('XData',spos,'YData',...
sqrt(diag(qymat(:,istart:istop)*qymat(:,istart:istop)') ),'Color','r');
end    %end jj
pause;

%========================================
% RMS gains with all magnets - VERTICAL
%========================================
%plot RMS orbit distortion when all magnets move with same sigma
uicontrol('Style','pushbutton',...	
   'Position',[100 300 500 100],...
   'BackgroundColor',[1 1 1],...
   'String','Total gains - vertical',...
   'FontSize',20,'FontWeight','demi');

pause;
clf;

matindx=1;

for ii=1:1         %index on rows
for jj=1:1         %index on columns
hh=axes('Units','pixels',...
	'Color', [1 1 1],'Box','on','NextPlot','add',...
	'Position',[x0 y0 580 400]);
set(hh,'YLim',[0,50],'Xlim',[0,235],...
'Color',[1 1 1],'NextPlot','add','Visible','on',...
'FontSize',6);
line('XData',spos,'YData',...
sqrt(diag(qymat*qymat') ),'Color','r');
end    %end jj
end    %end ii
	%'Position',[x0+(jj-1)*delx y0+(3-ii)*dely dx dy]);

pause;

%========================================================
% =========  HORIZONTAL FIRST QUAD ALIGNMENTS ===========
%========================================================
%plot COD for first quadrupole only in each family
clf;
uicontrol('Style','pushbutton',...	
   'Position',[100 300 500 100],...
   'BackgroundColor',[1 1 1],...
   'String','Horizontal Plane: First Quads',...
   'FontSize',20,'FontWeight','demi');

pause;
clf;

matindx=1;
for ii=1:3         %index on rows
for jj=1:3         %index on columns
hh=axes('Units','pixels',...
	'Color', [1 1 1],'Box','on','NextPlot','add',...
	'Position',[x0+(jj-1)*delx y0+(3-ii)*dely dx dy]);
set(hh,'YLim',[-10,10],'Xlim',[0,235],...
'Color',[1 1 1],'NextPlot','add','Visible','on',...
'FontSize',6);
plotindx=(ii-1)*3+jj;
line('XData',spos,'YData',qxmat(:,matindx),'Color','r');
matindx=matindx+magindx{plotindx}.NumKids;
%pause(dwell);
end    %end jj
end    %end ii

pause;

%========================================================
% =========  HORIZONTAL FIRST DIPOLE ALIGNMENTS =========
%========================================================
%plot COD for first dipole only in each family
clf;
uicontrol('Style','pushbutton',...	
   'Position',[100 300 500 100],...
   'BackgroundColor',[1 1 1],...
   'String','Horizontal Plane: First Dipoles',...
   'FontSize',20,'FontWeight','demi');
pause;
clf;

ii=1;
for jj=1:2         %index on columns
hh=axes('Units','pixels',...
	'Color', [1 1 1],'Box','on','NextPlot','add',...
	'Position',[x0+(jj-1)*delx y0+(3-ii)*dely dx dy]);
set(hh,'YLim',[-10,10],'Xlim',[0,235],...
'Color',[1 1 1],'NextPlot','add','Visible','on',...
'FontSize',6);
plotindx=jj;
line('XData',spos,'YData',qxmat(:,matindx),'Color','r');
matindx=matindx+magindx{9+plotindx}.NumKids;
%pause(dwell);
end    %end jj

pause;

%======================================================
% =========  VERTICAL QUAD ALIGNMENTS =================
%======================================================
%plot COD for first quadrupole only in each family
clf;
uicontrol('Style','pushbutton',...	
   'Position',[100 300 500 100],...
   'BackgroundColor',[1 1 1],...
   'String','Vertical Plane: First Quads',...
   'FontSize',20,'FontWeight','demi');
pause;
clf;

matindx=1;
for ii=1:3         %index on rows
for jj=1:3         %index on columns
hh=axes('Units','pixels',...
	'Color', [1 1 1],'Box','on','NextPlot','add',...
	'Position',[x0+(jj-1)*delx y0+(3-ii)*dely dx dy]);
set(hh,'YLim',[-10,10],'Xlim',[0,235],...
'Color',[1 1 1],'NextPlot','add','Visible','on',...
'FontSize',6);
plotindx=(ii-1)*3+jj;
line('XData',spos,'YData',qymat(:,matindx),'Color','r');
matindx=matindx+magindx{plotindx}.NumKids;
%pause(dwell);
end    %end jj
end    %end ii
pause;

%========================================================
% =========  VERTICAL FIRST DIPOLE ALIGNMENTS ===========
%========================================================
%plot COD for first dipole only in each family
clf;
uicontrol('Style','pushbutton',...	
   'Position',[100 300 500 100],...
   'BackgroundColor',[1 1 1],...
   'String','Vertical Plane: First Dipoles',...
   'FontSize',20,'FontWeight','demi');
pause;
clf;

ii=1;
for jj=1:2         %index on columns
hh=axes('Units','pixels',...
	'Color', [1 1 1],'Box','on','NextPlot','add',...
	'Position',[x0+(jj-1)*delx y0+(3-ii)*dely dx dy]);
set(hh,'YLim',[-10,10],'Xlim',[0,235],...
'Color',[1 1 1],'NextPlot','add','Visible','on',...
'FontSize',6);
plotindx=jj;
line('XData',spos,'YData',qymat(:,matindx),'Color','r');
matindx=matindx+magindx{9+plotindx}.NumKids;
end    %end jj

pause;
clf;

