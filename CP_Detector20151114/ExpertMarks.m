%% Evaluation on QT database with Expert Marks

clc;
clear
% close all;

QT_datafilepath='F:\TU\ÐÄµç\QTDatabase\Matlab\matdata\';
QT_files=dir(QT_datafilepath);


Err = [];
for ind = 3:length(QT_files)
   %% Get Correct Filename
    FileName = QT_files(ind).name;
    if numel(strfind(FileName,'.mat')) ==0
        continue;
    end
    
    TimeErr = ErrorOnExpertMarks(FileName);
    Err = [Err;sum(abs(TimeErr))];
end




