function str = structmerge(str1,str2)
%=============================================================
%merge fields of two structures (single field deep)
%Note: for speed str1 is longer than str2
if isempty(str1) str=str2; return; end
if isempty(str2) str=str1; return; end

s1=size(str1);
s2=size(str2);
if ~(s1(2)==s2(2))
    disp('Warning: structure sizes not equal in structmerge');
end

for jj=1:s2(2)               %...loop over all instances
st=str1(jj);
fn2=fieldnames(str2(jj));
  for ii=1:length(fn2);        %...loop over all fields
      fname=fn2{ii};
    if ~isfield(str1(jj),fname);
      val=getfield(str2(jj),fname);
      st=setfield(st,fname,val);
    else
      disp(['Warning in structmerge: common ''' fname ''' field in structures']);
    end
  end
  str(jj)=st;
end   %...end depth of structure
