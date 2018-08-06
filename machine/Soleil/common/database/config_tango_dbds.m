% tango_set_attribute_property('HCOR','format','%4.3f')
% tango_set_attribute_property('VCOR','format','%4.3f')
% tango_set_attribute_property('BEND','format','%6.3f')
% 
% % Sextupoles
% for k = 1:10
%     strname = ['S' num2str(k)];
%     tango_set_attribute_property(strname,'format','%6.3f')
% end
% 
% % Quadrupoles
% for k = 1:10
%     strname = ['Q' num2str(k)];
%     tango_set_attribute_property(strname,'format','%6.3f')
% end