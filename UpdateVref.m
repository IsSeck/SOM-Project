function Vref=UpdateVref(dataset,affectation,K_T)
    %K_T est la matrice contenant les valeurs de la fonction K_T utilisé
    %pour définir le degré de voisinage ...


    m=size(K_T,1);%nombre de référents=nombre de neurones sur la carte
    nbObs=zeros(m,1);
    Resultant=zeros(m,size(dataset,2));
    Vref=Resultant;
    for i=1:m
        tempAff=find(affectation==i);
        nbObs(i)=length(tempAff);
        Resultant(i,:)=sum(dataset(tempAff,:));
    end
    
    for i=1:m
       num=zeros(1,size(dataset,2));
       for j=1:m
%           num=num+exp(-norm(Vpos(i,:)-Vpos(j,:),1))*Resultant(j,:);
%           den=den+exp(-norm(Vpos(i,:)-Vpos(j,:),1))*nbObs(j);s   
            num=num + K_T(i,j)*Resultant(j,:);
       end
       %den=sum( exp(-distNeur(i,:)./T) 
       den=K_T(i,:)*nbObs;
       Vref(i,:)=num/den;
    end
end