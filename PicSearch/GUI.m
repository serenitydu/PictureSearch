function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 17-Aug-2017 16:22:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%设置GUI背景
ha=axes('units','normalized','position',[0 0 1 1]);
uistack(ha,'down')
II=imread('background.jpg');
image(II)
colormap gray
set(ha,'handlevisibility','off','visible','off');
set (handles.axes1,'Visible','off')
set (handles.axes2,'Visible','off')
global HL;
global C;
global FH;
global FC;
%global FT;
global PS;
% if exist('HOGLSH.mat','file')
%     load HOGLSH;
%     load ColorLSH;
%     load FeaturesHOG;
%     load FeaturesColor;
%     load FeaturesTexture;
%     load PicStore;
% else
    load FeaturesHOG;
    load FeaturesColor;
    load FeaturesTexture;
    load Pictures;
    
    FeaturesHOG = FeaturesHOG*255;
    HOGLSH = lsh('lsh',20,40,size(FeaturesHOG,1),FeaturesHOG,'range',255);
    
    FeaturesColor = FeaturesColor*10000;
    ColorLSH = lsh('lsh',20,40,size(FeaturesColor,1),FeaturesColor,'range',10000);
    
%     save HOGLSH HOGLSH;
%     save ColorLSH ColorLSH;
%end
HL = HOGLSH;
C = ColorLSH;
FH = FeaturesHOG;
FC = FeaturesColor;
%FT = FeaturesTexture;
PS = Pictures;

% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in searchButton.
function searchButton_Callback(hObject, eventdata, handles)
% hObject    handle to searchButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HL;
global C;
global FH;
global FC;
%global FT;
global PS;
result = PicSearchMain2(handles.inputName,HL,C,FH,FC,PS);

axes(handles.axes3);
imshow(result{1});
axes(handles.axes4);
imshow(result{2});
axes(handles.axes5);
imshow(result{3});
axes(handles.axes6);
imshow(result{4});
axes(handles.axes7);
imshow(result{5});
axes(handles.axes8);
imshow(result{6});
axes(handles.axes9);
imshow(result{7});
axes(handles.axes10);
imshow(result{8});
axes(handles.axes11);
imshow(result{9});
axes(handles.axes12);
imshow(result{10});
axes(handles.axes13);
imshow(result{11});
axes(handles.axes14);
imshow(result{12});


% --- Executes on button press in openButton.
function openButton_Callback(hObject, eventdata, handles)
% hObject    handle to openButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile({'*.*';'*.bmp';'*.jpg';'*.tif';'*.jpg'},'选择图像');
if isequal(filename,0)||isequal(pathname,0)
  errordlg('您还没有选取图片！！','温馨提示');%如果没有输入，则创建错误对话框 
else
    image=[pathname,filename];%合成路径+文件名
    handles.inputName = image;
    im=imread(image);%读取图像
    axes(handles.axes1);
    imshow(im);%在坐标axes1显示原图像 
    guidata(hObject, handles);
end


% --------------------------------------------------------------------
function import_Callback(hObject, eventdata, handles)
% hObject    handle to import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = gcf;
close(h);
run('buildData.m');

