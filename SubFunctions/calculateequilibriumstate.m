function [equilibriumState,equilibriumStateAverage]=calculateequilibriumstate(nodalForce,BODYFORCE,MAXBODYFORCE,equilibriumState,equilibriumStateAverage,tt)
% Determine if the system has reached equilibrium (steady-state): Implement
% Eq 36 from 'An improved peridynamic approach for quasi-static elastic
% deformation and brittle fracture analysis' - Huang et al, 2015

numeratorEquilibriumState=sum(nodalForce(1500,:));
denominatorEquilibriumState=sum(BODYFORCE(1500,:))*MAXBODYFORCE;
equilibriumState(tt,1)=sqrt(numeratorEquilibriumState^2)/sqrt(denominatorEquilibriumState^2);

[~,~,equilibriumStateNonZero]=find(equilibriumState); % equilbriumStateNonZero contains the non-zero elements of equilibriumState
equilibriumStateAverage(tt,1)=mean(equilibriumStateNonZero);

end