
function [COORDINATES]=buildmaterialpointcoordinates()

% Specification of material point coordinates for equiangular quadrilaterals (squares and rectangles)

%% Load data
datageometry

%% Main body of function
COORDINATES=zeros((nDIVX*nDIVY*nDIVZ),NOD); % Initialise coordinates array
counter=0;                                  % Counter

for k3=1:nDIVZ
    for k2=1:nDIVY
        for k1=1:nDIVX
            coordx=DX*k1;
            coordy=DY*k2;
            coordz=DZ*k3;
            counter=counter+1;
            COORDINATES(counter,1)=coordx;
            COORDINATES(counter,2)=coordy;  
            COORDINATES(counter,3)=coordz; 
         end
    end
end


end
