%% convert signal segment to Feature vector
function FV=sig2FV_format(sig,random_relations)
    %---Convert current signal to FV---
    %-------------20150726-------------
    N=length(sig);
    
    Feature_Len=2*size(random_relations,2);
    %pre alloc memory
    FV=zeros([Feature_Len,1]);
    
    x1=random_relations(1,:);
    x2=random_relations(2,:);
    szR2=size(random_relations,2);
    %write to FV
    FV(1:szR2)=sig(x1)-sig(x2);
    FV(1+szR2:szR2*2)=abs(sig(x1)-sig(x2));
    %add raw signal Feature
%     FV(2*szR2+1:2*szR2+N)=sig;
    
    % transpose to col vector
    if size(FV,1)>size(FV,2)
        FV=transpose(FV);
    end
end