% test PM event

cur_seuil=100;



temp=tango_read_attribute2('ANS-C03/DG/DCCT','current');cur=temp.value;
n=0;
while (cur > cur_seuil)
    temp=tango_read_attribute2('ANS-C03/DG/DCCT','current');cur=temp.value;
end
tango_command_inout('ANS/SY/CENTRAL','FirePostMortemEvent')