function [Vref,Vpos,nbObs,affectation,J_T,iteration]=somTFix(testData,nbNeurone_L,nbNeurone_l,T,Niter,p)

%tentative de mise à jour en incorporant la condition d'arrêt liée à la stabilisation des vecteurs référents

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
    [x y]=meshgrid(1:nbNeurone_L,1:nbNeurone_l);
    Vpos=[reshape(x,m,1),reshape(y,m,1)];
    
%initialisation aléatoire des référents 
    ech=ceil( size(testData,1)/m);
    
    if (ech<50)
       ech=100; 
    end
    
    for i=1:m
        Vref(i,:)=initialisationRef(testData,ech);
    end

   oldVref=Vref;
   newVref=[];
  %distance entre les neurones
   dist=distN(Vpos,p);
   
   iteration=0;
   while (~isequal(oldVref,newVref) && (iteration<Niter) )
        
       iteration=iteration+1;
       %phase d'affectation
     [affectation,K_T,J_T]=Affect_Opt(testData,oldVref,dist,T,p);
     
     
     %phase de mise à jour de la valeur des référents
      newVref=UpdateVref(testData,affectation,K_T);
      
      if (~isequal(oldVref,newVref))
         oldVref=newVref;
         newVref=[];
      end
      
      for i=1:m
        nbObs(i)=length(find(affectation==i));
      end
  
    end
        save temp.mat;
        Extract('temp.mat');
        %keyboard;
        pause(3);
    %   toc
end

function ref=initialisationRef(testData,number)
    alea=randperm(size(testData,1));
    alea=alea(1:number);
    
    ref=mean(testData(alea,:));   
end
