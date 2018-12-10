function [deformedLength,deformedX,deformedY,deformedZ,stretch]=calculatedeformedlength(COORDINATES,disp,nBONDS,BONDLIST,deformedX,deformedY,deformedZ,UNDEFORMEDLENGTH,deformedLength)

% Calculate the deformed length of a bond using a nested for loop
displacedCoordinates=COORDINATES+disp;

for kBond=1:nBONDS                           
    
   nodei=BONDLIST(kBond,1);
   nodej=BONDLIST(kBond,2);

    % Length of deformed bond
    deformedLength(kBond)=(displacedCoordinates(nodej,1)-displacedCoordinates(nodei,1))^2+(displacedCoordinates(nodej,2)-displacedCoordinates(nodei,2))^2+(displacedCoordinates(nodej,3)-displacedCoordinates(nodei,3))^2;
    deformedX(kBond)=(displacedCoordinates(nodej,1)-displacedCoordinates(nodei,1)); % X-component of deformed bond
    deformedY(kBond)=(displacedCoordinates(nodej,2)-displacedCoordinates(nodei,2)); % Y-component of deformed bond
    deformedZ(kBond)=(displacedCoordinates(nodej,3)-displacedCoordinates(nodei,3)); % Z-component of deformed bond

end

deformedLength=sqrt(deformedLength);
stretch=(deformedLength-UNDEFORMEDLENGTH)./deformedLength;

end

