% Maximum bond stretch for every node

function StretchDisplay(Totalnodes,Stretch,Totalbonds,bondlist,coordinates,disp)

MaxStretch=zeros(Totalnodes,1);
AbsoluteStretch=abs(Stretch);

for i=1:Totalbonds
    
    nodei=bondlist(i,1);
    nodej=bondlist(i,2);
    
    % Calculate the number of unbroken bonds attached to every node
    if MaxStretch(nodei,1)<AbsoluteStretch(i)
        MaxStretch(nodei,1)=AbsoluteStretch(i);
    end
    
    if MaxStretch(nodej,1)<AbsoluteStretch(i)
        MaxStretch(nodej,1)=AbsoluteStretch(i);
    end

end

% MaxStretch=max(Stretch,[],2);
% MinStretch=min(Stretch,[],2);
% AbsoluteStretch=abs(Stretch);
% AbsoluteStretch=max(AbsoluteStretch,[],2);

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
figure;
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
figure;
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