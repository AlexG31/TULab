function TimeErr = ErrorOnExpertMarks(FileName)

%% Load Records
FolderPath_rf = 'F:\TU\心电\DNN\TreeBagger_windowedMethod\CP_Detector20151114\Results\tmp\';
FolderPath_human = 'F:\TU\心电\GUI_ECG_Marker\ECGMarkData\';
File_rf = [FolderPath_rf,FileName,'_T;wave.mat'];
File_human = [FolderPath_human,'sel100_humanMarks.mat'];

QT_datafilepath='F:\TU\心电\QTDatabase\Matlab\matdata\';
QT_files=dir(QT_datafilepath);

File_orig = [QT_datafilepath,FileName];



load(File_human);
% struct : humanMarks
% Field  : index     label

rf_data = load(File_rf);
% Field : sig    prd_ind    tMark

origSig = load(File_orig);



rf_data.prd_ind = rf_data.prd_ind(rf_data.prd_ind<length(origSig.time));
%% find Min distance
fs = 250;% QT database sample frequency
target_label = 'T';

%% nearest index,signed

TimeErr = zeros([1,length(rf_data.tMark)]);

for ti =1:length(rf_data.tMark)
    
    [~,mi] = min(abs(origSig.time(rf_data.prd_ind)-rf_data.tMark(ti)));

    Min_Dist = origSig.time(rf_data.prd_ind(mi))-rf_data.tMark(ti);

    TimeErr(ti) = Min_Dist;
end

end