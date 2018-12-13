function []=plotstrain(COORDINATES,disp,strainTensor)
% Plot strain data

POINT_SIZE=1;
figure;
scatter3(COORDINATES(:,1)+(disp(:,1,1)*10),COORDINATES(:,2)+(disp(:,2,1)*10),COORDINATES(:,3)+(disp(:,3,1)*10),POINT_SIZE,strainTensor(:,1,1))
title('Strain')
axis equal
colormap jet 
colorbar

end