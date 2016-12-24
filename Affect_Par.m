function aff=Affect_Par(cellDataset,Vref,distNeurones,T,p,w)
  % Entr�e:
  % cellDataset: observation � affecter aux diff�rents neurones
  % Vref: R�f�rent associ� � chaque neurone
  % distNeurones: matrice des distances entre les diff�rents neurones
  % T: param�tre de l'influence entre les neurones
  % p: la norme p � utiliser pour calculer la distance entre les r�f�rents
  %     et les neurones
  % w : nombre de processeurs � utiliser
  
  cellAff=cell(w,1);
  parfor i=1:w
      cellAff{i}=Affect_Opt(cellDataset{i},Vref,distNeurones,T,p);
  end
  
  aff=[];
  for i=1:w
    aff=[aff;cellAff{i}]; %#ok<AGROW>
  end
end