function showfamilydata
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/showfamilydata.m 1.2 2007/03/02 09:17:27CST matiase Exp  $
% ----------------------------------------------------------------------------------------------

% families=getfamilylist;
% 
% for ii=1:size(families,1)
%     familytype=getfamilydata(families(ii,:),'FamilyType');
%     if strcmpi(familytype,'BEND') | strcmpi(familytype,'QUAD') | strcmpi(familytype,'SEXT') | strcmpi(familytype,'HCM') | strcmpi(familytype,'VCM')
%         fprintf('%10s %5d %5d %10.3f %10.3f %12.3f %10.3f %10.3f %10.3f\n',families(ii,:),tavail(ii),tfit(ii),ref(ii),des(ii),babs(ii),act(ii),fit(ii),wt(ii));
%     end
% end    
families=getfamilylist;

for ii=1:size(families,1)
    familytype=getfamilydata(families(ii,:),'FamilyType');
    if strcmpi(familytype,'BEND') | strcmpi(familytype,'QUAD') | strcmpi(familytype,'SEXT') |...
    strcmpi(familytype,'HCM') | strcmpi(familytype,'VCM')
    
    fprintf('%10s %5d %5d %10.3f %10.3f %12.3f %10.3f %10.3f %10.3f\n',...
    families(ii,:),tavail(ii),tfit(ii),ref(ii),des(ii),babs(ii),act(ii),fit(ii),wt(ii));
end
%sprintf('%s [%d,%d]', ListName, List(k,1), List(k,2));
end

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/showfamilydata.m  $
% Revision 1.2 2007/03/02 09:17:27CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
