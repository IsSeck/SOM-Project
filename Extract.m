function []=Extract(nomFichier)

%affectation contient le neurone auquel est affecté chaque observation

load(nomFichier);
affRef=find(nbObs>0);

[nl,nc]=goodSubplot(length(affRef));

close all; 
figure;
hold on;

for i=1:length(affRef)

    voir_2(Vref(affRef(i),:),nl,nc,i); %#ok<NODEF>
    title(num2str(affRef(i)));
end

hold off;

m=size(Vref,1);
 Neurones=NeurInfo(affectation,y,m);
figure;
hold
for i=1:length(affRef)
    pieChart(Neurones(affRef(i)).effPerClass,nl,nc,i);
    title( strcat(num2str(affRef(i)), {' '},num2str(nbObs(affRef(i)))) );
end

hold off;

%Représentation de la carte
d=distN(Vpos,1);%pour la carte de base. Pour la carte avec le voisinage "nid d'abeille"
%il faut utiliser la fonction distHoneyComb(nécessite une légère modification du code de som_simplist_Opt)
somPlot_2(d,Vpos,Neurones);

pause(5);
figure;
%représentation des données après les avoir centrées
for i=1:length(affRef)
    tempAff=Neurones(affRef(i)).obsAff;
    if (length(tempAff)>1)
        Vref(affRef(i),:)= mean( x(tempAff,:) ); %#ok<NODEF,AGROW>
    else 
        Vref(affRef(i),:)=x(tempAff,:); %#ok<NODEF,AGROW>
    end
        voir_2(Vref(affRef(i),:),nl,nc,i); 
    title( strcat( num2str(affRef(i)),{' '}, 'r' ));
end