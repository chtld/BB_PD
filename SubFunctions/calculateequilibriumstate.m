function [equilibrium]=calculateequilibriumstate(nodalForce,BODYFORCE,MAXBODYFORCE,equilibrium,tt)
% Determine if the system has reached equilibrium (steady-state): Implement
% Eq 36 from 'An improved peridynamic approach for quasi-static elastic
% deformation and brittle fracture analysis' - Huang et al, 2015

numeratorEquilibrium=sum(nodalForce(1500,:));
denominatorEquilibrium=sum(BODYFORCE(1500,:))*MAXBODYFORCE;
equilibrium(tt,1)=sqrt(numeratorEquilibrium^2)/sqrt(denominatorEquilibrium^2);

end