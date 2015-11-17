function ECG_CPRFD_Test(DWT_LOW,DWT_HIGH,STR_TMARK,LoadModelFilename,saveResultPath,Target_Files,MarkedRegionOnly)

    if nargin <6
        Target_Files = [];
    end
    
    if nargin <7
        MarkedRegionOnly =0 ;
    end

    close all;
    load(LoadModelFilename);

    %% Key Parameters for this mFile
    % debug cnt
    Region_Margin = 750;
    Testdebug_cnt=1e3;
    %% get target wave type:
    target_type = strsplit(STR_TMARK,'marks.');
    target_type = cell2mat(target_type(2));
    target_type = target_type(1);
    
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

    N = length(QT_files)-3;
    
    % target files only?
    if numel(Target_Files)>0
%         N = length(Target_Files);
    end
    
    tic
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
        %% progress
        disp(['>>剩余文件数 ：',num2str(N-ind+3)]);
        %% 载入波形数据：
        % Include 'time','sig','marks'
        % FileName = 'sel33.mat';
        load([QT_datafilepath,FileName]);
        stime = time;

        %% Denoise dwt

        sig = ECGdwtDenoise(sig,DWT_LOW,DWT_HIGH);

        %% 对比检测结果
        eval(STR_TMARK);

        %% Marked Regions Only
        sig_bk = sig;
        % debug
%         figure(2);
%         plot(sig);
%         hold on;
        
        Region_start = 1;
        Region_end = length(sig);
        
        if MarkedRegionOnly ==1
            
            Region_start = find(stime>=tMark(1),1);
            Region_end = find(stime>=tMark(length(tMark)),1);

            % debug
%             plot(Region_start,sig(Region_start),'ro');
%             plot(Region_end,sig(Region_end),'ro');

            % out of region
            Region_start = min(Region_start,length(sig));
            Region_end = min(Region_end + Region_Margin,length(sig));

            Region_start = max(Region_start - 10*Region_Margin,1);
            Region_end = max(Region_end,1);
            
            %debug
%             plot(Region_start,sig(Region_start),'ro','MarkerFaceColor','g');
%             plot(Region_end,sig(Region_end),'ro','MarkerFaceColor','g');
            sig = sig(Region_start:Region_end);
            
        end
        
        
        %% Test signal with Model

        clf(figure(1));
        figure(1);
        
        %----------------------------20150725 * Test prediction result---------------------------------------
        prd_ind=[];
        Pscore=[];
        [prd_ind,Pscore]=func_TreeBaggerQT_Test_cat(TreeBagger_ModelStruct.TBobj,TreeBagger_ModelStruct.Window_Len,TreeBagger_ModelStruct.Feature_Relations,sig);%loaded test_sig105
        % if only part of the region is tested ,then add prd_ind start from
        % the region 's first index
        prd_ind = prd_ind + Region_start -1;
        sig = sig_bk;
        %% add delta to prd_ind
        
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
        save([saveResultPath,FileName,'_',target_type,'wave.mat'],'sig','time','prd_ind','Pscore','tMark');


        %% debug : limit number of test
        Testdebug_cnt=Testdebug_cnt-1;
        if Testdebug_cnt<=0
            break;
        end

    end % file_id

    toc



end