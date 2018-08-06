function UpdateIcons(SYS, BPM)

%update icons in display bar
ElementIcons=getappdata(0,'ElementIcons');

%define number of icons to display
num=size(SYS.elhndl,1)/2;    %defined as x2 in elementiconinit
nicon=2*num;
len=length(SYS.elemind);

%get BPM index in the AT lattice
if     SYS.plane==1
indx=BPM(1).ATindex(BPM(1).id);
elseif SYS.plane==2
indx=family2atindex('BPMy',BPM(2).id);
end

%locate where BPM is in drift-free list of elements
indx=find(SYS.elemind==indx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%if BPM index closer to 'num' from beginning, set it to 'num+1'
if indx-num<0
  indx=num+1;
end

%if BPM index closer to 'num' from end, set it to 'len-num'
if indx+num>len
  indx=len-num+1;
end

for ii=1:nicon   
xpos=(ii-0.5)/(nicon+1);    %...SYS.ahpos has x limits 0 to 1
ind=SYS.elemind(indx+ii-(num+1));        %...back up from BPM index
set(SYS.elhndl(ii),     'XData', xpos+ElementIcons{ind}.xpts,...
                        'YData', ElementIcons{ind}.ypts,...
                        'FaceColor', ElementIcons{ind}.color,...
                        'UserData',ind);             %Userdata stores element index in THERING
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %if BPM index closer to 'num' from beginning, set it to 'num+1'
% % if indx-num<0
% %   indx=num+1;
% % end
% % 
% % %if BPM index closer to 'num' from end, set it to 'len-num'
% % if indx+num>len
% %   indx=len-num+1;
% % end
% % 
% % for ii=1:nicon   
% % xpos=(ii-0.5)/(nicon+1);    %...SYS.ahpos has x limits 0 to 1
% % ind=indx+ii-(num+1);        %...back up from BPM index
% % set(SYS.elhndl(ii),     'XData', xpos+THERING{ind}.xpts,...
% %                         'YData', THERING{ind}.ypts,...
% %                         'FaceColor', THERING{ind}.color,...
% %                         'UserData',ind);             %Userdata stores element index in THERING
% % end
% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % %alternative method that does not show drift sections
% % % %indx=BPM index
% % % %num=number of elements to display
% % % 
% % % ibehind=zeros(num,1);  %pre-allocate
% % % iahead=zeros(num,1);
% % % 
% % % %====================================
% % % %locate non-drift elements behind BPM
% % % %====================================
% % % %look behind, stop if encounter beginning of ring
% % % jj=0;  ii=indx;
% % % while jj<=num-1 && ii>1
% % %     ii=ii-1;
% % %         if ~strcmp(THERING{ii}.PassMethod,'DriftPass');
% % %             jj=jj+1;
% % %             ibehind(jj)=ii;
% % %         end
% % % end
% % % ibehind=flipud(ibehind(find(ibehind)));
% % % 
% % % %enlarge range ahead if needed
% % % if length(ibehind)<num-1
% % %     num=2*num-length(ibehind);
% % % end
% % %     
% % % %======================================
% % % %locate non-drift elements ahead of BPM
% % % %======================================
% % % jj=0;  ii=indx;
% % % while jj<=num-2 && ii<len   %take one less ahead of BPM so BPM can be in handle array
% % %     ii=ii+1;
% % %         if ~strcmp(THERING{ii}.PassMethod,'DriftPass');
% % %             jj=jj+1;
% % %             iahead(jj)=ii;
% % %         end
% % % end
% % % iahead=iahead(find(iahead));
% % % 
% % % %enlarge range behind if needed
% % % if length(iahead)<num-1
% % %     num=2*num-length(iahead);
% % % 
% % % jj=0;  ii=indx; ibehind=[];
% % % while jj<=num-2 && ii>1
% % %     ii=ii-1;
% % %         if ~strcmp(THERING{ii}.PassMethod,'DriftPass');
% % %             jj=jj+1;
% % %             ibehind(jj)=ii;
% % %         end
% % % end
% % % ibehind=flipud(ibehind(find(ibehind)));
% % % end
% % % 
% % % elem=[ibehind(:); indx; iahead(:)];
% % % 
% % % for ii=1:length(elem)   
% % % xpos=(ii-0.5)/(nicon+1);    %...SYS.ahpos has x limits 0 to 1
% % % ind=elem(ii)    ;        %...behind BPM index
% % % set(SYS.elhndl(ii),     'XData', xpos+THERING{ind}.xpts,...
% % %                         'YData', THERING{ind}.ypts,...
% % %                         'FaceColor', THERING{ind}.color,...
% % %                         'UserData',ind);             %Userdata stores element index in THERING
% % % end


