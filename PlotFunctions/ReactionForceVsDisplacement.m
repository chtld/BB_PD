% Plot displacement vs time

function ReactionForceVsDisplacement(ReactionForce,Displacement_node)


figure;
plot(-Displacement_node,-ReactionForce)
xlabel('Displacement (m)')
ylabel('ReactionForce') 


end 