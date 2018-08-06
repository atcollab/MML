%vannes

vannes=tango_get_db_property('anneau','vanne_secteur');
for i=1:48; 
    state= tango_command_inout2(vannes{i},'State'); 
    fprintf('vannes %d = %s\n',i,state)
end