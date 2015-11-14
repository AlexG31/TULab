function ECG_CPRFD_Test(DWT_LOW,DWT_HIGH,STR_TMARK,LoadModelFilename,saveResultPath,Target_Files)

    if nargin ==4
        Target_Files = [];
    end

    close all;
    load(LoadModelFilename);

    %% Key Parameters for this mFile
    % debug cnt

    Testdebug_cnt=1e3;
    %% get target wave type:
    target_type = strsplit(STR_TMARK,'marks.');
    target_type = cell2mat(target_type(2));

    addpath('F:\TU\心电\QTDatabase\Matlab\');% QT functions
    addpath('F:\TU\心电\DNN\TreeBagger_windowedMethod\T_wave_detection\ParforProgMonv2');%parfor monitor
    QT_datafilepath='F:\TU\心电\QTDatabase\Matlab\matdata\';
    % saveResultPath='F:\TU\心电\DNN\TreeBagger_windowedMethod\CP_Detector20151114\Results\';
    QT_files=dir(QT_datafilepath);


    %% Load Model
    % savefilename='F:\TU\心电\DNN\TreeBagger_windowedMethod\T_wave_detection\Matlab\TwavePrediction_mod\TandT_models\TandT_20150927T223544QT.mat';
    % load(savefilename);
    % -开启多线程-
    if 0~=isempty(gcp('nocreate'))
        parpool local;
    end

    % --------------训练特征向量格式参数---------------



    %% 遍历每个MITdb数据文件--测试
    % bad_record_id=[113 117 207 215 222 228 230 231];%滤除效果不好的file，不把他们加入训练样本集中
    % targetfiles={'sel103','sel116','sel117','sel123','sel16265','sel16272','sel16273','sel16420','sel16483','sel16539','sel16773','sel16786','sel16795','sel17453'};
    targetfiles={'sel16273','sel16420','sel16483','sel16539','sel16773','sel16786','sel16795','sel17453'};

    tic
    for ind = 3:length(QT_files)
        disp(['>>剩余文件数 ：',num2str(length(QT_files)-ind)]);
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

        title([FileName,blanks(4),target_type,'wave']);

        %----Save figure ---
    %     savefig(figure(1),[saveResultPath,'Rec',FileName,'_',target_type,'wave.fig']);
        %----Save test data----
        save([saveResultPath,FileName,'_',target_type,'wave.mat'],'sig','prd_ind','tMark');


        %% debug : limit number of test
        Testdebug_cnt=Testdebug_cnt-1;
        if Testdebug_cnt<=0
            break;
        end

    end % file_id

    toc



end