function [StressTensor]=Stress(Totalnodes,Nod,EffectiveModulusConcrete,EffectiveModulusSteel,v_concrete,v_steel,G_concrete,G_steel,coordinates,Displacement,StrainTensor,MaterialFlag)

StressTensor = zeros(Totalnodes, Nod, Nod);

if Nod==3
    
    for i=1:Totalnodes
        
        if MaterialFlag(i,1)==0 % concrete 
           EffectiveModulus=EffectiveModulusConcrete;
           v=v_concrete;
           G=G_concrete;
        elseif MaterialFlag(i,1)==1 % Steel
           EffectiveModulus=EffectiveModulusSteel;
           v=v_steel;
           G=G_steel;
        end
        
        StressXX=EffectiveModulus*((1-v)*StrainTensor(i,1,1)+v*StrainTensor(i,2,2)+v*StrainTensor(i,3,3));
        StressXY=G*StrainTensor(i,1,2);
        StressXZ=G*StrainTensor(i,1,3);

        StressYX=StressXY;
        StressYY=EffectiveModulus*(v*StrainTensor(i,1,1)+(1-v)*StrainTensor(i,2,2)+v*StrainTensor(i,3,3));
        StressYZ=G*StrainTensor(i,2,3);

        StressZX=StressXZ;
        StressZY=StressYZ;
        StressZZ=EffectiveModulus*(v*StrainTensor(i,1,1)+v*StrainTensor(i,2,2)+(1-v)*StrainTensor(i,3,3));


        StressTensor(i,:,:)=[StressXX StressXY StressXZ; StressYX StressYY StressYZ; StressZX StressZY StressZZ];
        
    end
    
elseif Nod==2
    
      for i=1:Totalnodes
          
        if MaterialFlag(i,1)==0 % concrete 
           EffectiveModulus=EffectiveModulusConcrete;
           v=v_concrete;
           G=G_concrete;
        elseif MaterialFlag(i,1)==1 % Steel
           EffectiveModulus=EffectiveModulusSteel;
           v=v_steel;
           G=G_steel;
        end
        
        StressXX=EffectiveModulus*((1-v)*StrainTensor(i,1,1)+v*StrainTensor(i,2,2));
        StressXY=G*StrainTensor(i,1,2);

        StressYX=StressXY;
        StressYY=EffectiveModulus*(v*StrainTensor(i,1,1)+(1-v)*StrainTensor(i,2,2));


        StressTensor(i,:,:)=[StressXX StressXY; StressYX StressYY];
        
      end
end

% Stress Plot
pointsize=1;
figure(6)
scatter3(coordinates(:,1)+(Displacement(:,1,1)*10),coordinates(:,2)+(Displacement(:,2,1)*10),coordinates(:,3)+(Displacement(:,3,1)*10),pointsize,StressTensor(:,3,3))
axis equal
colormap jet 
colorbar


end

