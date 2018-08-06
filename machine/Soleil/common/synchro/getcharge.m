% calcul efficacité

function  [q1,q2,n]=getcharge(q1,q2,n)

temp=tango_read_attribute2('LT1/DG/MC','qIct2');        lt1charge=temp.value;
temp=tango_read_attribute2('BOO-C01/DG/DCCT','qExt');   boocharge=-temp.value;
q1=q1+lt1charge ;
q2=q2+(boocharge+0.09);
n=n+1;

