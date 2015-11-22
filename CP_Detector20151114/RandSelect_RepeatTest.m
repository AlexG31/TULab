%% Random Select & Test 
% 分成几组测试，每次重新抽取训练集和测试集

clc
clear;

RandFolderPath = 'F:\TU\心电\DNN\TreeBagger_windowedMethod\CP_Detector20151114\RandomSelect\RandSel3\';




for Rndi =1:100

    % Rndi = 1;
    CurFolderName = ['R',num2str(Rndi),'\'];

    Func_UseRandSelTest(RandFolderPath,CurFolderName);

    disp(['Random Round :',num2str(Rndi)]);

end


