% -------------------------------------------------------------------------
% Define boundary conditions
% -------------------------------------------------------------------------

%% Load constants
dataMaterialProperties
dataGeometry
dataPDparameters

TOTALNODES=NDIVX*NDIVY*NDIVZ;

%% Define location of steel reinforcing bars
MATERIALFLAG=zeros(TOTALNODES,1);       % Create flag to identify steel and concrete nodes Concrete=0 Steel=1

% Bar 1
for i=((NDIVX*363)+1):(NDIVX*365)
   MATERIALFLAG(i,1)=0; 
end
for i=((NDIVX*378)+1):(NDIVX*380)
   MATERIALFLAG(i,1)=0; 
end
for i=((NDIVX*393)+1):(NDIVX*395)
   MATERIALFLAG(i,1)=0; 
end

% Bar 2
for i=((NDIVX*370)+1):(NDIVX*372)
   MATERIALFLAG(i,1)=0; 
end
for i=((NDIVX*385)+1):(NDIVX*387)
   MATERIALFLAG(i,1)=0; 
end
for i=((NDIVX*400)+1):(NDIVX*402)
   MATERIALFLAG(i,1)=0; 
end

%% Application of body force

BODYFORCE=zeros(TOTALNODES,NOD);
for i=NDIVX:NDIVX:TOTALNODES
    BODYFORCE(i,3)=1;
end

%% Apply constraints to member

CONSTRAINTFLAG=zeros(TOTALNODES,NOD)+1;

for i=1:NDIVX:(TOTALNODES-NDIVX+1)
  CONSTRAINTFLAG(i,:)=0;
end

for i=2:NDIVX:(TOTALNODES-NDIVX+2)
  CONSTRAINTFLAG(i,:)=0;
end

for i=3:NDIVX:(TOTALNODES-NDIVX+3)
  CONSTRAINTFLAG(i,:)=0;
end

%% Assign density values to material points

DENSITY=zeros(TOTALNODES,1);

for i=1:TOTALNODES
    if MATERIALFLAG(i,1)==0
    DENSITY(i,1)=DENS_CONCRETE; % Concrete
    elseif MATERIALFLAG(i,1)==1
    DENSITY(i,1)=DENS_STEEL;    % Steel        
    end
end
