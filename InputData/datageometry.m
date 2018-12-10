%--------------------------------------------------------------------------
% Define geometry and discretisation parameters of member under analysis
%--------------------------------------------------------------------------
%% Define member geometry

NOD=3;          % Number of degrees of freedom (1,2,3)
LENGTH=1;       % Length (m) - x
WIDTH=0.1;      % Width (m) - y
HEIGHT=0.2;     % Height (m) - z

%% Define geometry discretisation 

nDIVX=150;        % Number of divisions in x-direction
nDIVY=15;         % Number of divisions in y-direction
nDIVZ=30;         % Number of divisions in z-direction

DX=LENGTH/nDIVX;  % Spacing between material points in x-direction
DY=DX;            % Spacing between material points in y-direction
DZ=DX;            % Spacing between material points in z-direction

VOLUME=DX^3;      % Cell volume/area
RADIJ=DX/2;       % Material point radius
