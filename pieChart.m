function []=pieChart(effPerClass,nl,nc,i)

%cette fonction prend en entrée une matrice effPerClass pour un neurone
%donné et en trace le diagramme en camembert
labels=effPerClass(:,1)';%le chiffre correspondant à la classe... 
labels=strread(num2str(labels),'%s');
%labels=num2cell(labels);
%keyboard
subplot(nl,nc,i);
pie(effPerClass(:,2),labels);