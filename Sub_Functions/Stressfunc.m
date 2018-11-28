function [StressTensor]=Stressfunc(Totalnodes,Nod,MaterialProperties,coordinates,disp,StrainTensor,MaterialFlag)

StressTensor = zeros(Totalnodes,Nod,Nod);

if Nod==3
    
    %for i=1:Totalnodes
        
        i=66321;
        
        if MaterialFlag(i,1)==0 % concrete 
           EffectiveModulus=MaterialProperties.EffectiveModulusConcrete;
           v=MaterialProperties.v_concrete;
           G=MaterialProperties.G_concrete;
        elseif MaterialFlag(i,1)==1 % Steel
           EffectiveModulus=MaterialProperties.EffectiveModulusSteel;
           v=MaterialProperties.v_steel;
           G=MaterialProperties.G_steel;
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
        
    %end
    
elseif Nod==2
    
      for i=1:Totalnodes
          
        if MaterialFlag(i,1)==0 % concrete 
           EffectiveModulus=MaterialProperties.EffectiveModulusConcrete;
           v=MaterialProperties.v_concrete;
           G=MaterialProperties.G_concrete;
        elseif MaterialFlag(i,1)==1 % Steel
           EffectiveModulus=MaterialProperties.EffectiveModulusSteel;
           v=MaterialProperties.v_steel;
           G=MaterialProperties.G_steel;
        end
        
        StressXX=EffectiveModulus*((1-v)*StrainTensor(i,1,1)+v*StrainTensor(i,2,2));
        StressXY=G*StrainTensor(i,1,2);

        StressYX=StressXY;
        StressYY=EffectiveModulus*(v*StrainTensor(i,1,1)+(1-v)*StrainTensor(i,2,2));


        StressTensor(i,:,:)=[StressXX StressXY; StressYX StressYY];
        
      end
end

% Stress Plot
% pointsize=1;
% figure;
% scatter3(coordinates(:,1)+(disp(:,1,1)*10),coordinates(:,2)+(disp(:,2,1)*10),coordinates(:,3)+(disp(:,3,1)*10),pointsize,StressTensor(:,2,1))
% title('Stress')
% axis equal
% colormap jet 
% colorbar


end

