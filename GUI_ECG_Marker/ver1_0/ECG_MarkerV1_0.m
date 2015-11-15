function varargout = ECG_MarkerV1_0(varargin)
% ECG_MARKERV1_0 MATLAB code for ECG_MarkerV1_0.fig
%      ECG_MARKERV1_0, by itself, creates a new ECG_MARKERV1_0 or raises the existing
%      singleton*.
%
%      H = ECG_MARKERV1_0 returns the handle to a new ECG_MARKERV1_0 or the handle to
%      the existing singleton*.
%
%      ECG_MARKERV1_0('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ECG_MARKERV1_0.M with the given input arguments.
%
%      ECG_MARKERV1_0('Property','Value',...) creates a new ECG_MARKERV1_0 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ECG_MarkerV1_0_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ECG_MarkerV1_0_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ECG_MarkerV1_0

% Last Modified by GUIDE v2.5 15-Nov-2015 14:47:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ECG_MarkerV1_0_OpeningFcn, ...
                   'gui_OutputFcn',  @ECG_MarkerV1_0_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before ECG_MarkerV1_0 is made visible.
function ECG_MarkerV1_0_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ECG_MarkerV1_0 (see VARARGIN)

% Choose default command line output for ECG_MarkerV1_0
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using ECG_MarkerV1_0.
if strcmp(get(hObject,'Visible'),'off')
    global signal ;
    signal = rand(5);
    plot(signal);
end

% UIWAIT makes ECG_MarkerV1_0 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%% Key Parameters
global ECG_dataPath;
ECG_dataPath='F:\TU\心电\QTDatabase\Matlab\matdata\';
global curMarkInd;
curMarkInd = -1;
global humanMarks;
humanMarks.index = [];
humanMarks.label = [];



% --- Outputs from this function are returned to the command line.
function varargout = ECG_MarkerV1_0_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;

global signal ;


popup_sel_index = get(handles.popupmenu1, 'Value');
switch popup_sel_index
    case 1
        signal = rand(5);
        plot(signal);
    case 2
        plot(sin(1:0.01:25.99));
    case 3
        bar(1:.5:10);
    case 4
        plot(membrane);
    case 5
        surf(peaks);
end


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[x,y] = ginput(1);
% msgbox(['X = ',num2str(x),'Y = ',num2str(y)]);

%% Mark corresponding points in the curve

global signal;
global sig;
global time;

% x_index = 1:length(signal);
[~,mi] = min(abs(time-x));

axes(handles.axes1);
hold on;

for ind = 1:size(sig,2)
    plot(time(mi),sig(mi,ind),'ro');
end


global curMarkInd;
curMarkInd = mi;

% --- Executes on button press in pushbutton_zoom.
function pushbutton_zoom_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

zoom ;


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global ECG_dataPath;
QT_files = dir(ECG_dataPath);

FileListCell=[];



for ind = 3:length(QT_files)

        %% Get Correct Filename
        FileName = QT_files(ind).name;
        if numel(strfind(FileName,'.mat')) ==0
            continue;
        end
        %% 载入波形数据：
        % Include 'time','sig','marks'
        % FileName = 'sel33.mat';
        FileListCell = [FileListCell,{FileName}];
        
        
end

%% add to menu

set(handles.popupmenu1,'string',FileListCell);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% get FileName

FileInd = get(handles.popupmenu1,'Value');
FileStr = get(handles.popupmenu1,'string');
FileName = cell2mat(FileStr(FileInd));
FileName_pure = strsplit(FileName,'.mat');
FileName_pure = cell2mat(FileName_pure(1));


%% Plot 
global ECG_dataPath;
global time;
global sig;
global markFileName;

load([ECG_dataPath,FileName]);


axes(handles.axes1);
hold off;

plot(time,sig);
grid on;
title(FileName);
%% Load Marks
MarkFilePath = 'F:\TU\心电\GUI_ECG_Marker\ECGMarkData\';
markFileName = [MarkFilePath,FileName_pure,'_humanMarks.mat'];

%% struct humanMarks
% 
% humanMarks . index
% humanMarks . label
global humanMarks;

% File exist in the path
if exist(markFileName) ==2
    hold on;
    load(markFileName);
    % plot T marks
    for ind =1:length(humanMarks.index)
        if humanMarks.label(ind) == 'T'
            Tar_Ind = humanMarks.index(ind);
            plot(time(Tar_Ind),sig(Tar_Ind),'ro','MarkerFaceColor','g');
        end
    end
    
    hold off;
end


% --- Executes on selection change in popupmenu_tag.
function popupmenu_tag_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_tag contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_tag


% --- Executes during object creation, after setting all properties.
function popupmenu_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_confirm.
function pushbutton_confirm_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_confirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global curMarkInd;
global humanMarks;

TagInd = get(handles.popupmenu_tag,'Value');
TagStr = get(handles.popupmenu_tag,'string');
TagName = TagStr(TagInd);
% TagName = cell2mat(TagStr(TagInd))

humanMarks.index = [humanMarks.index,curMarkInd];
humanMarks.label = [humanMarks.label,TagName];


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global humanMarks;
global markFileName;


save(markFileName,'humanMarks');
