% Peridynamic parameters

% Load data
dataMaterialProperties
dataGeometry

DELTA=pi*DX;                               % Horizon
NEIGHBOURHOODVOLUME=(4*pi*DELTA^3)/3;      % Neighbourhood area/volume for node contained within material bulk

C_CONCRETE=(12*E_CONCRETE)/(pi*DELTA^4);   % Bond stiffness
C_STEEL=(12*E_STEEL)/(pi*DELTA^4);         % Bond stiffness  

CRITICAL_TS_CONCRETE=0.000533;             % Critical tensile stretch - concrete
CRITICAL_TS_STEEL=0.01;                    % critical tensile stretch - steel   