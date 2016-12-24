function [Vref,Vpos,nbObs,affectation,J_T]=somTFix(testData,nbNeurone_L,nbNeurone_l,T,Niter,p)
%testData est une matrice o� chaque ligne est une observation.

%   Vref : l'ensemble des vecteurs r�f�rents
%   Vpos : position des vecteurs r�f�rents sur la carte
%   nbObs: nombre d'observations associ�s � chaque neurone
%   affectation: est le vecteur associe � chaque observation un neurone
   
%tic
    m=nbNeurone_l*nbNeurone_L;
    Vref=zeros(m , size(testData,2));
    nbObs=zeros(m,1);

%initialisation de Vpos sur la carte
    [x y]=meshgrid(1:nbNeurone_L,1:nbNeurone_l);
    Vpos=[reshape(x,m,1),reshape(y,m,1)];
    
%initialisation al�atoire des r�f�rents 
    ech=ceil( size(testData,1)/m);
    
    if (ech<50)
       ech=100; 
    end
    
    for i=1:m
        Vref(i,:)=initialisationRef(testData,ech);
    end

   
  %distance entre les neurones
   dist=distN(Vpos,p);
   
    for iteration=0:Niter
   % iteration
  
    %phase d'affectation
     [affectation,K_T,J_T]=Affect_Opt(testData,Vref,dist,T,p);
     
     
     %phase de mise � jour de la valeur des r�f�rents
      Vref=UpdateVref(testData,affectation,K_T);
       
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