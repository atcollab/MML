function handles=ElementIconPatch(axes_handle,elemind,element_callback)
%create patches for element icons
%start with first element of THERING
%axes_handle contains handle of desired axes
%elemind contains indices of elements to be used in THERING


ElementIcons=getappdata(0,'ElementIcons');
%initialize patches for icons
num=15;
nicon=2*num;
for ii=1:nicon
    jj=elemind(ii);
    xpos=ii/(nicon+1);    %...SYS.ahpos has x limits 0 to 1
    handles(ii)=patch('parent',axes_handle,...
    'XData',xpos+ElementIcons{jj}.xpts,...
    'YData',ElementIcons{jj}.ypts,...
    'FaceColor',ElementIcons{jj}.color,...
    'ButtonDownFcn',element_callback,...
    'Userdata',jj);
end

handles=handles(:);