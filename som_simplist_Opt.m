function [Vref,Vpos,nbObs,affectation]=som_simplist_Opt(testData,nbNeurone_L,nbNeurone_l,Ti,Tf,Niter,p)

%testData est une matrice où chaque ligne est une observation.

%   Vref : l'ensemble des vecteurs référents
%   Vpos : position des vecteurs référents sur la carte
%   nbObs: nombre d'observations associés à chaque neurone
%   affectation: est le vecteur associe à chaque observation un neurone
   
tic
    m=nbNeurone_l*nbNeurone_L;
    Vref=zeros(m , size(testData,2));
    nbObs=zeros(m,1);

%initialisation de Vpos sur la carte
    [x y]=meshgrid(1:nbNeurone_L,1:nbNeurone_l);
    Vpos=[reshape(x,m,1),reshape(y,m,1)];
    
%initialisation aléatoire des référents 
    ech=ceil( size(testData,1)/m);
    rand('state',0); %#ok<RAND>
    for i=1:m
        Vref(i,:)=initialisationRef(testData,ech);
    end

     %Som2D_Plot(testData,Vref,nbNeurone_L,nbNeurone_l)
      %      drawnow;
          
    
%    if size(dataset,2)==2
%         Som2D_Plot(testData,Vref,L,l);
%    end
   
  %distance entre les neurones
   dist=distN(Vpos,1);
   
    for iteration=0:Niter
   % iteration
    %T
    T=Ti*(Tf/Ti)^(iteration/Niter);
    %phase d'affectation
     affectation=Affect_Opt(testData,Vref,dist,T,p);
     
     
     %phase de mise à jour de la valeur des référents
      Vref=UpdateVref(testData,affectation,Vpos);
       
      for i=1:m
        nbObs(i)=length(find(affectation==i));
      end
      
     % if mod(iteration,50)==0 
     %  keyboard
      %      if size(testData,2)==2
%             
%             Som2D_Plot(testData,Vref,nbNeurone_L,nbNeurone_l)
%             %somPlot(dist,Vpos);
%             drawnow;
            %keyboard
       %     end
     % end
        
      
    end
    
    for i=1:m
        nbObs(i)=length(find(affectation==i));
    end
%     nbObs
    
    toc
end

function ref=initialisationRef(testData,number)
    alea=randperm(size(testData,1));
    alea=alea(1:number);
    
    ref=mean(testData(alea,:));   
end

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




function Vref=UpdateVref(dataset,affectation,Vpos)
    
    m=size(Vpos,1);%nombre de référents=nombre de neurones sur la carte
    nbObs=zeros(1,m);
    Resultant=zeros(m,size(dataset,2));
    Vref=Resultant;
    for i=1:m
        tempAff=find(affectation==i);
        nbObs(i)=length(tempAff);
        %Resultant(i,:)=sum(affectation(tempAff))/nbObs(i);
        Resultant(i,:)=sum(dataset(tempAff,:));
    end
    
    for i=1:m
       num=zeros(1,size(dataset,2));
       den=0;
       for j=1:m
          num=num+exp(-norm(Vpos(i,:)-Vpos(j,:),1))*Resultant(j,:);
          den=den+exp(-norm(Vpos(i,:)-Vpos(j,:),1))*nbObs(j);
       end
       %den=sum( exp(-distNeur(i,:)./T) );
       Vref(i,:)=num/den;
    end
end


function []= Som2D_Plot(dataset,Vref,L,l)
    
    %visualisation des données 
    plot(dataset(:,1),dataset(:,2),'k. ');
    hold on;
    
    %visualisation du réseau de neurone pour la grille de base
    for i=1:L
        temp=1+(i-1)*l:i*l;
        plot(Vref(temp,1),Vref(temp,2),'bo-');
    end

   for i=1:l
      temp=i:l:L*l;
      plot(Vref(temp,1),Vref(temp,2));
   end
    
    
    hold off;
end

function d=distN(Vpos,p)
    
    m=size(Vpos,1);
    d=zeros(m,m);
    
    for i=1:m
       for j=i+1:m
            
            d(i,j)=norm(Vpos(i,:)-Vpos(j,:),p);
            d(j,i)=d(i,j);
           
       end
    end
    
end