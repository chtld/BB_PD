function [StrainTensor]=Strainfunc(coordinates,disp,Totalbonds,bondlist,NumFamMembVector,nodefamily,nfpointer)
%   Returns the strain tensor in each point of a given set using
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
    
    matX=coordinates;
    matY=coordinates+disp;
    
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
    XX = zeros(nPts, nDim, nDim);
    YX = zeros(nPts, nDim, nDim);
    I = eye(nDim); % identity matrix
   
%% Node lists

    % loop all the points
    for i=1:nPts
        
        % loop all the points within the family of k
        XX = zeros(nDim); % tensor product X * X
        YX = zeros(nDim); % tensor product Y * Y
        
        for j=1:NumFamMembVector(i)
            % j = nodefamilyreshaped(k,i);
            nodej=nodefamily(nfpointer(i)+(j-1),1);
            % matX contains the initial coordinates of a particle
            X = matX(nodej,:) - matX(i,:);
            % matY contains the deformed coordinates of a particle
            Y = matY(nodej,:) - matY(i,:);
            %compute the influence function omega(X), here I'll simply assume:
            omega = 1;
            %kn = 2; omega = (1-norm(X)/ delta)^kn; % example of a quadratic function 
            
            % compute XX and XY by assemblage
            for row=1:nDim
                for column=1:nDim
                    % XX is the shape tensor K
                    XX(row,column) = XX(row,column) + (X(row) * X(column) * omega);
                    YX(row,column) = YX(row,column) + (Y(row) * X(column) * omega);
                end
            end
            
        end
        
        % deformation gradient
        if det(XX) > 1e-20 % this is to avoid singularities
            F = YX*XX^-1;
            % convert deformation gradient into small strains - Operator ' complex conjugate transpose
            % See this webpage http://www.continuummechanics.org/smallstrain.html
            StrainTensor(i,:,:) = 0.5 * (F + F') - I;
        end
        
    end
    
 %% Bond lists
 
%     % Loop all bonds 
%     for i=1:Totalbonds
%    
%         % Initialise 
%         %XX=zeros(nDim); % tensor product X * X
%         %YX=zeros(nDim); % tensor product Y * X
%         
%         nodei=bondlist(i,1); % Node i
%         nodej=bondlist(i,2); % Node j
% 
%         % matX contains the initial coordinates of a particle
%         X=matX(nodei,:)-matX(nodej,:);
%         % matY contains the deformed coordinates of a particle
%         Y=matY(nodei,:)-matY(nodej,:);
%         % Compute the influence function omega(X), here I'll simply assume:
%         omega=1;
%         %kn = 2; omega = (1-norm(X)/ delta)^kn; % example of a quadratic function 
%         
%         
%         for row=1:nDim
%             for column=1:nDim
%             % XX   
%             XX(nodei,row,column)=XX(nodei,row,column)+(X(row)*X(column)*omega); % Bond force is positive on Node i 
%             XX(nodej,row,column)=XX(nodej,row,column)-(X(row)*X(column)*omega); % Bond force is negative on Node j
%             
%             % YX
%             YX(nodei,row,column)=YX(nodei,row,column)+(Y(row)*X(column)*omega); % Bond force is positive on Node i 
%             YX(nodej,row,column)=YX(nodej,row,column)-(Y(row)*X(column)*omega); % Bond force is negative on Node j
%                         
%             end
%         end     
% 
%     end
%     
%     for i=1:nPts
%      % deformation gradient
%         if det(XX(i)) > 1e-20 % this is to avoid singularities
%             F = YX(i)*XX(i)^-1;
%             % convert deformation gradient into small strains - Operator ' complex conjugate transpose
%             % See this webpage http://www.continuummechanics.org/smallstrain.html
%             StrainTensor(i,:,:) = 0.5 * (F + F') - I;
%         end
%     end

%% Plot results 

showme=zeros(nPts,1);
for i=1:nPts
    showme(i)=StrainTensor(i,1,1);
end

% Strain Plot
pointsize=1;
figure;
scatter3(coordinates(:,1)+(disp(:,1,1)*10),coordinates(:,2)+(disp(:,2,1)*10),coordinates(:,3)+(disp(:,3,1)*10),pointsize,StrainTensor(:,1,1))
title('Strain')
axis equal
colormap jet 
colorbar

    
end

