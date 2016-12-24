function [Neurone]=NeurInfo(affectation,label,m)

%Cette fonction prend en entrée les affections de chaque observation, la
%classe de cette observation et m, le nombre de neurones. Elle renvoie, un cell qui est de
%longueur le nombre de neurones de la carte et contenant:
%   - nbObs : le nombre d'observations affectées à chaque neurone
%   - effPerClass : une matrice à deux colonnes: pour chaque classe affecté à un neurone
%       l'effectif de la classe sur ce neurone
%   - class: qui est la classe de ce neurone avec le plus grand effectif
%   - obsAff: les indices correspondant aux lignes ayant été affectées à un
%       neurone

Neurone=struct('nbObs',[],'effPerClass',[],'Class',[],'obsAff',[]);
%Neurones=cell(m);

%calcul du nombre d'observation par 
for i=1:m
    Itemp=find(affectation==i);% (indice des) observations affectées au neurone i;
    Neurone(i).obsAff=Itemp;% 
    Neurone(i).nbObs=length(Itemp);
    labelTemp=label(Itemp); %récupération des labels associés au neurone i;
    distinctLblTemp=unique(labelTemp);% récupération des différents labels
    nbDistinct=length(distinctLblTemp);% Nombre de labels différents
    Neurone(i).effPerClass=zeros(length(distinctLblTemp),2);
    
    %calcul de l'effectif associé à chaque neurone( à chaque référent)
    for j=1:nbDistinct
        Neurone(i).effPerClass(j,:)=[distinctLblTemp(j), length(find(labelTemp==distinctLblTemp(j)))];
    end
    
   [~,Itemp]=max(Neurone(i).effPerClass(:,2)); %récupération de l'indice de la classe ayant le plus grand effectif
   Neurone(i).Class=distinctLblTemp(Itemp); % affectation du neurone à cette classe
   if isempty(Neurone(i).Class) % si le neurone n'est associé à aucune observation, alors sa classe est -1
      Neurone(i).Class=-1; 
   end
end

