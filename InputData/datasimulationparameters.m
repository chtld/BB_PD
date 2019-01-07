% -------------------------------------------------------------------------
% Define simulation parameters
% -------------------------------------------------------------------------

% Load constants
datamaterialproperties
datageometry
dataPDparameters
SAFETYFACTOR=2;                                                              
DT=(0.8*sqrt(2*DENS_CONCRETE*DX/(pi*DELTA^2*DX*C_CONCRETE)))/SAFETYFACTOR;    % Minimum stable time step
                                                              % Time step safety factor - to reduce time step size and ensure stable simulation
%[DT]=calculatestabletimestep(TOTALNODES,bondlist,VOLUME,DENSITY,c);            % Minimum stable time step (this value is not always stable and a safety factor must be applied) 
%DT=DT/SAFETYFACTOR;                                                            % Apply safety factor
NT=1000;                                                                       % Number of time steps (10,000 for speed testing)

MAXBODYFORCE=-1.2e8;           % Maximum force per node
BUILDUP=0;                     % Build load up over defined number of time steps
DAMPING=2e6;                   % Damping coefficient (2.5e6 for testing)


timeStepTracker=1;             % Tracker for determining previous time step when restarting simulations