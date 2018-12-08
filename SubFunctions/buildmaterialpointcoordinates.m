
function [coordinates]=buildmaterialpointcoordinates()

% Specification of material point coordinates for equiangular quadrilaterals (squares and rectangles)

%% Load data
dataGeometry

%% Main body of function
coordinates=zeros((NDIVX*NDIVY*NDIVZ),NOD); % Initialise coordinates array
nnum=0;                                     % Counter

for j3=1:NDIVZ
    for j2=1:NDIVY
        for j1=1:NDIVX
            coordx=DX*j1;
            coordy=DY*j2;
            coordz=DZ*j3;
            nnum=nnum+1;
            coordinates(nnum,1)=coordx;
            coordinates(nnum,2)=coordy;  
            coordinates(nnum,3)=coordz; 
         end
    end
end


end
