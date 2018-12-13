function [stressTensor]=calculatestress(nNODES,NOD,strainTensor,MATERIALFLAG)

%% Load constants
datamaterialproperties

%% Main body of calculatestress function

stressTensor = zeros(nNODES,NOD,NOD);

if NOD==3
    
    for i=1:nNODES
        
        if MATERIALFLAG(i,1)==0 % concrete 
           EM=EFFECTIVEMODULUSCONCRETE;
           v=V_CONCRETE;
           G=G_CONCRETE;
        elseif MATERIALFLAG(i,1)==1 % Steel
           EM=EFFECTIVEMODULUSSTEEL;
           v=V_STEEL;
           G=G_STEEL;
        end
        
        stressXX=EM*((1-v)*strainTensor(i,1,1)+v*strainTensor(i,2,2)+v*strainTensor(i,3,3));
        stressXY=G*strainTensor(i,1,2);
        stressXZ=G*strainTensor(i,1,3);

        stressYX=stressXY;
        stressYY=EM*(v*strainTensor(i,1,1)+(1-v)*strainTensor(i,2,2)+v*strainTensor(i,3,3));
        stressYZ=G*strainTensor(i,2,3);

        stressZX=stressXZ;
        stressZY=stressYZ;
        stressZZ=EM*(v*strainTensor(i,1,1)+v*strainTensor(i,2,2)+(1-v)*strainTensor(i,3,3));


        stressTensor(i,:,:)=[stressXX stressXY stressXZ; stressYX stressYY stressYZ; stressZX stressZY stressZZ];
        
   end
    
elseif NOD==2
    
      for i=1:nNODES
          
        if MATERIALFLAG(i,1)==0 % concrete 
           EM=EffectiveModulusConcrete;
           v=v_concrete;
           G=G_concrete;
        elseif MATERIALFLAG(i,1)==1 % Steel
           EM=EffectiveModulusSteel;
           v=v_steel;
           G=G_steel;
        end
        
        stressXX=EM*((1-v)*strainTensor(i,1,1)+v*strainTensor(i,2,2));
        stressXY=G*strainTensor(i,1,2);

        stressYX=stressXY;
        stressYY=EM*(v*strainTensor(i,1,1)+(1-v)*strainTensor(i,2,2));


        stressTensor(i,:,:)=[stressXX stressXY; stressYX stressYY];
        
      end
      
end

end

