function aff=Affect_Opt(dataset,Vref,distNeurones,T,p)
        
   m=size(Vref,1);
   
   nbTotalObs=size(dataset,1);
   distG=zeros(nbTotalObs,m);
%calcul de la distance euclidienne entre chaque observation et chaque
%neurone

    distP=zeros(nbTotalObs,m);
    
    
    for i=1:nbTotalObs
        for j=1:m
            distP(i,j)=norm(dataset(i,:)-Vref(j,:),p);
        end
    end
   
    distNeurones=exp(-distNeurones/T);
    
  
    
   
    for i=1:nbTotalObs
        
        
        %tempDistP=repmat(distP(i,:),m,1);
        for j=1:m
         %   distG(i,j)=sum( tempDistP(j,:).*distNeurones(j,:) );
            distG(i,j)=sum( distP(i,:).*distNeurones(j,:) );
        end
    end
    %[~,I]=min(dist);
  %  keyboard
    [~,aff]=min(distG,[],2);
    
end