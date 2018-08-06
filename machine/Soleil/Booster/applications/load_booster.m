% set booster setup

listefile = dir('boo_*') ;
comment={};
for i=1:length(listefile)
  load(listefile(i).name);
  comment=strvcat(comment , boo.comment);
end
comment


