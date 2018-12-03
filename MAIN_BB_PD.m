% MAIN file for Bond Based Peridynamic Analysis (BB_PD) code using bond lists

clear variables
close all
clc

start=tic;

%% Read in input data and specify material point coordinates
tic
addpath('D:\PhD\2 Code\BB_PD\Sub_Functions');
Input_Data                                     
Input_Data_time=toc;
fprintf('Input data complete in %fs \n', Input_Data_time)

%% Determine the nodes inside the horizon of each material point, build bond lists, and determine undeformed length of every bond
tic
[Nodes,Bonds]=BuildHorizons(Nodes,PDparameters);
Horizons=toc;
fprintf('Horizons complete in %fs \n', Horizons)

%% Calculate volume correction factors
tic
[Nodes]=VolumeCorrection(Bonds,PDparameters,Discretisation,Nodes);
VolumeCorrection=toc;
fprintf('Volume correction factors complete in %fs \n', VolumeCorrection)

%% Calculate bond type and bond stiffness (plus stiffness corrections)
tic
[Bonds]=BondTypefunc(Bonds,Nodes,Discretisation,PDparameters);
BondTypeandStiffness=toc;
fprintf('Bond type and stiffness complete in %fs \n', BondTypeandStiffness)

%% Time integration
tic
[fail,disp,Stretch,Displacement_node,ReactionForce,countmin,StressHistory]=TimeIntegration(Bonds,Nodes,PDparameters,Discretisation,Geometry,SimParameters,MaterialProperties);
TimeIntegrationTimer=toc;
fprintf('Time integration complete in %fs \n', TimeIntegrationTimer)

%% Simulation timing
Total=toc(start); 
fprintf('Simulation complete in %fs \n', Total)

%% Display results
[Bond_damage]=Damage(NumFamMembVector,fail,Totalnodes,Totalbonds,coordinates,disp,bondlist);   % Damage - Calculate percentage of broken peridynamic bonds for every node
Displacement(disp,coordinates,MaterialFlag);                                                   % Plot deformed shape of object under analysis
DisplacementVsTime(nt,Displacement_node);                                                      % Plot displacement of selected node against time
%ForceVsDisplacement(Displacement_node,ForceHistory);                                          % Plot applied force against time
%StretchDisplay(Totalnodes,Stretch,Totalbonds,bondlist,coordinates,disp);                       % Plot stretch of every bond
ReactionForceVsDisplacement(ReactionForce,Displacement_node);                                  % Plot reaction force against displacement

%% Stress and Strain
% [StrainTensor]=Strainfunc(coordinates,disp,Totalbonds,bondlist,NumFamMembVector,nodefamily,nfpointer);
% [StressTensor]=Stressfunc(Totalnodes,Nod,MaterialProperties,coordinates,disp,StrainTensor,MaterialFlag);

%% Output simulation data

%% Additional time
% [Displacement_node,nt]=Additional_Time(Displacement_node,nt,countmin); % Specify additional simulation time
