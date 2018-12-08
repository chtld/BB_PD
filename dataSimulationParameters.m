% Define simulation parameters

% Load constants
dataMaterialProperties
dataGeometry
dataPDparameters

% Time Step - Look in first year report and implement defined procedure 
SAFETYFACTOR=2;                                                               % Time step safety factor - to reduce time step size
%DT=(0.8*sqrt(2*DENS_CONCRETE*DX/(pi*DELTA^2*DX*C_CONCRETE)))/SAFETYFACTOR;    % Minimum stable time step
DT=1.5573e-5/5;
NT=2000;                                                                     % Number of time steps (10,000 for speed testing)

MAXBODYFORCE=-1.2e8;           % Maximum force per node
BUILDUP=0;                     % Build load up over defined number of time steps
DAMPING=2.5e6;                 % Damping coefficient


timesteptracker=1;             % Tracker for determining previous time step when restarting simulations