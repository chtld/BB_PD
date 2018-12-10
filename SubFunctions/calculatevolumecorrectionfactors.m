function [VOLUMECORRECTIONFACTORS]=calculatevolumecorrectionfactors(UNDEFORMEDLENGTH)
% Calculate volume correction factors for every node - 3D cell volume

%% Load constants
datageometry
dataPDparameters
nBONDS=size(UNDEFORMEDLENGTH,1);

%% Main body of volume correction function

VOLUMECORRECTIONFACTORS=zeros(nBONDS,1);    % Initialise array

for kBond=1:nBONDS
    
    UL=UNDEFORMEDLENGTH(kBond);
    
    if (UL <= (DELTA-RADIJ))
            VOLUMECORRECTIONFACTORS(kBond)=1;
        elseif (UL > (DELTA-RADIJ)) &&  (UL <= DELTA)
            VOLUMECORRECTIONFACTORS(kBond)=(DELTA+RADIJ-UL)/(2*RADIJ);
        else
            VOLUMECORRECTIONFACTORS(kBond)=0;
    end
 
end

end