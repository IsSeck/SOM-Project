function [fig]=voir_2(vec,nl,nc,i)
%dessine l'image correspondante � vec (une image 16*16) dans la i-�me zone
%d'un subplot � nl lignes et nc colonnes

%visualisation des donn�es
B=reshape(vec,16,16)';
%figure;
subplot(nl,nc,i);
fig=imagesc(B);
colormap('gray');