% ---------------------------------------------------------------------------
% MAIN file for Bond Based Peridynamic Analysis (BB_PD) code using bond lists
% ---------------------------------------------------------------------------

%% Workspace set-up
clear variables
close all
clc
pwd; % Identify current folder
currentFolder=pwd;
subFolder1='/Sub_functions';
addpath(strcat(currentFolder,subFolder1));

%% Start simulation timing
start=tic;

%% Read in input data and specify material point coordinates
tic

[coordinates]=buildMaterialPointCoordinates(); 
dataBoundaryConditions
Input_Data_time=toc;
fprintf('Input data complete in %fs \n', Input_Data_time)

%% Determine the nodes inside the horizon of each material point, build bond lists, and determine undeformed length of every bond
tic
[nodefamily,nfpointer,NumFamMembVector,UndeformedLength,bondlist]=buildHorizons(coordinates);
Horizons=toc;
fprintf('Horizons complete in %fs \n', Horizons)

%% Calculate volume correction factors
tic
[fac]=calculateVolumeCorrectionFactors(UndeformedLength);
VolumeCorrection=toc;
fprintf('Volume correction factors complete in %fs \n', VolumeCorrection)

%% Calculate bond type and bond stiffness (plus stiffness corrections)
tic
[c,BondType,BFmultiplier]=determineBondType(bondlist,NumFamMembVector,MATERIALFLAG);
BondTypeandStiffness=toc;
fprintf('Bond type and stiffness complete in %fs \n', BondTypeandStiffness)

%% Time integration
tic
[fail,disp,Stretch,ReactionForce,nodedisplacement,timesteptracker]=timeIntegration(bondlist,UndeformedLength,BondType,c,BFmultiplier,coordinates,fac,BODYFORCE,DENSITY,MATERIALFLAG,CONSTRAINTFLAG,NumFamMembVector,nodefamily,nfpointer);
TimeIntegrationTimer=toc;
fprintf('Time integration complete in %fs \n', TimeIntegrationTimer)

%% Complete simulation timing
Total=toc(start); 
fprintf('Simulation complete in %fs \n', Total)

%% Display results
plotDeformedMember(disp,coordinates,MATERIALFLAG);                                             % Plot deformed shape of object under analysis
plotDisplacementTimeGraph(2000,nodedisplacement);                                              % Plot displacement of selected node against time

[bondDamage]=calculateDamage(TOTALNODES,bondlist,fail,NumFamMembVector);                       % Damage - Calculate percentage of broken peridynamic bonds for every node
plotbonddamage(coordinates,disp,bondDamage,DX);


%ForceVsDisplacement(Displacement_node,ForceHistory);                                          % Plot applied force against time
%StretchDisplay(Totalnodes,Stretch,Totalbonds,bondlist,coordinates,disp);                      % Plot stretch of every bond
ReactionForceVsDisplacement(ReactionForce,Displacement_node);                                  % Plot reaction force against displacement

%% Stress and Strain

[straintensor]=calculateStrain(coordinates,disp,NumFamMembVector,nodefamily,nfpointer);
plotstrain(coordinates,disp,straintensor);

[stresstensor]=calculateStress(TOTALNODES,NOD,straintensor,MATERIALFLAG);
plotstress(coordinates,disp,stresstensor);

%% Output simulation data

%% Additional time
% [Displacement_node,nt]=Additional_Time(Displacement_node,nt,countmin); % Specify additional simulation time
