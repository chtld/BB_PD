function [StrainTensor]=Strains(coordinates,Displacement,NumFamMemb,nodefamily,Totalnodes,familypointer,maxfam,delta)
%   Returns the stress tensor in each point of a given set using
%   state based theory with correspondency strategy.
%
%   [Input] 
%   The first index of the input arrays corresponds to a particle number.
%   matX: matrix with the initial coordinates of the particles
%   matY: matrix with the deformed coordinates of the particles
%   matFamilies: matrix with the node ID of the particles within 
%   the material horizon of each point
%   vecNFamily: number of particles in each family
%   horizon_delta: material horizon (this is only necessary if the
%   influence function is not constant)
%   
%   [Output]
%   The first index of the output array corresponds to a particle number.
%   vecmatEps: 3D array, where vecmatEps(k,:,:) is the strain tensor at
%   the point k.
%
%   H. David Miranda
%   University of Cambridge
%   May 2018
%
%   References:
%   "Peridynamic states and constitutive modeling"
%   SA Silling, M Epton, O Weckner, J Xu, E Askari
%   Journal of Elasticity 88 (2), 151-184

    %load('C:\Users\Mark\Documents\University\PhD\Peridynamics\Matlab\2D_reinforced_beam\Output\coordinates.m')
    %load('C:\Users\Mark\Documents\University\PhD\Peridynamics\Matlab\2D_reinforced_beam\Output\Displacement.m')
    
    matX=coordinates;
    matY=coordinates+Displacement;
    
    nPts = size(matX,1); % number of particles
    nDim = size(matX,2); % number of dimensions
    
    %nodefamilyreshaped=reshape(nodefamily,[Totalnodes,maxfam]);
    
%% some verifications, eliminate if not necessary
%     if nPts~=size(matY,1) || nPts~=size(matY,2)
%        error('Error using getStressState, mismatch between dimensions of matX and matY '); 
%     end
%     if  nPts~=size(matFamilies,1)  ||  nPts~=size(vecNFamily,1)
%        error('Error using getStressState, dimension mismatch of the inputs'); 
%     end
  

    StrainTensor = zeros(nPts, nDim, nDim);
    I = eye(nDim); % identity matrix
   
    % loop all the points
    for k=1:nPts
        % loop all the points within the family of k
        XX = zeros(nDim); % tensor product X * X
        YX = zeros(nDim); % tensor product Y * Y
        for i=1:NumFamMemb(k)
            %j = nodefamilyreshaped(k,i);
            cnode=nodefamily(familypointer(k,1)+(i-1),1);
            % matX contains the initial coordinates of a particle
            X = matX(cnode,:) - matX(k,:);
            % matY contains the deformed coordinates of a particle
            Y = matY(cnode,:) - matY(k,:);
            %compute the influence function omega(X), here I'll simply assume:
            omega = 1;
            %kn = 2; omega = (1-norm(X)/ delta)^kn; % example of a quadratic function 
            
            %% compute XX and XY by assemblage
            for ki=1:nDim
                for kj=1:nDim
                    % XX is the shape tensor K
                    XX(ki,kj) = XX(ki,kj) + X(ki) * X(kj) * omega;
                    YX(ki,kj) = YX(ki,kj) + Y(ki) * X(kj) * omega;
                end
            end
        end
        % deformation gradient
        if det(XX) > 1e-20 % this is to avoid singularities
            F = YX*XX^-1;
            % convert deformation gradient into small strains - Operator ' complex conjugate transpose
            % See this webpage http://www.continuummechanics.org/smallstrain.html
            StrainTensor(k,:,:) = 0.5 * (F + F') - I;
        end
    end
    
 
    % Strain Plot
    pointsize=1;
    figure(5)
    scatter3(coordinates(:,1)+(Displacement(:,1,1)*10),coordinates(:,2)+(Displacement(:,2,1)*10),coordinates(:,3)+(Displacement(:,3,1)*10),pointsize,StrainTensor(:,1,1))
    axis equal
    colormap jet 
    colorbar
    
end

