%%　test functions

%% Key Parameters for this mFile
% debug cnt
debug_cnt=20;
% dwt 前DWT_LOW阶设置为0
DWT_LOW = 2;
DWT_HIGH = 9;
% choose training target
STR_TMARK = 'tMark = marks.T';
%---保存训练模型，附上系统时间---
SaveModelFilename=['F:\TU\心电\DNN\TreeBagger_windowedMethod\CP_Detector20151114\Models\Twave_',...
    datestr(now,30),'QT.mat'];
saveResultPath='F:\TU\心电\DNN\TreeBagger_windowedMethod\CP_Detector20151114\Results\tmp\';

%% Train T/P/R seperately
% choose training target
STR_TMARK_T = 'tMark = marks.T';
STR_TMARK_R = 'tMark = marks.R';
STR_TMARK_P = 'tMark = marks.P';
%---保存训练模型，附上系统时间---
SaveModelFilename_T=['F:\TU\心电\DNN\TreeBagger_windowedMethod\CP_Detector20151114\Models\Twave_',...
    datestr(now,30),'QT.mat'];
SaveModelFilename_R=['F:\TU\心电\DNN\TreeBagger_windowedMethod\CP_Detector20151114\Models\Rwave_',...
    datestr(now,30),'QT.mat'];
SaveModelFilename_P=['F:\TU\心电\DNN\TreeBagger_windowedMethod\CP_Detector20151114\Models\Pwave_',...
    datestr(now,30),'QT.mat'];



%% Train
%% T wave 

ECG_CPRFD_Train(DWT_LOW,DWT_HIGH,STR_TMARK_T,SaveModelFilename_T);

%% R wave
ECG_CPRFD_Train(DWT_LOW,DWT_HIGH,STR_TMARK_R,SaveModelFilename_R);

%% P wave

ECG_CPRFD_Train(DWT_LOW,DWT_HIGH,STR_TMARK_P,SaveModelFilename_P);


%% Test

%% T wave
ECG_CPRFD_Test(DWT_LOW,DWT_HIGH,STR_TMARK_T,SaveModelFilename_T,saveResultPath);

%% R wave
ECG_CPRFD_Test(DWT_LOW,DWT_HIGH,STR_TMARK_R,SaveModelFilename_R,saveResultPath);

%% P wave
ECG_CPRFD_Test(DWT_LOW,DWT_HIGH,STR_TMARK_P,SaveModelFilename_P,saveResultPath);





