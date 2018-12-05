
function [Bond_damage]=calculateDamage(NumFamMembVector,fail,TOTALNODES,coordinates,disp,bondlist)

% Damage - Calculate the damage (percentage of bonds broken) for every node

% Initialise
Bond_damage=zeros(TOTALNODES,1);
UnbrokenBonds=zeros(TOTALNODES,1);

Totalbonds=size(bondlist,1);

for i=1:Totalbonds
    
    nodei=bondlist(i,1);
    nodej=bondlist(i,2);
    
    % Calculate the number of unbroken bonds attached to every node
    UnbrokenBonds(nodei,1)=UnbrokenBonds(nodei,1)+fail(i);
    UnbrokenBonds(nodej,1)=UnbrokenBonds(nodej,1)+fail(i);

end

Bond_damage(:,1)=1-(UnbrokenBonds./NumFamMembVector(:,1)); % Calculate percentage of broken bonds attached to node i (1 would indicate that all bonds have broken)

% Plot data
DSF=10; % Displacement scale factor
pointsize=1;
figure;
%subplot(1,2,1)
scatter3(coordinates(:,1)+(disp(:,1)*DSF),coordinates(:,2)+(disp(:,2)*DSF),coordinates(:,3)+(disp(:,3)*DSF),pointsize,Bond_damage(:,1))
axis equal
xlabel('x')
ylabel('y')
zlabel('z')
%view([0,-90,0]) % View in 2D
view(30,30)    % View in 3D
grid off
colormap jet 
%colorbar
caxis([0 1])
h = colorbar;
ylabel(h, 'Damage')


% Plot cross section of data
% Seperate scatter data into sub sets
CrossSectionFlag=zeros(TOTALNODES,1);

for i=1:TOTALNODES
    if coordinates(i,2)==(1/150)*4
        CrossSectionFlag(i,1)=1; % Identify nodes located in cross-section
    end        
end

CoordCrossSection=coordinates(:,:);
DispCrossSection=disp(:,:);
BondDamageCrossSection=Bond_damage(:,:);
LogicCondition1 = CrossSectionFlag==0; % Delete node if it is not located in cross-section
CoordCrossSection(LogicCondition1,:)=[];
DispCrossSection(LogicCondition1,:)=[];
BondDamageCrossSection(LogicCondition1,:)=[];

pointsize=1;
figure;
%subplot(1,2,2)
scatter(CoordCrossSection(:,1)+(DispCrossSection(:,1,1)*DSF),CoordCrossSection(:,3)+(DispCrossSection(:,3,1)*DSF),pointsize,BondDamageCrossSection(:,1))
axis equal
xlabel('x')
ylabel('z')
colormap jet 
colorbar
caxis([0 1])
h = colorbar;
ylabel(h, 'Damage')

%     hold on
%     LineX=zeros(1,500)+0.5;
%     LineY=[-0.1:0.001:(0.4-0.001)];
%     scatter(LineX,LineY,pointsize);
end 