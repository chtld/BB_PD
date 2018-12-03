
function [coordinates]=MaterialPointCoordinates(Geometry,Discretisation,Nodes)

% Specification of material point coordinates for equiangular quadrilaterals (squares and rectangles)

%% Unpack Structured Arrays
Totalnodes=Nodes.Totalnodes;
Nod=Geometry.Nod;
Ndiv_x=Discretisation.Ndiv_x;
Ndiv_y=Discretisation.Ndiv_y;
Ndiv_z=Discretisation.Ndiv_z;
dx=Discretisation.dx;
dy=Discretisation.dy;
dz=Discretisation.dz;


%% Main body of function
coordinates=zeros(Totalnodes,Nod); % Initialise coordinates
nnum=0;                            % Counter

for j3=1:Ndiv_z
    for j2=1:Ndiv_y
        for j1=1:Ndiv_x
            coordx=dx*j1;
            coordy=dy*j2;
            coordz=dz*j3;
            nnum=nnum+1;
            coordinates(nnum,1)=coordx;
            coordinates(nnum,2)=coordy;  
            coordinates(nnum,3)=coordz; 
         end
    end
end


end
