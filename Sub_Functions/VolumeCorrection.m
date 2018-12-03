function [Nodes]=VolumeCorrection(Bonds,PDparameters,Discretisation,Nodes)
% Calculate volume correction factors for every node - 3D cell volume

%% Unpack structured array data
Totalbonds=Bonds.Totalbonds;
UndeformedLength=Bonds.UndeformedLength;
delta=PDparameters.delta;
radij=Discretisation.radij;

%% Main body of volume correction function

fac=zeros(Totalbonds,1);    % Initialise matrix

for i=1:Totalbonds
    
    UL=UndeformedLength(i);
    
    if (UL <= (delta-radij))
            fac(i)=1;
        elseif (UL > (delta-radij)) &&  (UL <= delta)
            fac(i)=(delta+radij-UL)/(2*radij);
        else
            fac(i)=0;
    end
 
end

%% Pack data into structured arrays
Nodes.fac=fac;

end