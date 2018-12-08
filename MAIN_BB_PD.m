% ---------------------------------------------------------------------------
% MAIN file for Bond Based Peridynamic Analysis (BB_PD) code using bond lists
% ---------------------------------------------------------------------------

%% Workspace set-up
clear variables
close all
clc
pwd; % Identify current folder
currentFolder=pwd;
subFolder1='/SubFunctions';
subFolder2='/PlotFunctions';
addpath(strcat(currentFolder,subFolder1));
addpath(strcat(currentFolder,subFolder2));

%% Start simulation timing
startTiming=tic;

%% Read in input data and specify material point coordinates
tic
[coordinates]=buildmaterialpointcoordinates(); 
dataBoundaryConditions;
inputdataTiming=toc;
fprintf('Input data complete in %fs \n', inputdataTiming)

%% Determine the nodes inside the horizon of each material point, build bond lists, and determine undeformed length of every bond
tic
[nodefamily,nfpointer,NumFamMembVector,UndeformedLength,bondlist]=buildhorizons(coordinates);
buildhorizonsTiming=toc;
fprintf('Horizons complete in %fs \n', buildhorizonsTiming)

%% Calculate volume correction factors
tic
[fac]=calculatevolumecorrectionfactors(UndeformedLength);
calculatevolumecorrectionfactorsTiming=toc;
fprintf('Volume correction factors complete in %fs \n', calculatevolumecorrectionfactorsTiming)

%% Calculate bond type and bond stiffness (plus stiffness corrections)
tic
[c,BondType,BFmultiplier]=buildbonddata(bondlist,NumFamMembVector,MATERIALFLAG);
buildbonddataTiming=toc;
fprintf('Bond type and stiffness complete in %fs \n', buildbonddataTiming)

%% Time integration
tic
[fail,disp,Stretch,ReactionForce,nodedisplacement,timesteptracker]=timeintegration(bondlist,UndeformedLength,BondType,c,BFmultiplier,coordinates,fac,BODYFORCE,DENSITY,MATERIALFLAG,CONSTRAINTFLAG,NumFamMembVector,nodefamily,nfpointer);
timeintegrationTiming=toc;
fprintf('Time integration complete in %fs \n', timeintegrationTiming)

%% Complete simulation timing
simulationTiming=toc(startTiming); 
fprintf('Simulation complete in %fs \n', simulationTiming)

%% Display results
plotdeformedmember(disp,coordinates,MATERIALFLAG);                                             % Plot deformed shape of object under analysis
plotdisplacementtimegraph(2000,nodedisplacement);                                              % Plot displacement of selected node against time

[bondDamage]=calculatedamage(TOTALNODES,bondlist,fail,NumFamMembVector);                       % Damage - Calculate percentage of broken peridynamic bonds for every node
plotbonddamage(coordinates,disp,bondDamage,DX);

plotstretch(TOTALNODES,Stretch,bondlist,coordinates,disp);                           % Plot stretch of every bond

%ForceVsDisplacement(Displacement_node,ForceHistory);                                          % Plot applied force against time
ReactionForceVsDisplacement(ReactionForce,Displacement_node);                                  % Plot reaction force against displacement

%% Stress and Strain

[straintensor]=calculateStrain(coordinates,disp,NumFamMembVector,nodefamily,nfpointer);
plotstrain(coordinates,disp,straintensor);

[stresstensor]=calculateStress(TOTALNODES,NOD,straintensor,MATERIALFLAG);
plotstress(coordinates,disp,stresstensor);

%% Output simulation data

%% Additional time
