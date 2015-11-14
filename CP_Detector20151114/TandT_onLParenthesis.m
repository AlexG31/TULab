%% ECG CP Train & Test on QT database 
% choose effective features

clear;
close all;

% Random Seed
rng(cputime);
%% Add paths
addpath('F:\TU\�ĵ�\QTDatabase\Matlab\');% QT functions

%% Key Parameters for this mFile
% debug cnt
debug_cnt=20;
% dwt ǰDWT_LOW������Ϊ0
DWT_LOW = 2;
DWT_HIGH = 9;
% choose training target
STR_TMARK = 'tMark = marks.T';
%---����ѵ��ģ�ͣ�����ϵͳʱ��---
SaveModelFilename=strcat('F:\TU\�ĵ�\DNN\TreeBagger_windowedMethod\CP_Detector20151114\Models\Twave_',...
    datestr(now,30),'QT.mat');


%% ��ȡ����������Labels
FV=[];
Labels=[];
%--------------ѵ������������ʽ����---------------
fs=240;% QT db
Window_Len=2*fs;

 %----____________________20150726_________________________----
 %----��ȡ����������໥��ϵy(x1)-y(x2)���������������з�ʽ��----
 %----____________________========_________________________----
 %---Index Range[1,Window_Len]---
 %% random generate relations
 R_cnt=20*Window_Len;%��ȡ���ٸ������Ĺ�ϵ��  ������C(N,2)��ʵ�ʲ�����������������Ͼ���ֵ��
 
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
 
%% ����ÿ��QT�����ļ�
%bad_record_id=[113 117 207 215 222 228 230 231];%�˳�Ч�����õ�file���������Ǽ���ѵ����������
QT_datafilepath='F:\TU\�ĵ�\QTDatabase\Matlab\matdata\';
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
    %% ���벨�����ݣ�
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



    %% �����ʽ��ƴ�ϳ�����������Labels

    [FV,Labels]=func_sig2FV(FV,Labels,sig,tMark,Window_Len,random_relations);

    %% debug : limit number of training
    debug_cnt=debug_cnt-1;
    if debug_cnt<=0
        break;
    end
    
end  %file_id



%% ѵ��TreeBagger ģ��
clc;
disp('--start training randomforest--');
% Bagger_B=TreeBagger(50,FV,Labels);
tic
Bagger_B=TreeBagger(50,FV(:,:),Labels(:,:),'OOBVarImp','off');
toc

%% ����ѵ��������ģ���Լ����������Ĺ���
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
% dwt ǰDWT_LOW������Ϊ0
DWT_LOW = 2;
DWT_HIGH = 9;
% choose training target
STR_TMARK = 'tMark = marks.T';
%---����ѵ��ģ�ͣ�����ϵͳʱ��---
SaveModelFilename=strcat('F:\TU\�ĵ�\DNN\TreeBagger_windowedMethod\CP_Detector20151114\Models\Twave_',...
    datestr(now,30),'QT.mat');


addpath('F:\TU\�ĵ�\QTDatabase\Matlab\');% QT functions
addpath('F:\TU\�ĵ�\DNN\TreeBagger_windowedMethod\T_wave_detection\ParforProgMonv2');%parfor monitor
QT_datafilepath='F:\TU\�ĵ�\QTDatabase\Matlab\matdata\';
saveResultfigpath='F:\TU\�ĵ�\DNN\TreeBagger_windowedMethod\CP_Detector20151114\Results\';
QT_files=dir(QT_datafilepath);
filenameset={QT_files(:).name};

%% Load Model
% savefilename='F:\TU\�ĵ�\DNN\TreeBagger_windowedMethod\T_wave_detection\Matlab\TwavePrediction_mod\TandT_models\TandT_20150927T223544QT.mat';
% load(savefilename);
% -�������߳�-
if 0~=isempty(gcp('nocreate'))
    parpool local;
end

% --------------ѵ������������ʽ����---------------
% fs=360;%MIT db



%% ����ÿ��MITdb�����ļ�--����
% bad_record_id=[113 117 207 215 222 228 230 231];%�˳�Ч�����õ�file���������Ǽ���ѵ����������
% targetfiles={'sel103','sel116','sel117','sel123','sel16265','sel16272','sel16273','sel16420','sel16483','sel16539','sel16773','sel16786','sel16795','sel17453'};
targetfiles={'sel16273','sel16420','sel16483','sel16539','sel16773','sel16786','sel16795','sel17453'};

tic
for ind = 1+3+debug_cnt:length(QT_files)
    
    %% Get Correct Filename
    FileName = QT_files(ind).name;
    if numel(strfind(FileName,'.mat')) ==0
        continue;
    end
    %% ���벨�����ݣ�
    % Include 'time','sig','marks'
    % FileName = 'sel33.mat';
    load([QT_datafilepath,FileName]);
    stime = time;
    
    %% Denoise dwt
    
    sig = ECGdwtDenoise(sig,DWT_LOW,DWT_HIGH);
    
    %% �Աȼ����
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



