%% ECG CP Train & Test on QT database 
% choose effective features

clear;
close all;

% Random Seed
rng(cputime);
%% Add paths
addpath('F:\TU\心电\QTDatabase\Matlab\');% QT functions

%% Key Parameters for this mFile
% debug cnt
debug_cnt=20;
% dwt 前DWT_LOW阶设置为0
DWT_LOW = 2;
DWT_HIGH = 9;
% choose training target
STR_TMARK = 'tMark = marks.T';
%---保存训练模型，附上系统时间---
SaveModelFilename=strcat('F:\TU\心电\DNN\TreeBagger_windowedMethod\CP_Detector20151114\Models\Twave_',...
    datestr(now,30),'QT.mat');


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

bad_files={
    'sel14046',...
    'sel14157',...
    'sel15814',...
    'sel14172'
};

targetfiles={
    'sel103',...
    'sel116',...
    'sel117',...
    'sel123',...
    'sel16265',...
    'sel16272',...
    'sel16273',...
    'sel16420',...
    'sel16483',...
    'sel16539',...
    'sel16773',...
    'sel16786',...
    'sel16795',...
    'sel17453'
};



for ind = 3:length(QT_files)
    
    %% Get Correct Filename
    FileName = QT_files(ind).name;
    if numel(strfind(FileName,'.mat')) ==0
        continue;
    end
    %% 载入波形数据：
    % Include 'time','sig','marks'
    % FileName = 'sel33.mat';
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

    [FV,Labels]=func_sig2FV(FV,Labels,sig,tMark,Window_Len,random_relations);

    %% debug : limit number of training
    debug_cnt=debug_cnt-1;
    if debug_cnt<=0
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


% save(savefilename,'TreeBagger_ModelStruct');
% disp('== Model File Saved ==');


%% Test on model =======================================================================================

clearvars -except TreeBagger_ModelStruct;
close all;


%% Key Parameters for this mFile
% debug cnt
debug_cnt=20;
Testdebug_cnt=20;
% dwt 前DWT_LOW阶设置为0
DWT_LOW = 2;
DWT_HIGH = 9;
% choose training target
STR_TMARK = 'tMark = marks.T';
%---保存训练模型，附上系统时间---
SaveModelFilename=strcat('F:\TU\心电\DNN\TreeBagger_windowedMethod\CP_Detector20151114\Models\Twave_',...
    datestr(now,30),'QT.mat');


addpath('F:\TU\心电\QTDatabase\Matlab\');% QT functions
addpath('F:\TU\心电\DNN\TreeBagger_windowedMethod\T_wave_detection\ParforProgMonv2');%parfor monitor
QT_datafilepath='F:\TU\心电\QTDatabase\Matlab\matdata\';
saveResultfigpath='F:\TU\心电\DNN\TreeBagger_windowedMethod\CP_Detector20151114\Results\';
QT_files=dir(QT_datafilepath);
filenameset={QT_files(:).name};

%% Load Model
% savefilename='F:\TU\心电\DNN\TreeBagger_windowedMethod\T_wave_detection\Matlab\TwavePrediction_mod\TandT_models\TandT_20150927T223544QT.mat';
% load(savefilename);
% -开启多线程-
if 0~=isempty(gcp('nocreate'))
    parpool local;
end

% --------------训练特征向量格式参数---------------
% fs=360;%MIT db



%% 遍历每个MITdb数据文件--测试
% bad_record_id=[113 117 207 215 222 228 230 231];%滤除效果不好的file，不把他们加入训练样本集中
% targetfiles={'sel103','sel116','sel117','sel123','sel16265','sel16272','sel16273','sel16420','sel16483','sel16539','sel16773','sel16786','sel16795','sel17453'};
targetfiles={'sel16273','sel16420','sel16483','sel16539','sel16773','sel16786','sel16795','sel17453'};

tic
for ind = 1+3+debug_cnt:length(QT_files)
    
    %% Get Correct Filename
    FileName = QT_files(ind).name;
    if numel(strfind(FileName,'.mat')) ==0
        continue;
    end
    %% 载入波形数据：
    % Include 'time','sig','marks'
    % FileName = 'sel33.mat';
    load([QT_datafilepath,FileName]);
    stime = time;
    
    %% Denoise dwt
    
    sig = ECGdwtDenoise(sig,DWT_LOW,DWT_HIGH);
    
    %% 对比检测结果
    eval(STR_TMARK);

    
    %% Test signal with Model

    clf(figure(1));
    
    %----------------------------20150725 * Test prediction result---------------------------------------
    prd_ind=[];
    Pscore=[];
    [prd_ind,Pscore]=func_TreeBaggerQT_Test_cat(TreeBagger_ModelStruct.TBobj,TreeBagger_ModelStruct.Window_Len,TreeBagger_ModelStruct.Feature_Relations,sig);%loaded test_sig105

    %% Plot result & Save fig
    figure(1);
    plot(sig);
    hold on;
    plot(prd_ind,sig(prd_ind),'linestyle','none','Marker','o','MarkerEdgecolor','r');

    %socore
    plot(prd_ind,Pscore);
    
    title(strcat('Rec-',FileName,'[1:3072*20]'));
    %----Save figure ---
    savefig(figure(1),[saveResultfigpath,'Rec',FileName,'_Twave.fig']);
    %----Save test data----
    save([saveResultfigpath,'TestData',FileName,'_Twave.mat'],'sig','prd_ind','tMark');

%     waitforbuttonpress;
    
    clf(figure(1));

    %% debug : limit number of test
    Testdebug_cnt=Testdebug_cnt-1;
    if Testdebug_cnt<=0
        break;
    end
end%file_id

toc



