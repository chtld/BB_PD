% Damage - Percentage of bonds broken

function [Bond_damage]=Damage(NumFamMembVector,fail,Totalnodes,coordinates,disp)

% Initialise
Bond_damage=zeros(Totalnodes,1);

  % Node under analysis
    for i=1:Totalnodes
        % Initialise fail_counter
        fail_counter=0;
        % All nodes within Node 'i' sphere of influence
        for j=1:NumFamMembVector(i,1)
            % Count number of failed bonds
            fail_counter=fail_counter+fail(i,j);
        end
        % Calculate percentage of bonds that remain unbroken
        Bond_damage(i,1)=1-(fail_counter/NumFamMembVector(i,1));
        
    end
    
    
    % Displacement scale factor
    DSF=10;
    
    % Plot data
    pointsize=1;
    figure(1)
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
    CrossSectionFlag=zeros(Totalnodes,1);
    
    for i=1:Totalnodes
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
    figure(11)
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