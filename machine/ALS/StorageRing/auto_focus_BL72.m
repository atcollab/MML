function [pos_vec,SigmaX,SigmaY,focus_pos]= auto_focus_BL72(st,ed,step)
% find the focusing position for beamline7.2 optics
% st: startring position to search focus point
% en: ending position to search focus point
% step: step size for search.
% Changchun Sun, Oct, 2016.


% defalut value for zoom is 10000, focus is 7400.
if nargin~=3
    disp('Please provide three input arguments');
    disp('   auto_focus_BL72(st,end,step)');
    return;
end

if st > ed
  disp('st>end');
  return;
end

if ed > 10000
     disp('Start position >10000');
     return;
end

figure(110)
pos0 = getpvonline('bl72:OptemFocusZLo');
mon0 = getpvonline('bl72:OptemFocusLi');
[cam,im0] = getcam('BL72');
imagesc(im0);
disp('  Please select the spot to focus.....');
a = getrect;
a  = round(a);
xlim = [a(1) a(1)+a(3)];
ylim = [a(2) a(2)+a(4)];
    
 
setpvonline('bl72:OptemFocusZLo',st);
pause(1);
fprintf('  Wait for moving to the starting position '); 
while (getpvonline('bl72:OptemFocusLi') ~= st)
     pause(1);
    fprintf('-'); 
end
fprintf(' OK.\n');

figure(111);
pause(0.5)
figure(112);
subplot(2,1,1);
title('X');
subplot(2,1,2);
title('Y');
figure(113);
subplot(2,1,1);
title('X');
subplot(2,1,2);
title('Y');

pos_vec = st:step:ed;
for  i = 1:length(pos_vec)
    
    setpvonline('bl72:OptemFocusZLo',pos_vec(i));
    fprintf('   -- at position %d \n', pos_vec(i));
    pause(0.5);
    
    pause(0.5);
    while  getpvonline('bl72:OptemFocusLi')~=pos_vec(i)
      pause(0.5);
      %fprintf('-'); 
    end
    
    [cam,im1] = getcam('BL72');
    pause(1)
    im = im1(ylim(1):ylim(2),xlim(1):xlim(2));
    figure(111);
    imagesc(im);
    title(num2str(cam.ImageNumber));
    pause(0.5);
    
    figure(112);
    XProjection = sum(im, 1) / size(im, 1);
    YProjection = sum(im, 2) / size(im, 2);
    subplot(2,1,1);
    xx = xlim(1):xlim(2);
    plot(xx,XProjection);
    [SigmaX(i), CentroidX, AmpX, OffsetX, r, yy] = beam_fit_gaussian(xx(:), XProjection(:));
    hold on;
    plot(xx,yy,'r');
    ylabel('x');
    hold off;
    subplot(2,1,2);
    xx = ylim(1):ylim(2);
    plot(xx,YProjection);
    [SigmaY(i), CentroidY, AmpY, OffsetY, r, yy] = beam_fit_gaussian(xx(:), YProjection(:));
    hold on;
    plot(xx,yy,'r');
    ylabel('y')
    hold off;
    
    
    
    figure(113)
    subplot(2,1,1);
    plot(pos_vec(i),SigmaX(i),'bo-');
    xlabel('Focus position');
    ylabel('\sigma_x (pixel)')
    hold on;
    subplot(2,1,2);
    plot(pos_vec(i),SigmaY(i),'bo-');
    xlabel('Focus position');
    ylabel('\sigma_y (pixel)')
    hold on;
    
end

figure(113);

[p1,s1] = polyfit(pos_vec,SigmaX,2);
subplot(2,1,1);
plot(pos_vec,polyval(p1,pos_vec,'r'));
title(['focus: ', num2str(-round(p1(2)/p1(1)/2))]);
xfocal = round(-p1(2)/p1(1)/2);

[p2,s2] = polyfit(pos_vec,SigmaY,2);
figure(113);
subplot(2,1,2);
plot(pos_vec,polyval(p2,pos_vec,'r'));
title(['focus: ', num2str(-round(p2(2)/p2(1)/2))]);
yfocal = round(-p2(2)/p2(1)/2);

%focus_pos = round(-p1(2)/p1(1)/2)+round(-p2(2)/p2(1)/2);
%focus_pos = round(focus_pos/2)
focus_pos = round((xfocal+yfocal)/2);

ButtonName = questdlg('Which focal point to set?','Focal point question',['X:',num2str(xfocal)],['Y:',num2str(yfocal)],'User Define','User Define');
switch ButtonName,
   case ['X:',num2str(xfocal)],
      disp([' Set the focus to X ',num2str(xfocal)]);
      setpvonline('bl72:OptemFocusZLo',xfocal);
      while  getpvonline('bl72:OptemFocusLi')~=xfocal
         pause(0.5);
         fprintf('-'); 
      end
      fprintf('done.\n');
    
    case ['Y:',num2str(yfocal)],
      disp([' Set the focus to Y ',num2str(yfocal)]);
      setpvonline('bl72:OptemFocusZLo',yfocal);
      while  getpvonline('bl72:OptemFocusLi')~=yfocal
         pause(0.5);
         fprintf('-'); 
      end
      fprintf('done.\n');
      
    case 'User Define',
      disp(' Please set the focus manually at BL72 edm panel');
   end % switch
