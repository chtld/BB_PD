% Determination of material points inside the horizon of each material
% point

function [nodefamily,nfpointer,UndeformedLength,NumFamMembVector,MaxNumFamMemb,bondlist,Totalbonds]=BuildHorizons(Totalnodes,coordinates,delta)

%% KD-tree
[NF,UL]=rangesearch(coordinates,coordinates,delta); % rangesearch is the KDTreeSearcher function for distance search.


%% Create node family data structure
counter=1;
for i=1:Totalnodes
    
    CurrentNodeFamilyTemp=NF{i}; % First element indicates the origin node
    CurrentNodeFamilyTemp(1)=[]; % Remove first element (origin node)
    %CurrentNodeFamily=sort(CurrentNodeFamilyTemp); % Sort nodes in ascending order
    CurrentNodeFamily=CurrentNodeFamilyTemp; 
    
    NumFamMemb=size(CurrentNodeFamily,2);
    NumFamMembVector(i,1)=NumFamMemb;    
    
    % Create list of pointers to node family members
    if i==1
        nfpointer(i,1)=1;
    else
        nfpointer(i,1)=nfpointer(i-1)+NumFamMembVector(i-1);
    end
      
    for j=1:NumFamMemb
        nodefamily(counter,1)=CurrentNodeFamily(1,j);
        counter=counter+1;
    end
    
end

%% Calculate undeformed length of every bond

MaxNumFamMemb=max(NumFamMembVector);               % Maximum number of family members
% UndeformedLength=zeros(Totalnodes,MaxNumFamMemb);  % Initialise matrix

for i=1:Totalnodes
    
    CurrentUndeformedLengthTemp=UL{i};
    CurrentUndeformedLengthTemp(1)=[];
    CurrentUndeformedLength=CurrentUndeformedLengthTemp;
    NumFamMemb=size(CurrentUndeformedLength,2);
   
%     for j=1:NumFamMemb
%         UndeformedLength(i,j)=CurrentUndeformedLength(1,j);
%     end

end

%% Create bond list

bondlist=zeros(size(nodefamily,1)/2,2);
% bondfamily=zeros(size(nodefamily,1),1);
counter1=0;
% counter2=0;

for i=1:Totalnodes
    % All nodes within Node 'i' sphere of influence
    for j=1:NumFamMembVector(i)
        % Consider bond between Node 'i' and Node 'cnode' 
        cnode=nodefamily(nfpointer(i)+(j-1),1);
        if cnode>i % if i is greater than cnode, the corresponding bond has already been added to the list. The following link explains other methods to prevent the double checking of indices https://stackoverflow.com/questions/31961009/java-how-to-stop-nested-loops-from-checking-same-indices-twice
           counter1=counter1+1;
           bondlist(counter1,:)=[i cnode]; 
        end
%         counter2=counter2+1;
%         bondfamily(counter2,1)=find(bondlist(:,1)==i & bondlist(:,2)==cnode |  bondlist(:,1)==cnode & bondlist(:,2)==i);
    end
end

Totalbonds=counter1;



UndeformedLength=zeros(Totalbonds,1);

for i=1:size(bondlist,1)
    nodei=bondlist(i,1);
    nodej=bondlist(i,2);
    UndeformedLength(i)=(coordinates(nodei,1)-coordinates(nodej,1))^2+(coordinates(nodei,2)-coordinates(nodej,2))^2+(coordinates(nodei,3)-coordinates(nodej,3))^2;
end

UndeformedLength=sqrt(UndeformedLength);

end