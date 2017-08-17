function varargout = buildData(varargin)
% BUILDDATA MATLAB code for buildData.fig
%      BUILDDATA, by itself, creates a new BUILDDATA or raises the existing
%      singleton*.
%
%      H = BUILDDATA returns the handle to a new BUILDDATA or the handle to
%      the existing singleton*.
%
%      BUILDDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BUILDDATA.M with the given input arguments.
%
%      BUILDDATA('Property','Value',...) creates a new BUILDDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before buildData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to buildData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help buildData

% Last Modified by GUIDE v2.5 18-Aug-2017 02:56:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @buildData_OpeningFcn, ...
                   'gui_OutputFcn',  @buildData_OutputFcn, ...
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


% --- Executes just before buildData is made visible.
function buildData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to buildData (see VARARGIN)

% Choose default command line output for buildData
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes buildData wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = buildData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in selectButton.
function selectButton_Callback(hObject, eventdata, handles)
% hObject    handle to selectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global path;
file_path=uigetdir({},'选择文件夹');
%获得图片库地址
path = strcat(file_path,'/');
set(handles.edit2,'string',path);
%在文本中显示
% mywaitbar(0,'Please Wait...',handles.figure1);
% TheEndTime = 600; 
% for t = 1:TheEndTime
%        mywaitbar(t/TheEndTime,[num2str(floor(t*100/TheEndTime)),'%'],handles.figure1);
% end


% --- Executes on button press in storePic.
function storePic_Callback(hObject, eventdata, handles)
% hObject    handle to storePic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global path;
img_path_list = dir(strcat(path,'*.jpg'));%获取该文件夹中所有jpg格式的图像  
img_num = length(img_path_list);%length(img_path_list);%获取图像总数量
mywaitbar(0,'Please Wait...',handles.figure1);
Pictures=cell(1,img_num);
     for j = 1:img_num %逐一读取图像  
         if img_path_list(j).name =='.'
             fprintf('%d %d %s\n',j,strcat(path,image_name));
             % 显示正在处理的文件名，筛选非图像文件
         else
            image_name = img_path_list(j).name;% 图像名  
            image =  imread(strcat(path,image_name));  
            fprintf('%d %d %s\n',j,strcat(path,image_name));% 显示正在处理的图像名
            Pictures{1,j}=image; 
         end
         mywaitbar(j/img_num,[num2str(floor(j*100/img_num)),'%'],handles.figure1);
      end  
save Pictures Pictures;

% --- Executes on button press in generateFeature.
function generateFeature_Callback(hObject, eventdata, handles)
% hObject    handle to generateFeature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load Pictures;

num = 7;%(numel(Pictures)/2)+100;

imgTmp = Pictures{1};

tmpHOG = HOG(imgTmp);
[l w] = size(tmpHOG);

FeaturesHOG = zeros(l,num);
FeaturesHOG(:,1) = tmpHOG;

tmpColor = getcolorMom(imgTmp);

FeaturesColor = zeros(225,num);
FeaturesColor(:,1) = tmpColor;

% tmpTexture = getTexture(imgTmp);
% FeaturesTexture = zeros(8,num);
% FeaturesTexture(:,1) = tmpTexture';
mywaitbar(0,'Please Wait...',handles.figure1);
for i = 2:num
    imgTmp = Pictures{i};
    
    tmpHOG = HOG(imgTmp);
    FeaturesHOG(:,i) = tmpHOG;
    
    tmpColor = getcolorMom(imgTmp);
    FeaturesColor(:,i) = tmpColor;
    
%     tmpTexture = getTexture(imgTmp);
%     FeaturesTexture(:,i) = tmpTexture';
    
    disp(i);
    mywaitbar(i/num,[num2str(floor(i*100/num)),'%'],handles.figure1);
end

% save PicStore Pictures;
save FeaturesHOG FeaturesHOG;
save FeaturesColor FeaturesColor;
% save FeaturesTexture FeaturesTexture;


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = gcf;
close(h);
run('GUI.m');