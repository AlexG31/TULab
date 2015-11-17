%% Random select Train and Test Result Evaluation

clc
clear

FolderPath = 'F:\TU\心电\DNN\TreeBagger_windowedMethod\CP_Detector20151114\RandomSelect\RandSel2\';
ResFile = 'sele0166.mat_Twave.mat';
FileName = [FolderPath,ResFile];

origFolder = 'F:\TU\心电\QTDatabase\Matlab\matdata\';
origFN = strsplit(ResFile,'.mat');
origName = [origFolder,origFN{1},'.mat'];

load(FileName);
% load in: prd_ind Pscore sig tMark time

% orig = load(origName);

Err = zeros(1,length(tMark));


for ind = 1:length(tMark)
    tMark(ind) = find(time>=tMark(ind),1);
    
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


