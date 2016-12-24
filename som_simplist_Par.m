function [Vref,Vpos,nbObs,affectation]=som_simplist_Par(testData,nbNeurone_L,nbNeurone_l,Ti,Tf,Niter,p)

%testData est une matrice où chaque ligne est une observation.

%   Vref : l'ensemble des vecteurs référents
%   Vpos : position des vecteurs référents sur la carte
%   nbObs: nombre d'observations associés à chaque neurone
%   affectation: est le vecteur associe à chaque observation un neurone
   
%tic

    
    m=nbNeurone_l*nbNeurone_L;
    Vref=zeros(m , size(testData,2));
    nbObs=zeros(m,1);

%initialisation de Vpos sur la carte
    [l c]=meshgrid(1:nbNeurone_L,1:nbNeurone_l);
    Vpos=[reshape(l,m,1),reshape(c,m,1)];
%temporaire    
    load usps; %pour la fonction research
%initialisation aléatoire des référents
    
    %ech=ceil( 4*size(testData,1)/m)
    %ech=1;
    ech=200;
    for i=1:m
        Vref(i,:)=initialisationRef(testData,ech);
    end

    
% Initialisation du nombre de processeurs
    if matlabpool('size')==0
        matlabpool('open');
    end
    w=matlabpool('size');
%Séparation des données pour la parallélisation
    cellDataset=cellDataSplit(testData,w);
%Duplication de Vref dans plusieurs CellVref
    cellVref=cell(w,1);
    for i=1:w
        cellVref{i}=Vref;
    end
 

  %distance entre les neurones
   dist=distN(Vpos,1);
   
   
   
    for iteration=0:Niter
   % iteration
    %T
    T=Ti*(Tf/Ti)^(iteration/Niter);
    %phase d'affectation
     affectation=Affect_Par(cellDataset,Vref,dist,T,p,w);
     
     %phase de mise à jour de la valeur des référents
      Vref=UpdateVref(testData,affectation,Vpos);
       
      for i=1:m
        nbObs(i)=length(find(affectation==i));
      end
      
      if (mod(iteration,25)==0)
          save temp.mat;
          Extract('temp.mat');
          %keyboard;
          pause(3);
      end
    end
    
   
    
   matlabpool('close');
 %   toc
end

function ref=initialisationRef(testData,number)
    alea=randperm(size(testData,1));
    alea=alea(1:number);
    
    ref=mean(testData(alea,:));   
end

% function aff=Affect_Par(cellDataset,Vref,distNeurones,T,p,w)
%   % Entrée:
%   % cellDataset: observation à affecter aux différents neurones
%   % Vref: Référent associé à chaque neurone
%   % distNeurones: matrice des distances entre les différents neurones
%   % T: paramètre de l'influence entre les neurones
%   % p: la norme p à utiliser pour calculer la distance entre les référents
%   %     et les neurones
%   % w : nombre de processeurs à utiliser
%   
%   cellAff=cell(w,1);
%   parfor i=1:w
%       cellAff{i}=Affect_Opt(cellDataset{i},Vref,distNeurones,T,p);
%   end
%   
%   aff=[];
%   for i=1:w
%     aff=[aff;cellAff{i}]; %#ok<AGROW>
%   end
% end
% 
% function aff=Affect_Opt(dataset,Vref,distNeurones,T,p)
%         
%    m=size(Vref,1);
%    
%    nbTotalObs=size(dataset,1);
%    distG=zeros(nbTotalObs,m);
% %calcul de la distance euclidienne entre chaque observation et chaque
% %neurone
% 
%     distP=zeros(nbTotalObs,m);
%     
%     
%     for i=1:nbTotalObs
%         for j=1:m
%             distP(i,j)=norm(dataset(i,:)-Vref(j,:),p);
%         end
%     end
%    
%     distNeurones=exp(-distNeurones/T);
%     
%   
%     
%    
%     for i=1:nbTotalObs
%         
%         
%         %tempDistP=repmat(distP(i,:),m,1);
%         for j=1:m
%          %   distG(i,j)=sum( tempDistP(j,:).*distNeurones(j,:) );
%             distG(i,j)=sum( distP(i,:).*distNeurones(j,:) );
%         end
%     end
%     %[~,I]=min(dist);
%   %  keyboard
%     [~,aff]=min(distG,[],2);
%     
% end
% 
% function cellDataset= cellDataSplit(dataset,w)
%     %sépare les observations dataset en w parties distinctes enregistrées
%     %dans la cellule cellDataset
%     cellDataset=cell(w,1);
%     nbTotalObs=size(dataset,1);
%     
%     nbObsPerCell=floor(nbTotalObs/w);
%     
%     cellDataset{1}=dataset(1:nbObsPerCell,:);    
%     for i=2:w-1
%        Interval=(i-1)*nbObsPerCell+1:i*nbObsPerCell;
%        cellDataset{i}=dataset(Interval ,:); 
%     end 
%     cellDataset{w}=dataset((w-1)*nbObsPerCell+1:nbTotalObs,:);
% end
% 
% 
% 
% function Vref=UpdateVref(dataset,affectation,Vpos)
%     
%     m=size(Vpos,1);%nombre de référents=nombre de neurones sur la carte
%     nbObs=zeros(1,m);
%     Resultant=zeros(m,size(dataset,2));
%     Vref=Resultant;
%     for i=1:m
%         tempAff=find(affectation==i);
%         nbObs(i)=length(tempAff);
%         %Resultant(i,:)=sum(affectation(tempAff))/nbObs(i);
%         Resultant(i,:)=sum(dataset(tempAff,:));
%     end
%     
%     for i=1:m
%        num=zeros(1,size(dataset,2));
%        den=0;
%        for j=1:m
%           num=num+exp(-norm(Vpos(i,:)-Vpos(j,:),1))*Resultant(j,:);
%           den=den+exp(-norm(Vpos(i,:)-Vpos(j,:),1))*nbObs(j);
%        end
%        %den=sum( exp(-distNeur(i,:)./T) );
%        Vref(i,:)=num/den;
%     end
% end
% 
% 
% function d=distN(Vpos,p)
%     
%     m=size(Vpos,1);
%     d=zeros(m,m);
%     
%     for i=1:m
%        for j=i+1:m
%             
%             d(i,j)=norm(Vpos(i,:)-Vpos(j,:),p);
%             d(j,i)=d(i,j);
%            
%        end
%     end
%     
% end