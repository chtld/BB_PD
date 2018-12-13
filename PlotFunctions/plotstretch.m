function plotstretch(nNODES,stretch,BONDLIST,COORDINATES,disp)
% Maximum bond stretch for every node - absolute, tension, compression

% TODO I think Tension and Compression might be switched? Need to check

plotOnOff=[true,false,false]; % true=on, false=off [absolute,tension,compression]
nBONDS=size(BONDLIST,1);
DSF=0; % Displacement scale factor

%% Maximum absolute bond stretch - Tension or compression

if plotOnOff(1)==true % Logic condition to turn plot on/off

    maxStretchAbsolute=zeros(nNODES,1); 
    stretchAbsolute=abs(stretch); % Return the absolute value of every element of Stretch vector  

    % For every node, iterate over all connected bonds and find the bond with
    % the largest stretch value. If the maximum stretch value currently stored
    % for node i or j is less than the absolute stretch value for the current
    % bond, replace maxStretch with this value.

    for kBond=1:nBONDS

        nodei=BONDLIST(kBond,1);
        nodej=BONDLIST(kBond,2);

        % Iterate over column 1 of bondlist - nodei
        if maxStretchAbsolute(nodei,1)<stretchAbsolute(kBond)
            maxStretchAbsolute(nodei,1)=stretchAbsolute(kBond);
        end

        % Iterate over column 2 of bondlist - nodej
        if maxStretchAbsolute(nodej,1)<stretchAbsolute(kBond)
            maxStretchAbsolute(nodej,1)=stretchAbsolute(kBond);
        end

    end

    % Plot data
    POINT_SIZE=1;
    figure;
    scatter3(COORDINATES(:,1)+(disp(:,1,1)*DSF),COORDINATES(:,2)+(disp(:,2,1)*DSF),COORDINATES(:,3)+(disp(:,3,1)*DSF),POINT_SIZE,maxStretchAbsolute(:,1))
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
    
    maxStretchTension=zeros(nNODES,1); 

    for kBond=1:nBONDS

        nodei=BONDLIST(kBond,1);
        nodej=BONDLIST(kBond,2);

        % Iterate over column 1 of bondlist - nodei
        if maxStretchTension(nodei,1)>stretch(kBond)  % Bonds under tension have positive stretch values
            maxStretchTension(nodei,1)=stretch(kBond);
        end

        % Iterate over column 2 of bondlist - nodej
        if maxStretchTension(nodej,1)>stretch(kBond)
            maxStretchTension(nodej,1)=stretch(kBond);
        end

    end


    % Plot data
    POINT_SIZE=1;
    figure;
    scatter3(COORDINATES(:,1)+(disp(:,1,1)*DSF),COORDINATES(:,2)+(disp(:,2,1)*DSF),COORDINATES(:,3)+(disp(:,3,1)*DSF),POINT_SIZE,maxStretchTension(:,1))
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
    
    maxStretchCompression=zeros(nNODES,1); 

    for kBond=1:nBONDS

        nodei=BONDLIST(kBond,1);
        nodej=BONDLIST(kBond,2);

        % Iterate over column 1 of bondlist - nodei
        if maxStretchCompression(nodei,1)<stretch(kBond)  % Bonds under tension have positive stretch values
            maxStretchCompression(nodei,1)=stretch(kBond);
        end

        % Iterate over column 2 of bondlist - nodej
        if maxStretchCompression(nodej,1)<stretch(kBond)
            maxStretchCompression(nodej,1)=stretch(kBond);
        end

    end


    % Plot data
    POINT_SIZE=1;
    figure;
    scatter3(COORDINATES(:,1)+(disp(:,1,1)*DSF),COORDINATES(:,2)+(disp(:,2,1)*DSF),COORDINATES(:,3)+(disp(:,3,1)*DSF),POINT_SIZE,maxStretchCompression(:,1))
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