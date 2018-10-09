function varargout = GUI_Pencil(varargin)
% GUI_PENCIL MATLAB code for GUI_Pencil.fig
%      GUI_PENCIL, by itself, creates a new GUI_PENCIL or raises the existing
%      singleton*.
%
%      H = GUI_PENCIL returns the handle to a new GUI_PENCIL or the handle to
%      the existing singleton*.
%
%      GUI_PENCIL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PENCIL.M with the given input arguments.
%
%      GUI_PENCIL('Property','Value',...) creates a new GUI_PENCIL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Pencil_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Pencil_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Pencil

% Last Modified by GUIDE v2.5 29-Nov-2017 23:50:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Pencil_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Pencil_OutputFcn, ...
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


% --- Executes just before GUI_Pencil is made visible.
function GUI_Pencil_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Pencil (see VARARGIN)

% Choose default command line output for GUI_Pencil
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_Pencil wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_Pencil_OutputFcn(hObject, eventdata, handles) 
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

% declare global variables to hold the image and handle
global X;
global axes1;

% open an image
[FileName,PathName] = uigetfile('*.bmp;*.tif;*.jpg;*.jpeg;*.hdf','Select the image file');
FullPathName = [PathName,'\',FileName];
X = imread(FullPathName);

% get the handle and display it

axes1 = findobj(gcf,'Tag','axes1');
axes(handles.axes1);
set(gcf, 'CurrentAxes', axes1);
imshow(X);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global X;
global axes2;

axes(handles.axes2);
set(gcf, 'CurrentAxes', axes2);
result = Pencil(X,0);
imshow(result);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global X;
global axes2;

axes(handles.axes2);
set(gcf, 'CurrentAxes', axes2);
result = Pencil(X,1);
imshow(result);
