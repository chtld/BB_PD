% Specification of material point coordinates for equiangular
% quadrilaterals (squares and rectangles)

function [coordinates]=MaterialPointCoordinates(Totalnodes,Nod,Ndiv_y,Ndiv_x,Ndiv_z,dx,dy,dz)

coordinates=zeros(Totalnodes,Nod); % Initialise coordinates

nnum=0;

% Main Body
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
