%% 使用Treebagger模型测试信号R波
%---20150726---
%---并行化---
%---random feature test with rand relation input----

function [Rindex,Pscore]=func_TreeBaggerQT_Test_cat(BaggerModel,WindowLen,random_relations,signal_in)


%% Test using RF
hlf_wlen=WindowLen/2;
%% try to preallocation memory to Rindex & Pscore
%-- Treat them as stacks
Rindex=[];
Pscore=[];
% Rindex=zeros(length(signal_in),1);
% Rindex_top=1;
% Pscore=zeros(length(signal_in),1);


Bagger_B=BaggerModel;

% random_relations=rand_rel;
if(size(signal_in,1)>size(signal_in,2))
    %[signal 0 0 0 0 0 0 0 0] row vec--
    signal_in=transpose(signal_in);
end
% parobj=parpool;%start parallel tool
% tic
Feature_Len=2*size(random_relations,2);


%% add 3rd party tool: parfor progressbar
N=(length(signal_in)-2*hlf_wlen);

pctRunOnAll javaaddpath F:\TU\心电\DNN\TreeBagger_windowedMethod\T_wave_detection\ParforProgMonv2\java\;
progressStepSize = int32(floor(N/1000));
ppm = ParforProgMon('Example: ', N, progressStepSize, 300, 80);

%% parfor loop
%拼合step长度
step_len=3e3;
Range_End=int32(floor(1+(length(signal_in)-hlf_wlen)/step_len));
Range_Len=(length(signal_in)-hlf_wlen)-hlf_wlen;
Range_Start=hlf_wlen;
Test_End=(length(signal_in)-hlf_wlen);

parfor ind=1:int32(ceil(Range_Len/step_len))
    
    %% Test
    %拼合成特征矩阵
    Features=zeros([step_len,Feature_Len]);
    Si=step_len*ind+Range_Start;
    prd_Indexs=Si:min(Si+step_len,Test_End)-1;
    Featurei=1;
    
    for t_ind=prd_Indexs
       %% display progress bar
        if mod(t_ind-hlf_wlen,progressStepSize)==0
            ppm.increment();
        end
        
        ps=t_ind-hlf_wlen+1;
        pe=t_ind+hlf_wlen;

        %---window sig[ps:pe]
        pt_sig=signal_in(ps:pe);


        fVec=sig2FV_format(pt_sig,random_relations);
        Features(Featurei,:)=fVec;
        Featurei=Featurei+1;
    end
    %--拼合特征向量--循环之外进行预测
%     Features=[Features;fVec];
%     FIndexs=[FIndexs;ind];
    
    %---进行预测---
    %---20150726--
    [res,pscore]=predict(Bagger_B,Features);
    % find res(i)=='1' and corresponding index
    res_ind=find([res{:}]=='1');
    %% 防止 下标越界
    res_ind=res_ind(res_ind<=length(prd_Indexs));
    
%     ResultLen=length(res_ind);
%     if ResultLen>0
%         Rindex(Rindex_top:Rindex_top+ResultLen-1)=transpose(prd_Indexs(res_ind));
%         Pscore(Rindex_top:Rindex_top+ResultLen-1)=transpose(pscore(res_ind));
%     end
    Rindex=[Rindex;transpose(prd_Indexs(res_ind))];
    Pscore=[Pscore;transpose(pscore(res_ind))];
    
end
%% delete progress bar
ppm.delete()

end
