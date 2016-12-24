function d=distN(Vpos,p)
    
    m=size(Vpos,1);
    d=zeros(m,m);
    
    for i=1:m
       for j=i+1:m
            
            d(i,j)=norm(Vpos(i,:)-Vpos(j,:),p);
            d(j,i)=d(i,j);
           
       end
    end
    
end