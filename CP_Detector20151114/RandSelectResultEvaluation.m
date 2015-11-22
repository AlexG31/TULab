%% Random select Train and Test Result Evaluation

clc
clear
close all

FolderPath = 'F:\TU\心电\DNN\TreeBagger_windowedMethod\CP_Detector20151114\RandomSelect\RandSel3\';
Rmean = [];
Rerr = [];
Rvar = [];

%% for each file, mean(abs) mean(var) label{P/R/T};

Tot_mean = [];
Tot_var = [];
Tot_label = [];

%% bad file id
BadFileSet = {...
    'sele0111.mat',...
    'sele0112.mat',...% part bad
    'sele0129.mat',...
    'sele0211.mat',...
    'sele0203.mat',...
    'sele0704.mat',...% test
    };

for Ri = 1:100
RoundNum = ['R',num2str(Ri),'\'];
ResultFiles = dir([FolderPath,RoundNum]);

ErrVec = [];
meanVec = [];
maxVec = [];
varVec = [];% mean var for current file
labelVec = [];% filelabel

for Fi = 6:length(ResultFiles)
    FileName = ResultFiles(Fi).name;
    
    % Must be the predict result file
    if numel(strfind(FileName,'wave.mat')) ==0
        continue;
    end
    % remove bad files
    isBad = 0;
    for badi = 1:length(BadFileSet)
        if numel(strfind(FileName,BadFileSet{badi})) == 1
            isBad = 1;
            break;
        end
    end
    if isBad == 1
        continue;
    end
    
    load([FolderPath,RoundNum,FileName]);
    % load in: prd_ind Pscore sig tMark time

    % orig = load(origName);
%% get label
    
    Filelabel = FileName(strfind(FileName,'wave.mat')-1);
    
    Err = zeros(1,length(tMark));
    Var = zeros(1,length(tMark));

    for ind = 1:length(tMark)
        tMark(ind) = find(time>=tMark(ind),1);

        % find nearest distance:
        [~,mi] = min(abs(prd_ind-tMark(ind)));
        % Diff
        Diff = prd_ind(mi) - tMark(ind);
        Err(ind) = Diff;
        Var(ind) = Diff*Diff;
    end

    
    sumA = sum(abs(Err));
    meanA = mean(abs(Err));
    maxA = max(abs(Err));
    varA = mean(Var);
    % stat
    ErrVec = [ErrVec;sum(abs(Err))];
    meanVec = [meanVec;meanA];
    maxVec = [maxVec;maxA];
    varVec = [varVec;varA];
    labelVec = [labelVec;Filelabel];
    
    if sumA > 300 || meanA >20
        disp(['===',FileName,'===']);
        sumA
        meanA
        maxA
%         figure
%         plot(sig);
%         hold on;
%         plot(tMark,sig(tMark),'ro','MarkerFaceColor','g');
%         plot(prd_ind,sig(prd_ind),'bx');
%         title(FileName);
    end
    
%     clf(figure(1));
%     figure(1)
%     plot(sig);
%     hold on;
%     plot(tMark,sig(tMark),'ro','MarkerFaceColor','g');
%     plot(prd_ind,sig(prd_ind),'bx');
%     title(FileName);
    
end

clf(figure(1));
stem(ErrVec);
hold on;
stem(meanVec);
legend('Err','Mean');
disp(['Round ',num2str(Ri),': mean =',num2str(mean(meanVec))]);



Rmean = [Rmean;(meanVec)];
Rerr = [Rerr;(ErrVec)];
Rvar = [Rvar;(varVec)];
Tot_label = [Tot_label;(labelVec)];

end

clf(figure(1));
figure(1);
stem((Rmean));

xlabel('测试组序号');
ylabel('平均误差(samples)');
title('RandomSelect&Test统计数据');

% stat for each peak

mRpeak = [];
mPpeak = [];
mTpeak = [];

for ind = 1:length(Rmean)
    if Tot_label(ind) =='R'
        mRpeak = [mRpeak;Rmean(ind)];
    elseif Tot_label(ind) =='T'
        mTpeak = [mTpeak;Rmean(ind)];
    else
        mPpeak = [mPpeak;Rmean(ind)];
    end
    
end

disp(['统计数据：']);
disp(['mean P peak:',num2str(mean(mPpeak)),' (',num2str(mean(mPpeak)/250*1000),' ms)']);
disp(['mean T peak:',num2str(mean(mTpeak)),' (',num2str(mean(mTpeak)/250*1000),' ms)']);
disp(['mean R peak:',num2str(mean(mRpeak)),' (',num2str(mean(mRpeak)/250*1000),' ms)']);

figure(2);
subplot(221);
stem(mPpeak);
title('P peak mean error');
xlabel('file ID');
ylabel('sample number');

subplot(222);
stem(mTpeak);
title('T peak mean error');
xlabel('file ID');
ylabel('sample number');

subplot(223);
stem(mRpeak);
title('R peak mean error');
xlabel('file ID');
ylabel('sample number');
