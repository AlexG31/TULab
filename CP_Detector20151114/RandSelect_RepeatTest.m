%% Random Select & Test 
% �ֳɼ�����ԣ�ÿ�����³�ȡѵ�����Ͳ��Լ�

clc
clear;

RandFolderPath = 'F:\TU\�ĵ�\DNN\TreeBagger_windowedMethod\CP_Detector20151114\RandomSelect\RandSel3\';




for Rndi =1:100

    % Rndi = 1;
    CurFolderName = ['R',num2str(Rndi),'\'];

    Func_UseRandSelTest(RandFolderPath,CurFolderName);

    disp(['Random Round :',num2str(Rndi)]);

end


