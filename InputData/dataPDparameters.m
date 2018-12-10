% -------------------------------------------------------------------------
% Peridynamic parameters
% -------------------------------------------------------------------------

% Load data
datamaterialproperties
datageometry

DELTA=pi*DX;                               % Horizon
NEIGHBOURHOODVOLUME=(4*pi*DELTA^3)/3;      % Neighbourhood area/volume for node contained within material bulk

C_CONCRETE=(12*E_CONCRETE)/(pi*DELTA^4);   % Bond stiffness
C_STEEL=(12*E_STEEL)/(pi*DELTA^4);         % Bond stiffness  

% TODO calculate critical stretch with formula in first year report 
CRITICAL_STRETCH_CONCRETE=0.000533;        % Critical tensile stretch - concrete
CRITICAL_STRETCH_STEEL=0.01;               % critical tensile stretch - steel   