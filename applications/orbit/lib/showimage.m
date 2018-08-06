function showimage(guitag)
%display accelerator element jpeg file as specified in THERING.elementimage field 
%element index is stored in guitag provided as input

ElementIcons=getappdata(0,'ElementIcons');

index=get(findobj(0,'tag',guitag),'Userdata');           %userdata holds index of element in THERING
picdef = ElementIcons{index}.elementimage;
k=findstr(picdef,'jpg');            %find index in image string

%each image in seperate figure
hb = figure;
img=imread(picdef(1:k-2),'jpeg');     %read image
image(img);                           %load image