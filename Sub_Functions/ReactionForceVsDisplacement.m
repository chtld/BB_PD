% Plot displacement vs time

function ReactionForceVsDisplacement(ReactionForce,Displacement_node)


figure(100)
plot(-Displacement_node,-ReactionForce)
xlabel('Displacement (m)')
ylabel('ReactionForce') 


end 