function aff=Affect_Par(cellDataset,Vref,distNeurones,T,p,w)
  % Entrée:
  % cellDataset: observation à affecter aux différents neurones
  % Vref: Référent associé à chaque neurone
  % distNeurones: matrice des distances entre les différents neurones
  % T: paramètre de l'influence entre les neurones
  % p: la norme p à utiliser pour calculer la distance entre les référents
  %     et les neurones
  % w : nombre de processeurs à utiliser
  
  cellAff=cell(w,1);
  parfor i=1:w
      cellAff{i}=Affect_Opt(cellDataset{i},Vref,distNeurones,T,p);
  end
  
  aff=[];
  for i=1:w
    aff=[aff;cellAff{i}]; %#ok<AGROW>
  end
end