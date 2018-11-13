% Plot displacement of beam under analysis

function Displacement(disp,coordinates,MaterialFlag)

% Plot displacement
for i=1:1
    % Seperate scatter data into sub sets - The first set represents concrete nodes
    % and the second set represents steel nodes
    DispConcrete=disp(:,:,i);
    CoordConcrete=coordinates(:,:);
    LogicCondition1 = MaterialFlag(:,1)==1; % If node is steel, delete from concrete sub set
    DispConcrete(LogicCondition1,:)=[];
    CoordConcrete(LogicCondition1,:)=[];
    
    DispSteel=disp(:,:,i);
    CoordSteel=coordinates(:,:);
    LogicCondition2 = MaterialFlag(:,1)==0; % If node is concrete, delete from steel sub set
    DispSteel(LogicCondition2,:)=[];
    CoordSteel(LogicCondition2,:)=[];
    
    figure(2)
    pause(0.05)
    
    % Displacement scale factor
    DSF=1;
    
    % Concrete
    sz1=5;
    conc=scatter3((CoordConcrete(:,1)+(DispConcrete(:,1)*DSF)),(CoordConcrete(:,2)+(DispConcrete(:,2)*DSF)),(CoordConcrete(:,3)+(DispConcrete(:,3)*DSF)),sz1,'b','filled');
    conc.MarkerFaceAlpha=0.2;
    hold on
    % Steel
    scatter3((CoordSteel(:,1)+(DispSteel(:,1)*DSF)),(CoordSteel(:,2)+(DispSteel(:,2)*DSF)),(CoordSteel(:,3)+(DispSteel(:,3)*DSF)),sz1,'r','filled')
    axis equal
    xlabel('x')
    ylabel('y')
    zlabel('z')
    view(30,30)
    grid off
    %title(['Time step:' ,num2str(i),],'Color','k')
    hold off
    
    
    % Plot cross-section of beam
    sz2=100;
    figure(3)
    scatter(CoordConcrete(:,2),CoordConcrete(:,3),sz2,'b','filled');
    hold on
    scatter(CoordSteel(:,2),CoordSteel(:,3),sz2,'g','filled')
    hold off
    
    
end

end 