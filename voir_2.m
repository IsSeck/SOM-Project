function [fig]=voir_2(vec,nl,nc,i)
%dessine l'image correspondante à vec (une image 16*16) dans la i-ème zone
%d'un subplot à nl lignes et nc colonnes

%visualisation des données
B=reshape(vec,16,16)';
%figure;
subplot(nl,nc,i);
fig=imagesc(B);
colormap('gray');