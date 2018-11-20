% Input Data

%% Dimensions

Nod=3;          % Number of degrees of freedom (1,2,3)

Length=1;       % Length (m) - x
Width=0.1;      % Width (m) - y
Height=0.2;     % Height (m) - z

Ndiv_x=150;     % Number of divisions in x-direction
Ndiv_y=15;      % Number of divisions in y-direction
Ndiv_z=30;      % Number of divisions in z-direction

dx=Length/Ndiv_x;   % Spacing between material points in x-direction
dy=dx;              % Spacing between material points in y-direction
dz=dx;              % Spacing between material points in y-direction

Totalnodes=Ndiv_x*Ndiv_y*Ndiv_z;    % Total number of nodes

[coordinates]=MaterialPointCoordinates(Totalnodes,Nod,Ndiv_y,Ndiv_x,Ndiv_z,dx,dy,dz); % Define material point coordinates for main body

%% Steel rebar

MaterialFlag=zeros(Totalnodes,1);       % Create flag to identify steel and concrete nodes Concrete=0 Steel=1

% Bar 1
% for i=((Ndiv_x*363)+1):(Ndiv_x*365)
%    MaterialFlag(i,1)=1; 
% end
for i=((Ndiv_x*378)+1):(Ndiv_x*380)
   MaterialFlag(i,1)=0; 
end
for i=((Ndiv_x*393)+1):(Ndiv_x*395)
   MaterialFlag(i,1)=0; 
end

% Bar 2
% for i=((Ndiv_x*370)+1):(Ndiv_x*372)
%    MaterialFlag(i,1)=1; 
% end
for i=((Ndiv_x*385)+1):(Ndiv_x*387)
   MaterialFlag(i,1)=0; 
end
for i=((Ndiv_x*400)+1):(Ndiv_x*402)
   MaterialFlag(i,1)=0; 
end

%% Define loading plates, supports, constraints, loads (boundary conditions)
% Loading Plate
% Supports

% Constraint flag
ConstraintFlag=zeros(Totalnodes,Nod)+1;
for i=1:Ndiv_x:(Totalnodes-Ndiv_x+1)
  ConstraintFlag(i,:)=0;
end
for i=2:Ndiv_x:(Totalnodes-Ndiv_x+2)
  ConstraintFlag(i,:)=0;
end
for i=3:Ndiv_x:(Totalnodes-Ndiv_x+3)
  ConstraintFlag(i,:)=0;
end

Max_Force=-1.2e8;           % Maximum force per node
Build_up=0;                 % Build load up over defined number of time steps
damping=2.5e6;              % Damping coefficient

% Application of force
bodyforce=zeros(Totalnodes,Nod);
for i=Ndiv_x:Ndiv_x:Totalnodes
    bodyforce(i,3)=1;
end

  

%% Material properties, and peridynamic paramaters

E_concrete=22e9;                                % Young's modulus
E_steel=200e9;                                  % Young's modulus

v_concrete=0.2;                                 % Poisson's ratio
v_steel=0.3;                                    % Poisson's ratio

G_concrete=8.8e9;                               % Shear modulus
G_steel=78e9;                                   % Shear modulus
                                                   
EffectiveModulusConcrete = E_concrete/((1-2*v_concrete)*(1+v_concrete));
EffectiveModulusSteel = E_steel/((1-2*v_steel)*(1+v_steel));

Dens_concrete=2400;            % Density concrete (kg/m^3)
Dens_steel=8000;               % Density steel (kg/m^3)

dens=zeros(Totalnodes,1);
for i=1:Totalnodes
    if MaterialFlag(i,1)==0
    % Concrete
    dens(i,1)=Dens_concrete;
    elseif MaterialFlag(i,1)==1
    % Steel
    dens(i,1)=Dens_steel;        
    end
end

delta=pi*dx;                                % Horizon
NeighbourhoodVolume=(4*pi*delta^3)/3;       % Neighbourhood area/volume for node contained within material bulk
Volume=dx^3;                                % Cell volume/area
radij=dx/2;                                 % Material point radius

c_concrete=(12*E_concrete)/(pi*delta^4);        % Bond stiffness
c_steel=(12*E_steel)/(pi*delta^4);              % Bond stiffness  

Critical_ts_conc=0.000533;                  % Critical tensile stretch - concrete
Critical_ts_steel=0.01;                     % critical tensile stretch - steel   

%% Time Step - Look in first year report and implement defined procedure 

SF=2;                                                               % Time step safety factor - to reduce time step size
dt=(0.8*sqrt(2*Dens_concrete*dx/(pi*delta^2*dx*c_concrete)))/SF;    % Minimum stable time step
nt=10000;                                                           % Number of time steps (10,000 for speed testing)
 
%% Other

countmin=1;   % Counter for determining previous time step when restarting simulations

%% Output input data into readable text file 
