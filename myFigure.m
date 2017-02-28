function varargout = myFigure(varargin)
% MYFIGURE MATLAB code for myFigure.fig
%      MYFIGURE, by itself, creates a new MYFIGURE or raises the existing
%      singleton*.
%
%      H = MYFIGURE returns the handle to a new MYFIGURE or the handle to
%      the existing singleton*.
%
%      MYFIGURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYFIGURE.M with the given input arguments.
%
%      MYFIGURE('Property','Value',...) creates a new MYFIGURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before myFigure_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to myFigure_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help myFigure

% Last Modified by GUIDE v2.5 27-Feb-2017 21:59:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @myFigure_OpeningFcn, ...
                   'gui_OutputFcn',  @myFigure_OutputFcn, ...
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


% --- Executes just before myFigure is made visible.
function myFigure_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to myFigure (see VARARGIN)

% Choose default command line output for myFigure
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes myFigure wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = myFigure_OutputFcn(hObject, eventdata, handles) 
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
global vid
global data
global sizeBox
global offsetX offsetY
global continuar
continuar = true;
vid = videoinput('winvideo',1,'MJPG_640x480');
set(vid, 'FramesPerTrigger', Inf);
set(vid, 'ReturnedColorspace', 'rgb')
vid.FrameGrabInterval = 5;
start(vid);

sizeBox = 400;
offsetX = 480/2 - sizeBox/2;
offsetY = 640/2 - sizeBox/2;
while(continuar)
   data = getsnapshot(vid);
   for i=1:sizeBox
       for j=1:sizeBox
           if(i==1 || j==1 || i==sizeBox || j==sizeBox)
              data(offsetX+i,offsetY+j,2:3) = 0;
              data(offsetX+i,offsetY+j,1) = 255;
           end
       end
       
   end
   imshow(data);
end




% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid
global data
global sizeBox
global offsetX offsetY
global continuar
continuar = false;

%data = rgb2gray(data);
data = im2bw(data,0.5);
%imwrite(data,'imagen.jpg');
%imshow(data);
stop(vid);
img=data(offsetX+2:offsetX+sizeBox-1,offsetY+2:offsetY+sizeBox-1);
imshow(img);
