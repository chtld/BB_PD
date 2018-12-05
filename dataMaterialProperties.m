% Define material properties data

DENS_CONCRETE=2400;     % Density concrete (kg/m^3)
DENS_STEEL=8000;        % Density steel (kg/m^3)

E_CONCRETE=22e9;        % Young's modulus
E_STEEL=200e9;          % Young's modulus

G_CONCRETE=8.8e9;       % Shear modulus
G_STEEL=78e9;           % Shear modulus

V_CONCRETE=0.2;         % Poisson's ratio
V_STEEL=0.3;            % Poisson's ratio

EFFECTIVEMODULUSCONCRETE=E_CONCRETE/((1-2*V_CONCRETE)*(1+V_CONCRETE));
EFFECTIVEMODULUSSTEEL=E_STEEL/((1-2*V_STEEL)*(1+V_STEEL));