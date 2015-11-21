%% Random select Train and Test Result Evaluation

clc
clear

FolderPath = 'F:\TU\心电\DNN\TreeBagger_windowedMethod\CP_Detector20151114\RandomSelect\RandSel3\';
Rmean = [];
Rerr = [];
Rvar = [];

for Ri = 1:93
RoundNum = ['R',num2str(Ri),'\'];
ResultFiles = dir([FolderPath,RoundNum]);

ErrVec = [];
meanVec = [];
maxVec = [];
varVec = [];

for Fi = 6:length(ResultFiles)
    FileName = ResultFiles(Fi).name;
    
    % Must be the predict result file
    if numel(strfind(FileName,'wave.mat')) ==0
        continue;
    end
    % remove bad files
    if numel(strfind(FileName,'sele0129.mat')) == 1
        continue;
    end
    
    load([FolderPath,RoundNum,FileName]);
    % load in: prd_ind Pscore sig tMark time

    % orig = load(origName);

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
    
    if sumA > 300 || meanA >20
%         disp(['===',FileName,'===']);
%         sumA
%         meanA
%         maxA
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

% clf(figure(1));
% stem(ErrVec);
% hold on;
% stem(meanVec);
% legend('Err','Mean');
% mean(meanVec)
Rmean = [Rmean;mean(meanVec)];
Rerr = [Rerr;mean(ErrVec)];
Rvar = [Rvar;mean(varVec)];
end
clf(figure(1));
figure(1);
xlabel('测试组序号');
ylabel('平均误差(samples)');
title('RandomSelect&Test统计数据');
mean(Rmean)
