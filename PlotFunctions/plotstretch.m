function plotstretch(TOTALNODES,Stretch,bondlist,coordinates,disp)
% Maximum bond stretch for every node - absolute, tension, compression

% TODO I think Tension and Compression might be switched? Need to check

plotOnOff=[true,false,false]; % true=on, false=off [absolute,tension,compression]
TOTALBONDS=size(bondlist,1);
DSF=0; % Displacement scale factor

%% Maximum absolute bond stretch - Tension or compression

if plotOnOff(1)==true

    maxStretchAbsolute=zeros(TOTALNODES,1); 
    stretchAbsolute=abs(Stretch); % Return the absolute value of every element of Stretch vector  

    % For every node, iterate over all connected bonds and find the bond with
    % the largest stretch value. If the maximum stretch value currently stored
    % for node i or j is less than the absolute stretch value for the current
    % bond, replace maxStretch with this value.

    for currentBond=1:TOTALBONDS

        nodei=bondlist(currentBond,1);
        nodej=bondlist(currentBond,2);

        % Iterate over column 1 of bondlist - nodei
        if maxStretchAbsolute(nodei,1)<stretchAbsolute(currentBond)
            maxStretchAbsolute(nodei,1)=stretchAbsolute(currentBond);
        end

        % Iterate over column 2 of bondlist - nodej
        if maxStretchAbsolute(nodej,1)<stretchAbsolute(currentBond)
            maxStretchAbsolute(nodej,1)=stretchAbsolute(currentBond);
        end

    end

    % Plot data
    POINT_SIZE=1;
    figure;
    scatter3(coordinates(:,1)+(disp(:,1,1)*DSF),coordinates(:,2)+(disp(:,2,1)*DSF),coordinates(:,3)+(disp(:,3,1)*DSF),POINT_SIZE,maxStretchAbsolute(:,1))
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

%% Maximum bond stretch - Tension

if plotOnOff(2)==true
    
    maxStretchTension=zeros(TOTALNODES,1); 

    for currentBond=1:TOTALBONDS

        nodei=bondlist(currentBond,1);
        nodej=bondlist(currentBond,2);

        % Iterate over column 1 of bondlist - nodei
        if maxStretchTension(nodei,1)>Stretch(currentBond)  % Bonds under tension have positive stretch values
            maxStretchTension(nodei,1)=Stretch(currentBond);
        end

        % Iterate over column 2 of bondlist - nodej
        if maxStretchTension(nodej,1)>Stretch(currentBond)
            maxStretchTension(nodej,1)=Stretch(currentBond);
        end

    end


    % Plot data
    POINT_SIZE=1;
    figure;
    scatter3(coordinates(:,1)+(disp(:,1,1)*DSF),coordinates(:,2)+(disp(:,2,1)*DSF),coordinates(:,3)+(disp(:,3,1)*DSF),POINT_SIZE,maxStretchTension(:,1))
    axis equal
    title('Maximum Bond Stretch - Tension')
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

%% Maximum bond stretch - Compression

if plotOnOff(3)==true
    
    maxStretchCompression=zeros(TOTALNODES,1); 

    for currentBond=1:TOTALBONDS

        nodei=bondlist(currentBond,1);
        nodej=bondlist(currentBond,2);

        % Iterate over column 1 of bondlist - nodei
        if maxStretchCompression(nodei,1)<Stretch(currentBond)  % Bonds under tension have positive stretch values
            maxStretchCompression(nodei,1)=Stretch(currentBond);
        end

        % Iterate over column 2 of bondlist - nodej
        if maxStretchCompression(nodej,1)<Stretch(currentBond)
            maxStretchCompression(nodej,1)=Stretch(currentBond);
        end

    end


    % Plot data
    POINT_SIZE=1;
    figure;
    scatter3(coordinates(:,1)+(disp(:,1,1)*DSF),coordinates(:,2)+(disp(:,2,1)*DSF),coordinates(:,3)+(disp(:,3,1)*DSF),POINT_SIZE,maxStretchCompression(:,1))
    axis equal
    title('Maximum Bond Stretch - Compression')
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

end 