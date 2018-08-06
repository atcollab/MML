function data = sirius_bo_family_data(the_ring)

data.b.nr_segs   = 30;

data.qf.nr_segs  = 2;
data.qd.nr_segs  = 1;

data.sd.nr_segs  = 1;
data.sf.nr_segs  = 1;

data.bpm.nr_segs = 1;
data.ch.nr_segs  = 1;
data.cv.nr_segs  = 1;

fams = fields(data);
for i=1:length(fams)
    data.(fams{i}).ATIndex = [];
end
for i=1:length(the_ring)
    Fam = the_ring{i}.FamName;
    if any(strcmp(fams,Fam))
        data.(Fam).ATIndex = [data.(Fam).ATIndex; i];
    end
end
for i=1:length(fams)
    data.(fams{i}).ATIndex = reshape(data.(fams{i}).ATIndex,data.(fams{i}).nr_segs,[])';
end
