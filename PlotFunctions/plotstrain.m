function []=plotstrain(coordinates,disp,straintensor)
% Plot strain data

POINT_SIZE=1;
figure;
scatter3(coordinates(:,1)+(disp(:,1,1)*10),coordinates(:,2)+(disp(:,2,1)*10),coordinates(:,3)+(disp(:,3,1)*10),POINT_SIZE,straintensor(:,1,1))
title('Strain')
axis equal
colormap jet 
colorbar

end