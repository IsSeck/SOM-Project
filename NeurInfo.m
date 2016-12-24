function [Neurone]=NeurInfo(affectation,label,m)

%Cette fonction prend en entr�e les affections de chaque observation, la
%classe de cette observation et m, le nombre de neurones. Elle renvoie, un cell qui est de
%longueur le nombre de neurones de la carte et contenant:
%   - nbObs : le nombre d'observations affect�es � chaque neurone
%   - effPerClass : une matrice � deux colonnes: pour chaque classe affect� � un neurone
%       l'effectif de la classe sur ce neurone
%   - class: qui est la classe de ce neurone avec le plus grand effectif
%   - obsAff: les indices correspondant aux lignes ayant �t� affect�es � un
%       neurone

Neurone=struct('nbObs',[],'effPerClass',[],'Class',[],'obsAff',[]);
%Neurones=cell(m);

%calcul du nombre d'observation par 
for i=1:m
    Itemp=find(affectation==i);% (indice des) observations affect�es au neurone i;
    Neurone(i).obsAff=Itemp;% 
    Neurone(i).nbObs=length(Itemp);
    labelTemp=label(Itemp); %r�cup�ration des labels associ�s au neurone i;
    distinctLblTemp=unique(labelTemp);% r�cup�ration des diff�rents labels
    nbDistinct=length(distinctLblTemp);% Nombre de labels diff�rents
    Neurone(i).effPerClass=zeros(length(distinctLblTemp),2);
    
    %calcul de l'effectif associ� � chaque neurone( � chaque r�f�rent)
    for j=1:nbDistinct
        Neurone(i).effPerClass(j,:)=[distinctLblTemp(j), length(find(labelTemp==distinctLblTemp(j)))];
    end
    
   [~,Itemp]=max(Neurone(i).effPerClass(:,2)); %r�cup�ration de l'indice de la classe ayant le plus grand effectif
   Neurone(i).Class=distinctLblTemp(Itemp); % affectation du neurone � cette classe
   if isempty(Neurone(i).Class) % si le neurone n'est associ� � aucune observation, alors sa classe est -1
      Neurone(i).Class=-1; 
   end
end

