%% Random select Train and Test Result Evaluation

clc
clear

FolderPath = 'F:\TU\心电\DNN\TreeBagger_windowedMethod\CP_Detector20151114\RandomSelect\RandSel1\';

FileName = [FolderPath,'sele0704.mat_Pwave.mat'];

origFolder = 'F:\TU\心电\QTDatabase\Matlab\matdata\';
origName = [origFolder,'sele0704.mat'];

load(FileName);
% load in: prd_ind Pscore sig tMark time

orig = load(origName);

Err = zeros(1,length(tMark));


for ind = 1:length(tMark)
    tMark(ind) = find(orig.time>=tMark(ind),1);
    
    % find nearest distance:
    [~,mi] = min(abs(prd_ind-tMark(ind)));
    % Diff
    Diff = prd_ind(mi) - tMark(ind);
    Err(ind) = Diff;
end

%

plot(sig);
hold on;
plot(prd_ind,sig(prd_ind),'ro');
plot(tMark,sig(tMark),'ro','MarkerFaceColor','g');
