function ECG_CPRFD_Train(DWT_LOW,DWT_HIGH,STR_TMARK,SaveModelFilename,Target_Files)


    if nargin == 4
        Target_Files = [];
    end
    %% ECG characteristic point random forest Detector
    % Random Seed
    rng(cputime);
    %% Add paths
    addpath('F:\TU\心电\QTDatabase\Matlab\');% QT functions

    %% Key Parameters for this mFile
    % debug cnt
    debug_cnt=1000;
%     % dwt 前DWT_LOW阶设置为0
%     DWT_LOW = 2;
%     DWT_HIGH = 9;
%     % choose training target
%     STR_TMARK = 'tMark = marks.T';
%     %---保存训练模型，附上系统时间---
%     SaveModelFilename=strcat('F:\TU\心电\DNN\TreeBagger_windowedMethod\CP_Detector20151114\Models\Twave_',...
%         datestr(now,30),'QT.mat');


    %% 获取特征向量与Labels
    FV=[];
    Labels=[];
    %--------------训练特征向量格式参数---------------
    fs=240;% QT db
    Window_Len=2*fs;

     %----____________________20150726_________________________----
     %----获取随机产生的相互关系y(x1)-y(x2)（特征向量的排列方式）----
     %----____________________========_________________________----
     %---Index Range[1,Window_Len]---
     %% random generate relations
     R_cnt=20*Window_Len;%获取多少个这样的关系对  最多可能C(N,2)，实际产生的是其二倍（算上绝对值）

     random_relations=[];

     %center
     x1=int32(floor(Window_Len/2));
     for x2 =1:Window_Len
         random_relations=[random_relations [x1;x2]];
     end
     %center
     x1=int32(floor(Window_Len/2))+1;
     for x2 =1:Window_Len
         random_relations=[random_relations [x1;x2]];
     end

     while(R_cnt>0)
         R_cnt=R_cnt-1;

         x1=int32(round(rand*(Window_Len-1))+1);
         x2=int32(round(rand*(Window_Len-1))+1);
         while(x2==x1)%  x1~=x2,should be unique,otherwise y(x1)-y(x2)=0
            x2=int32(round(rand*(Window_Len-1))+1);
         end
         random_relations=[random_relations [x1;x2]];
     end

    %% 遍历每个QT数据文件
    %bad_record_id=[113 117 207 215 222 228 230 231];%滤除效果不好的file，不把他们加入训练样本集中
    QT_datafilepath='F:\TU\心电\QTDatabase\Matlab\matdata\';
    QT_files=dir(QT_datafilepath);




    for ind = 3:length(QT_files)

        %% Get Correct Filename
        FileName = QT_files(ind).name;
        if numel(strfind(FileName,'.mat')) ==0
            continue;
        end
        
        
        % check target files only
        if numel(Target_Files)>0
            % whether FileName is in Target_Files
            isInTar = 0;
            for ti=1:length(Target_Files)
                if strcmp(FileName,Target_Files{ti})==1
                    isInTar = 1;
                    break;
                end
            end
            if isInTar==0
                continue;
            end
        end
        
        %% 载入波形数据：
        % Include 'time','sig','marks'
        FileName
        load([QT_datafilepath,FileName]);
        stime = time;


        %% Denoise dwt

        sig = ECGdwtDenoise(sig,DWT_LOW,DWT_HIGH);

        %%  mark data 
        % ss= 'tMark = marks.T';
        eval(STR_TMARK);
        for mi = 1:length(tMark)
            tMark(mi)=find(stime>=tMark(mi),1);
        end



        %% 整理格式，拼合成特征向量与Labels

        [FV,Labels] = func_sig2FV(FV,Labels,sig,tMark,Window_Len,random_relations);

        %% debug : limit number of training
        debug_cnt = debug_cnt-1;
        if debug_cnt <= 0
            break;
        end

    end  %file_id



    %% 训练TreeBagger 模型
    clc;
    disp('--start training randomforest--');
    % Bagger_B=TreeBagger(50,FV,Labels);
    tic
    Bagger_B=TreeBagger(50,FV(:,:),Labels(:,:),'OOBVarImp','off');
    toc

    %% 保存训练出来的模型以及特征向量的构成
    TreeBagger_ModelStruct.TBobj=Bagger_B;
    TreeBagger_ModelStruct.gen_time=datestr(now);
    TreeBagger_ModelStruct.Feature_Relations=random_relations;
    TreeBagger_ModelStruct.Window_Len=Window_Len;


    save(SaveModelFilename,'TreeBagger_ModelStruct');
    disp('== Model File Saved ==');


end



