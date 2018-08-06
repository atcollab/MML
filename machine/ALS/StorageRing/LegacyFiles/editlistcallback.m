function editlistcallback
% function editlistcallback

h = get(gco,'userdata');
l=[];m=1;
for i = 1:length(h);
   if get(h(i),'Value') == 1
      l(m,:) = get(h(i),'userdata');
      m=m+1;
   end;
end;
set(gco,'userdata',l);
set(gcf,'userdata',1);









