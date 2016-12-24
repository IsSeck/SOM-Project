%script de visualisation des données
for i=1:10
temp=find(y==i);
voir_2( mean( x(temp,:)),2,5,i);
end