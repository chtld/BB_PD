% -------------------------------------------------------------------------
% Define boundary conditions
% -------------------------------------------------------------------------

%% Load constants
datamaterialproperties
datageometry
dataPDparameters

 nNODES=nDIVX*nDIVY*nDIVZ;

%% Define location of steel reinforcing bars
MATERIALFLAG=zeros(nNODES,1);       % Create flag to identify steel and concrete nodes Concrete=0 Steel=1

% Bar 1
for i=((nDIVX*363)+1):(nDIVX*365)
   MATERIALFLAG(i,1)=0; 
end
for i=((nDIVX*378)+1):(nDIVX*380)
   MATERIALFLAG(i,1)=0; 
end
for i=((nDIVX*393)+1):(nDIVX*395)
   MATERIALFLAG(i,1)=0; 
end

% Bar 2
for i=((nDIVX*370)+1):(nDIVX*372)
   MATERIALFLAG(i,1)=0; 
end
for i=((nDIVX*385)+1):(nDIVX*387)
   MATERIALFLAG(i,1)=0; 
end
for i=((nDIVX*400)+1):(nDIVX*402)
   MATERIALFLAG(i,1)=0; 
end

%% Application of body force

BODYFORCE=zeros(nNODES,NOD);
for i=nDIVX:nDIVX:nNODES
    BODYFORCE(i,3)=1;
end

%% Apply constraints to member

CONSTRAINTFLAG=zeros(nNODES,NOD)+1;

for i=1:nDIVX:(nNODES-nDIVX+1)
  CONSTRAINTFLAG(i,:)=0;
end

for i=2:nDIVX:(nNODES-nDIVX+2)
  CONSTRAINTFLAG(i,:)=0;
end

for i=3:nDIVX:(nNODES-nDIVX+3)
  CONSTRAINTFLAG(i,:)=0;
end

%% Assign density values to material points

DENSITY=zeros(nNODES,1);

for i=1:nNODES
    if MATERIALFLAG(i,1)==0
    DENSITY(i,1)=DENS_CONCRETE; % Concrete
    elseif MATERIALFLAG(i,1)==1
    DENSITY(i,1)=DENS_STEEL;    % Steel        
    end
end
