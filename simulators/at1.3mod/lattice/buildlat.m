function varargout = buildlat(ELIST)
%BUILDLAT places elements from FAMLIST into cell array THERING
% in the order given by ineger arry ELIST
% to be use in Accelerator Toolbox lattice definition files
%
% If an argument out is exptected then buildlat will return the cell array
% of elements and not assign it to THERING.
%
% Eugene Tan 2006-08-16: Added option of returning the cell array rather
%                        than assigning it to THERING.

global FAMLIST

LINE_RING = cell(size(ELIST));
for i=1:length(LINE_RING)
   LINE_RING{i} = FAMLIST{ELIST(i)}.ElemData;
   FAMLIST{ELIST(i)}.NumKids=FAMLIST{ELIST(i)}.NumKids+1;
   FAMLIST{ELIST(i)}.KidsList = [FAMLIST{ELIST(i)}.KidsList i];
end

if nargout > 0
    varargout{1} = LINE_RING;
else
    global THERING
    THERING = LINE_RING;
end




% function buildlat(ELIST)
% %BUILDLAT places elements from FAMLIST into cell array THERING
% % in the order given by ineger arry ELIST
% % to be use in Accelerator Toolbox lattice definition files
% 
% global FAMLIST THERING
% THERING=cell(size(ELIST));
% for i=1:length(THERING)
%    THERING{i} = FAMLIST{ELIST(i)}.ElemData;
%    FAMLIST{ELIST(i)}.NumKids=FAMLIST{ELIST(i)}.NumKids+1;
%    FAMLIST{ELIST(i)}.KidsList = [FAMLIST{ELIST(i)}.KidsList i];
% end