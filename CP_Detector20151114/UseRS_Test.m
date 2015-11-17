%% Use Random Select Train and Test


%% Random Select Rec to Train & Test
clc
clear
% close all;

%% 40% vs 60%
%% Key Parameters for this mFile



% Current Folder Name
RandFolderPath = 'F:\TU\心电\DNN\TreeBagger_windowedMethod\CP_Detector20151114\RandomSelect\';
CurFolderName = 'RandSel2\';

% Only test for the region with marks
MarkedRegionOnly = 1;
% debug cnt
debug_cnt=20;
% dwt 前DWT_LOW阶设置为0
DWT_LOW = 2;
DWT_HIGH = 9;


saveResultPath=[RandFolderPath,CurFolderName];
% selected files
RecWH = {...
'sel103.mat',...
'sel104.mat',...
'sel114.mat',...
'sel116.mat',...
'sel117.mat',...
'sel123.mat',...
'sel16265.mat',...
'sel16272.mat',...
'sel16273.mat',...
'sel16420.mat',...
'sel16483.mat',...
'sel16539.mat',...
'sel16773.mat',...
'sel16786.mat',...
'sel16795.mat',...
'sel17152.mat',...
'sel17453.mat',...
'sel223.mat',...
'sel230.mat',...
'sel231.mat',...
'sel233.mat',...
'sel30.mat',...
'sel301.mat',...
'sel302.mat',...
'sel306.mat',...
'sel307.mat',...
'sel308.mat',...
'sel31.mat',...
'sel32.mat',...
'sel33.mat',...
'sel34.mat',...
'sel39.mat',...
'sel40.mat',...
'sel41.mat',...
'sel46.mat',...
'sel47.mat',...
'sel48.mat',...
'sel49.mat',...
'sel51.mat',...
'sel52.mat',...
'sel803.mat',...
'sel808.mat',...
'sel811.mat',...
'sel840.mat',...
'sel871.mat',...
'sel872.mat',...
'sel873.mat',...
'sele0104.mat',...
'sele0106.mat',...
'sele0107.mat',...
'sele0110.mat',...
'sele0111.mat',...
'sele0112.mat',...
'sele0116.mat',...
'sele0121.mat',...
'sele0122.mat',...
'sele0124.mat',...
'sele0126.mat',...
'sele0129.mat',...
'sele0133.mat',...
'sele0136.mat',...
'sele0166.mat',...
'sele0170.mat',...
'sele0203.mat',...
'sele0210.mat',...
'sele0211.mat',...
'sele0303.mat',...
'sele0405.mat',...
'sele0406.mat',...
'sele0411.mat',...
'sele0509.mat',...
'sele0603.mat',...
'sele0604.mat',...
'sele0606.mat',...
'sele0609.mat',...
'sele0612.mat',...
'sele0704.mat'
};

%% select rec to Train

N = length(RecWH);
N_train = floor(N*0.8);

Train_set = zeros(1,N_train);
% Test_set = zeros(1,N-N_train);
Test_set = [];

for ind = 1:N_train
    ri = round(rand(1)*(N-ind))+1;
    if sum(Train_set==ri)>0
        % move back
        for ri = ri:N
            if sum(Train_set==ri)==0
                break;
            end
        end
    end
    Train_set(ind) = ri;
end

ti = 1;
for ind = 1:N
    if sum(Train_set==ind)==0
        % add to Test set
        Test_set(ti) = ind;
        ti = ti +1;
    end
    
end
%% Train and Test
Target_Label = 'T';
Func_RSTrainAndTest(Target_Label,RandFolderPath,CurFolderName,RecWH,Train_set,Test_set);
% 
% Target_Label = 'R';
% Func_RSTrainAndTest(Target_Label,RandFolderPath,CurFolderName,RecWH,Train_set,Test_set);
% 
% Target_Label = 'P';
% Func_RSTrainAndTest(Target_Label,RandFolderPath,CurFolderName,RecWH,Train_set,Test_set);



%%  save Train_set & Test_set
mkdir(saveResultPath);
save([saveResultPath,'SelInd.mat'],'RecWH','Train_set','Test_set');
