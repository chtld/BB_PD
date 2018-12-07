function [stresstensor]=calculateStress(TOTALNODES,NOD,straintensor,MATERIALFLAG)

%% Load constants
dataMaterialProperties

%% Main body of calculateStress function

stresstensor = zeros(TOTALNODES,NOD,NOD);

if NOD==3
    
    for i=1:TOTALNODES
        
        if MATERIALFLAG(i,1)==0 % concrete 
           EffectiveModulus=EFFECTIVEMODULUSCONCRETE;
           v=V_CONCRETE;
           G=G_CONCRETE;
        elseif MATERIALFLAG(i,1)==1 % Steel
           EffectiveModulus=EFFECTIVEMODULUSSTEEL;
           v=V_STEEL;
           G=G_STEEL;
        end
        
        StressXX=EffectiveModulus*((1-v)*straintensor(i,1,1)+v*straintensor(i,2,2)+v*straintensor(i,3,3));
        StressXY=G*straintensor(i,1,2);
        StressXZ=G*straintensor(i,1,3);

        StressYX=StressXY;
        StressYY=EffectiveModulus*(v*straintensor(i,1,1)+(1-v)*straintensor(i,2,2)+v*straintensor(i,3,3));
        StressYZ=G*straintensor(i,2,3);

        StressZX=StressXZ;
        StressZY=StressYZ;
        StressZZ=EffectiveModulus*(v*straintensor(i,1,1)+v*straintensor(i,2,2)+(1-v)*straintensor(i,3,3));


        stresstensor(i,:,:)=[StressXX StressXY StressXZ; StressYX StressYY StressYZ; StressZX StressZY StressZZ];
        
   end
    
elseif NOD==2
    
      for i=1:TOTALNODES
          
        if MATERIALFLAG(i,1)==0 % concrete 
           EffectiveModulus=EffectiveModulusConcrete;
           v=v_concrete;
           G=G_concrete;
        elseif MATERIALFLAG(i,1)==1 % Steel
           EffectiveModulus=EffectiveModulusSteel;
           v=v_steel;
           G=G_steel;
        end
        
        StressXX=EffectiveModulus*((1-v)*straintensor(i,1,1)+v*straintensor(i,2,2));
        StressXY=G*straintensor(i,1,2);

        StressYX=StressXY;
        StressYY=EffectiveModulus*(v*straintensor(i,1,1)+(1-v)*straintensor(i,2,2));


        stresstensor(i,:,:)=[StressXX StressXY; StressYX StressYY];
        
      end
      
end

end

