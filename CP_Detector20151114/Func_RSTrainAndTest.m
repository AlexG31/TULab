function Func_RSTrainAndTest(Target_Label,RandFolderPath,CurFolderName,RecWH,Train_set,Test_set)
%% Random Select Rec to Train & Test
% clc
% clear
% close all;

%% 40% vs 60%
%% Key Parameters for this mFile


% Target_Lable = 'T';
% Current Folder Name
% RandFolderPath = 'F:\TU\心电\DNN\TreeBagger_windowedMethod\CP_Detector20151114\RandomSelect\';
% CurFolderName = 'RandSel1\';

% Only test for the region with marks
MarkedRegionOnly = 1;
% debug cnt
debug_cnt=20;
% dwt 前DWT_LOW阶设置为0
DWT_LOW = 2;
DWT_HIGH = 9;

% choose training target
STR_TMARK = ['tMark = marks.',Target_Label,';'];
%---保存训练模型，附上系统时间---
SaveModelFilename=[RandFolderPath,CurFolderName,'\QTdb',Target_Label,'waveModel_',...
    datestr(now,30),'.mat'];

saveResultPath=[RandFolderPath,CurFolderName];
% selected files

%% Train
ECG_CPRFD_Train(DWT_LOW,DWT_HIGH,STR_TMARK,SaveModelFilename,RecWH(Train_set));

%%  Test

ECG_CPRFD_Test(DWT_LOW,DWT_HIGH,STR_TMARK,SaveModelFilename,saveResultPath,RecWH(Test_set),MarkedRegionOnly);

%% Output Result








end