function [Vref,Vpos,nbObs,affectation,J_T,VrefInitial]=somTVar(testData,nbNeurone_L,nbNeurone_l,VrefInitial,Ti,Tf,Niter,p)

%testData est une matrice où chaque ligne est une observation.
%   Vref : l'ensemble des vecteurs référents
%   Vpos : position des vecteurs référents sur la carte
%   nbObs: nombre d'observations associés à chaque neurone
%   affectation: est le vecteur associe à chaque observation un neurone

m=nbNeurone_l*nbNeurone_L;    
%initialisation aléatoire des référents s'ils ne sont pas données en paramètre 
    if ( ~ isequal( size(VrefInitial), [m,size(testData,2)]) )
        %[Vref,Vpos,nbObs,affectation,J_T,iteration]=somTFix(testData,nbNeurone_L,nbNeurone_l,T,Niter,p)
        [VrefInitial,Vpos,~,~,~,~]=somTFix(testData,nbNeurone_L,nbNeurone_l,Ti,100,p);
    else
    %initialisation de Vpos sur la carte
        [x y]=meshgrid(1:nbNeurone_L,1:nbNeurone_l);
        Vpos=[reshape(x,m,1),reshape(y,m,1)];
    end

    
    nbObs=zeros(m,1);

  %distance entre les neurones

   dist=distN(Vpos,1);
    Vref=VrefInitial;
    for iteration=0:Niter
      T=Ti*(Tf/Ti)^(iteration/Niter);

  %phase d'affectation
      [affectation,K_T,J_T]=Affect_Opt(testData,Vref,dist,T,p);

  %phase de mise à jour de la valeur des référents
        Vref=UpdateVref(testData,affectation,K_T);

        for i=1:m
          nbObs(i)=length(find(affectation==i));
        end
    end

% visualisation des données
    save temp.mat;
    Extract('temp.mat');
    %keyboard;
    pause(3);
end
