%% Bagged Decision Trees   20150726
%---------根据matlab程序给出的训练数据集整理成特征向量以及对应的label--------
%--Windowed method--
%--获取随机Feature：y(x1)-y(x2)
%-- Get y(center)-y(xi) xi==[left,right];

%% Updated on 20150917
% read QT data,orgnize it to Feature vectors
% according to random generated relations to produce feature vectors
%-- Get y(center)-y(xi) xi==[left,right];
%% Updated on 20150923
% add function sig2FV_format,to make feature modification convenient

function [FV,Labels]=func_sig2FV(FV,Labels,sig,Rindex,Window_Len,random_relations)
%% sliding window method


%  Window_Len=fs*2;%better be even cause half len proc...
 hlf_wlen=Window_Len/2;
 
 FeatureVec=[];%Feature vector
 LabelVec=[];
 
 %------20150725------
 %----遍历选取所有位置上的window存储量太大-----
 %-----------------选取中心是T波的window----------------------
 for ind=1:length(Rindex)
    t_ind=Rindex(ind);
    
    if t_ind<hlf_wlen||t_ind>length(sig)-hlf_wlen
        continue;
    end
    
%     ps=ind-hlf_wlen+1;
%     pe=ind+hlf_wlen;
    ps=t_ind-hlf_wlen+1;
    pe=t_ind+hlf_wlen;
    
    %---window sig[ps:pe]
    pt_sig=sig(ps:pe);
    %% check Positive sample
%     figure(1);
%     clf(figure(1));
%     plot(pt_sig);
%     hold on;
%     plot(length(pt_sig)/2,pt_sig(length(pt_sig)/2),'linestyle','none','Marker','o','Markersize',14);
%     waitforbuttonpress;
    
    if size(pt_sig,1)<size(pt_sig,2)%Ensure row vec
        pt_sig=transpose(pt_sig);
    end
    %% convert pt_sig to FV
    fVec=sig2FV_format(pt_sig,random_relations);
    % concat FeatureVec
    FeatureVec=[FeatureVec;fVec];
    
    isR=0;
    if numel(find(Rindex==t_ind))>0
        %is R:
        isR=1;
    else
        isR=0;
    end
    LabelVec=[LabelVec isR];
    
 end
 
 %----随机选取剩余的非R window----
 R_Cnt=length(Rindex);%正负样本数保证尽量相等
 
while(R_Cnt>0)
    R_Cnt=R_Cnt-1;

    %---Get a Random Index---
    %---随机选取Index值---
    ind=int32(round(hlf_wlen+(length(sig)-2*hlf_wlen)*rand));%random uniformly
    %---must in range---
    
    ps=ind-hlf_wlen+1;
    pe=ind+hlf_wlen;

    
    %---window sig[ps:pe]
    pt_sig=sig(ps:pe);
    %--- show window signal---
%     plot(pt_sig);
%     waitforbuttonpress;
    
    if size(pt_sig,1)<size(pt_sig,2)%Ensure row vec
        pt_sig=transpose(pt_sig);
    end
   %% convert pt_sig to FV
    fVec=sig2FV_format(pt_sig,random_relations);
    % concat FeatureVec
    FeatureVec=[FeatureVec;fVec];
    
    isR=0;
    if numel(find(Rindex==ind))>0
        %is R:
        isR=1;
    else
        isR=0;
    end
    LabelVec=[LabelVec isR];
    
 end
 
 %--------------------20150725得到training label-------------------------------------

 LabelVec=transpose(LabelVec);
 
 FV=[FV;FeatureVec];
 Labels=[Labels;LabelVec];
 