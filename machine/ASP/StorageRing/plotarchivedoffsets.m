clear xoffsets yoffsets
for i=1:13
    [xoffsets(:,i) yoffsets(:,i)] = archivedliberaoffsets(i);
end

figure;
subplot(1,2,1)
surf(diff(xoffsets,1,2))
title('xoffsets')
zlabel('nm');
subplot(1,2,2);
surf(diff(yoffsets,1,2))
title('yoffsets');
zlabel('nm');