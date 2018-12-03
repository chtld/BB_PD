Simu% Input Data for BB_PD analysis code

%% Geometry

Geometry.Nod=3;          % Number of degrees of freedom (1,2,3)
Geometry.Length=1;       % Length (m) - x
Geometry.Width=0.1;      % Width (m) - y
Geometry.Height=0.2;     % Height (m) - z

%% Discretisation 

Discretisation.Ndiv_x=150;     % Number of divisions in x-direction
Discretisation.Ndiv_y=15;      % Number of divisions in y-direction
Discretisation.Ndiv_z=30;      % Number of divisions in z-direction

Discretisation.dx=Geometry.Length/Discretisation.Ndiv_x;   % Spacing between material points in x-direction
Discretisation.dy=Discretisation.dx;                       % Spacing between material points in y-direction
Discretisation.dz=Discretisation.dx;                       % Spacing between material points in y-direction

Discretisation.Volume=Discretisation.dx^3;                 % Cell volume/area
Discretisation.radij=Discretisation.dx/2;                  % Material point radius
%% Nodal data (material point data)

Nodes.Totalnodes=Discretisation.Ndiv_x*Discretisation.Ndiv_y*Discretisation.Ndiv_z;    % Total number of nodes
[coordinates]=MaterialPointCoordinates(Geometry,Discretisation,Nodes); % Define material point coordinates for main body
Nodes.coordinates=coordinates;                                         % Assign to Nodes structured array


%% Steel rebar

Nodes.MaterialFlag=zeros(Nodes.Totalnodes,1);       % Create flag to identify steel and concrete nodes Concrete=0 Steel=1

% % Bar 1
% % for i=((Ndiv_x*363)+1):(Ndiv_x*365)
% %    MaterialFlag(i,1)=1; 
% % end
% for i=((Ndiv_x*378)+1):(Ndiv_x*380)
%    MaterialFlag(i,1)=0; 
% end
% for i=((Ndiv_x*393)+1):(Ndiv_x*395)
%    MaterialFlag(i,1)=0; 
% end
% 
% % Bar 2
% % for i=((Ndiv_x*370)+1):(Ndiv_x*372)
% %    MaterialFlag(i,1)=1; 
% % end
% for i=((Ndiv_x*385)+1):(Ndiv_x*387)
%    MaterialFlag(i,1)=0; 
% end
% for i=((Ndiv_x*400)+1):(Ndiv_x*402)
%    MaterialFlag(i,1)=0; 
% end
% 
% %% Define loading plates, supports, constraints, loads (boundary conditions)
% % Loading Plate
% % Supports
% 
% % Constraint flag
Nodes.ConstraintFlag=zeros(Nodes.Totalnodes,Geometry.Nod)+1;
% for i=1:Ndiv_x:(Totalnodes-Ndiv_x+1)
%   ConstraintFlag(i,:)=0;
% end
% for i=2:Ndiv_x:(Totalnodes-Ndiv_x+2)
%   ConstraintFlag(i,:)=0;
% end
% for i=3:Ndiv_x:(Totalnodes-Ndiv_x+3)
%   ConstraintFlag(i,:)=0;
% end



% Application of force
Nodes.bodyforce=zeros(Nodes.Totalnodes,Geometry.Nod);
% for i=Ndiv_x:Ndiv_x:Totalnodes
%     bodyforce(i,3)=1;
% end

  

%% Material properties 

MaterialProperties.E_concrete=22e9;               % Young's modulus
MaterialProperties.E_steel=200e9;                 % Young's modulus

MaterialProperties.v_concrete=0.2;                % Poisson's ratio
MaterialProperties.v_steel=0.3;                   % Poisson's ratio

MaterialProperties.G_concrete=8.8e9;              % Shear modulus
MaterialProperties.G_steel=78e9;                  % Shear modulus

MaterialProperties.Dens_concrete=2400;            % Density concrete (kg/m^3)
MaterialProperties.Dens_steel=8000;               % Density steel (kg/m^3)
                                                   
MaterialProperties.EffectiveModulusConcrete = MaterialProperties.E_concrete/((1-2*MaterialProperties.v_concrete)*(1+MaterialProperties.v_concrete));
MaterialProperties.EffectiveModulusSteel = MaterialProperties.E_steel/((1-2*MaterialProperties.v_steel)*(1+MaterialProperties.v_steel));

Nodes.dens=zeros(Nodes.Totalnodes,1);
% for i=1:Totalnodes
%     if MaterialFlag(i,1)==0
%     dens(i,1)=MaterialProperties.Dens_concrete; % Concrete
%     elseif MaterialFlag(i,1)==1
%     dens(i,1)=MaterialProperties.Dens_steel;    % Steel        
%     end
% end

%% Peridynamic parameters

PDparameters.delta=pi*Discretisation.dx;                              % Horizon
PDparameters.NeighbourhoodVolume=(4*pi*PDparameters.delta^3)/3;       % Neighbourhood area/volume for node contained within material bulk

PDparameters.c_concrete=(12*MaterialProperties.E_concrete)/(pi*PDparameters.delta^4);        % Bond stiffness
PDparameters.c_steel=(12*MaterialProperties.E_steel)/(pi*PDparameters.delta^4);              % Bond stiffness  

PDparameters.Critical_ts_conc=0.000533;                  % Critical tensile stretch - concrete
PDparameters.Critical_ts_steel=0.01;                     % critical tensile stretch - steel   

%% Simulation Parameters 
% Time Step - Look in first year report and implement defined procedure 
SimParameters.SF=2;                                                               % Time step safety factor - to reduce time step size
SimParameters.dt=(0.8*sqrt(2*MaterialProperties.Dens_concrete*Discretisation.dx/(pi*PDparameters.delta^2*Discretisation.dx*PDparameters.c_concrete)))/SimParameters.SF;    % Minimum stable time step
SimParameters.nt=10000;                                                           % Number of time steps (10,000 for speed testing)
SimParameters.countmin=1;                 % Counter for determining previous time step when restarting simulations
SimParameters.Max_Force=-1.2e8;           % Maximum force per node
SimParameters.Build_up=0;                 % Build load up over defined number of time steps
SimParameters.damping=2.5e6;              % Damping coefficient

%% Output input data into readable text file 
