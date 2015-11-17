function ECG_CPRFD_Train(DWT_LOW,DWT_HIGH,STR_TMARK,SaveModelFilename,Target_Files)


    if nargin == 4
        Target_Files = [];
    end
    %% ECG characteristic point random forest Detector
    % Random Seed
    rng(cputime);
    %% Add paths
    addpath('F:\TU\�ĵ�\QTDatabase\Matlab\');% QT functions

    %% Key Parameters for this mFile
    % debug cnt
    debug_cnt=1000;
%     % dwt ǰDWT_LOW������Ϊ0
%     DWT_LOW = 2;
%     DWT_HIGH = 9;
%     % choose training target
%     STR_TMARK = 'tMark = marks.T';
%     %---����ѵ��ģ�ͣ�����ϵͳʱ��---
%     SaveModelFilename=strcat('F:\TU\�ĵ�\DNN\TreeBagger_windowedMethod\CP_Detector20151114\Models\Twave_',...
%         datestr(now,30),'QT.mat');


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
        
        %% ���벨�����ݣ�
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



        %% �����ʽ��ƴ�ϳ�����������Labels

        [FV,Labels] = func_sig2FV(FV,Labels,sig,tMark,Window_Len,random_relations);

        %% debug : limit number of training
        debug_cnt = debug_cnt-1;
        if debug_cnt <= 0
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


    save(SaveModelFilename,'TreeBagger_ModelStruct');
    disp('== Model File Saved ==');


end



