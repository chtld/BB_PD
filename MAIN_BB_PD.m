% ---------------------------------------------------------------------------
% MAIN file for Bond Based Peridynamic Analysis (BB_PD) code using bond lists
% ---------------------------------------------------------------------------

%% Workspace set-up
clear variables
close all
clc
pwd; % Identify current folder
currentFolder=pwd;
subFolder1='/InputData';
subFolder2='/SubFunctions';
subFolder3='/PlotFunctions';
addpath(strcat(currentFolder,subFolder1));
addpath(strcat(currentFolder,subFolder2));
addpath(strcat(currentFolder,subFolder3));

%% Start simulation timing
startTiming=tic;

%% Read in input data and specify material point coordinates
tic
[COORDINATES]=buildmaterialpointcoordinates(); 
databoundaryconditions;
inputdataTiming=toc;
fprintf('Input data complete in %fs \n', inputdataTiming)

%% Determine the nodes inside the horizon of each material point, build bond lists, and determine undeformed length of every bond
tic
[nFAMILYMEMBERS,NODEFAMILYPOINTERS,NODEFAMILY,BONDLIST,UNDEFORMEDLENGTH]=buildhorizons(COORDINATES);
buildhorizonsTiming=toc;
fprintf('Horizons complete in %fs \n', buildhorizonsTiming)

%% Calculate volume correction factors
tic
[VOLUMECORRECTIONFACTORS]=calculatevolumecorrectionfactors(UNDEFORMEDLENGTH);
calculatevolumecorrectionfactorsTiming=toc;
fprintf('Volume correction factors complete in %fs \n', calculatevolumecorrectionfactorsTiming)

%% Calculate bond type and bond stiffness (plus stiffness corrections)
tic
[BONDSTIFFNESS,BONDTYPE,BFMULTIPLIER]=buildbonddata(BONDLIST,nFAMILYMEMBERS,MATERIALFLAG);
buildbonddataTiming=toc;
fprintf('Bond type and stiffness complete in %fs \n', buildbonddataTiming)

%% Time integration
tic
[fail,disp,stretch,nodeDisplacement,timeStepTracker,equilibriumStateAverage,NT]=timeintegration(BONDLIST,COORDINATES,UNDEFORMEDLENGTH,BONDTYPE,BFMULTIPLIER,BONDSTIFFNESS,VOLUMECORRECTIONFACTORS,BODYFORCE,DENSITY,CONSTRAINTFLAG);
timeintegrationTiming=toc;
fprintf('Time integration complete in %fs \n', timeintegrationTiming)

save([pwd,'/Output/Workspace_snapshot_',date,'.mat']); % Save workspace

%% Complete simulation timing
simulationTiming=toc(startTiming); 
fprintf('Simulation complete in %fs \n', simulationTiming)

%% Display results
plotdeformedmember(disp,COORDINATES,MATERIALFLAG);                              % Plot deformed shape of object under analysis
plotdisplacementtimegraph(NT,-nodeDisplacement);                                % Plot displacement of selected node against time

plotequilibriumstatetimegraph(NT,equilibriumStateAverage);

[bondDamage]=calculatedamage(nNODES,BONDLIST,fail,nFAMILYMEMBERS);              % Damage - Calculate percentage of broken peridynamic bonds for every node
plotbonddamage(COORDINATES,disp,bondDamage,DX);

plotstretch(nNODES,stretch,BONDLIST,COORDINATES,disp);                          % Plot stretch of every bond

%% Stress and Strain

[straintensor]=calculatestrain(COORDINATES,disp,nFAMILYMEMBERS,NODEFAMILY,NODEFAMILYPOINTERS);
plotstrain(COORDINATES,disp,straintensor);

[stresstensor]=calculatestress(nNODES,NOD,straintensor,MATERIALFLAG);
plotstress(COORDINATES,disp,stresstensor);

%% Output simulation data

%% Additional time
