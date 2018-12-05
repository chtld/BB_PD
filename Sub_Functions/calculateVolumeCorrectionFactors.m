function [fac]=calculateVolumeCorrectionFactors(UndeformedLength)
% Calculate volume correction factors for every node - 3D cell volume

%% Constants
dataGeometry
dataPDparameters
TOTALBONDS=size(UndeformedLength,1);

%% Main body of volume correction function

fac=zeros(TOTALBONDS,1);    % Initialise matrix

for i=1:TOTALBONDS
    
    UL=UndeformedLength(i);
    
    if (UL <= (DELTA-RADIJ))
            fac(i)=1;
        elseif (UL > (DELTA-RADIJ)) &&  (UL <= DELTA)
            fac(i)=(DELTA+RADIJ-UL)/(2*RADIJ);
        else
            fac(i)=0;
    end
 
end


end