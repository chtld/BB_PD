function[]=plotbonddamage(coordinates,disp,bondDamage,DX)

DSF=10;         % Displacement scale factor
POINT_SIZE=1;   % Size of plotted point in figure

%% 3D view - Bond damage
figure;
scatter3(coordinates(:,1)+(disp(:,1)*DSF),coordinates(:,2)+(disp(:,2)*DSF),coordinates(:,3)+(disp(:,3)*DSF),POINT_SIZE,bondDamage(:,1))
axis equal
xlabel('x')
ylabel('y')
zlabel('z')
%view([0,-90,0])    % View in 2D
view(30,30)         % View in 3D
grid off
colormap jet 
caxis([0 1])
h = colorbar;
ylabel(h, 'Damage')

%% 2D cross-section view - plot cross section of damage data

crossSectionFlag=(coordinates(:,2)==DX*4)==1;   % Identify and flag nodes located in cross-section

coordCrossSection=coordinates(:,:);
dispCrossSection=disp(:,:);
bondDamageCrossSection=bondDamage(:,:);
logicCondition1 = crossSectionFlag==0;          % Delete node if it is not located in cross-section (flag==0)
coordCrossSection(logicCondition1,:)=[];
dispCrossSection(logicCondition1,:)=[];
bondDamageCrossSection(logicCondition1,:)=[];

figure;
scatter(coordCrossSection(:,1)+(dispCrossSection(:,1,1)*DSF),coordCrossSection(:,3)+(dispCrossSection(:,3,1)*DSF),POINT_SIZE,bondDamageCrossSection(:,1))
axis equal
xlabel('x')
ylabel('z')
colormap jet 
colorbar
caxis([0 1])
h = colorbar;
ylabel(h, 'Damage')

end