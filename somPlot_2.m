function []= somPlot_2(AdjAugm,Vpos,Neurones)
% AdjAugm est une "matrice d'adjacence" dans laquelle seules les
% noeuds(neurones) ayant une distance 1 sont voisins

m=size(AdjAugm,1);

 %visualisation des données
 hold off;
 figure;
 hold on;
    for i=1:m
        switch Neurones(i).Class
            
            case -1
                color=[1 1 1];
            case 0
                color=[0 0 0];
            case 1
                color=[0 0 1];
            case 2
                color=[0 1 0];
            case 3
                color=[0 1 1];
            case 4
                color=[1 0 0];
            case 5
                color=[1 0 1];
            case 6
                color=[1 1 0];
            case 7
                color=[0.5 0.5 0.5];
            case 8
                color=[0 0 0.5];
            case 9
                color=[0 0.5 0];
            case 10
                color=[0.5 0 0];
        end
        plot(Vpos(i,1),Vpos(i,2),'o','Color',color,'MarkerSize',30,'MarkerFaceColor',color);
    end

for i=1:m
   for j=i+1:m
      if(AdjAugm(i,j)==1)
         plot(Vpos([i j],1),Vpos([i j],2)); 
      end
   end
end
camroll(-90); %faire pivoter la carte afin de rendre l'affichage plus intuitif

hold off;