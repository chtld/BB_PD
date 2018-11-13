% Maximum bond stretch for every node

function Stretch(Stretch,coordinates,disp)


MaxStretch=max(Stretch,[],2);
%MinStretch=min(Stretch,[],2);
AbsoluteStretch=abs(Stretch);
AbsoluteStretch=max(AbsoluteStretch,[],2);

% for i=1:90000
%    if abs(MaxStretch(i,1))>abs(MinStretch(i,1))
%        MinMax(i,1)=MaxStretch(i,1);
%    else
%        MinMax(i,1)=MinStretch(i,1);
%    end 
% end

% Displacement scale factor
DSF=0;


% Plot data
pointsize=1;
figure(12)
scatter3(coordinates(:,1)+(disp(:,1,1)*DSF),coordinates(:,2)+(disp(:,2,1)*DSF),coordinates(:,3)+(disp(:,3,1)*DSF),pointsize,MaxStretch(:,1))
axis equal
title('Maximum Bond Stretch')
xlabel('x')
ylabel('y')
zlabel('z')
%view([0,-90,0]) % View in 2D
view(40,35)    % View in 3D
colormap jet 
colorbar
h = colorbar;
ylabel(h, 'Stretch')

% Plot data
pointsize=1;
figure(14)
scatter3(coordinates(:,1)+(disp(:,1,1)*DSF),coordinates(:,2)+(disp(:,2,1)*DSF),coordinates(:,3)+(disp(:,3,1)*DSF),pointsize,AbsoluteStretch(:,1))
axis equal
title('Maximum Absolute Bond Stretch')
xlabel('x')
ylabel('y')
zlabel('z')
%view([0,-90,0]) % View in 2D
view(40,35)    % View in 3D
colormap jet 
colorbar
h = colorbar;
ylabel(h, 'Stretch')
  
    
end 