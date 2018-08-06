% calcul efficacité

function  [booeff,anseff]=getefficiency(anscur0)

temp=tango_read_attribute2('LT1/DG/MC','qIct1');        lt1charge=temp.value;
temp=tango_read_attribute2('BOO-C01/DG/DCCT','qExt');   boocharge=-temp.value;
temp=tango_read_attribute2('ANS-C03/DG/DCCT','current');anscur=temp.value;

booeff=boocharge/lt1charge*100;
anseff=(boocharge/0.524)/(anscur-anscur0)*100;

