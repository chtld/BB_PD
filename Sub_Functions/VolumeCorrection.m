function [fac]=VolumeCorrection(Totalbonds,UndeformedLength,delta,radij)
% Calculate volume correction factors for every node - 3D cell volume

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

end