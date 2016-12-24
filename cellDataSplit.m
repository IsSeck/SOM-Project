function cellDataset= cellDataSplit(dataset,w)
    %sépare les observations dataset en w parties distinctes enregistrées
    %dans la cellule cellDataset
    cellDataset=cell(w,1);
    nbTotalObs=size(dataset,1);
    
    nbObsPerCell=floor(nbTotalObs/w);
    
    cellDataset{1}=dataset(1:nbObsPerCell,:);    
    for i=2:w-1
       Interval=(i-1)*nbObsPerCell+1:i*nbObsPerCell;
       cellDataset{i}=dataset(Interval ,:); 
    end 
    cellDataset{w}=dataset((w-1)*nbObsPerCell+1:nbTotalObs,:);
end