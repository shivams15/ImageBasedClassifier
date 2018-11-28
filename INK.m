%MAE 527 Project 4
%Author: Shivam

function varargout = INK(varargin)
% INK MATLAB code for INK.fig
%      INK, by itself, creates a new INK or raises the existing
%      singleton*.
%
%      H = INK returns the handle to a new INK or the handle to
%      the existing singleton*.
%
%      INK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INK.M with the given input arguments.
%
%      INK('Property','Value',...) creates a new INK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before INK_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to INK_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help INK

% Last Modified by GUIDE v2.5 16-Mar-2018 05:12:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @INK_OpeningFcn, ...
                   'gui_OutputFcn',  @INK_OutputFcn, ...
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


% --- Executes just before INK is made visible.
function INK_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to INK (see VARARGIN)

% Choose default command line output for INK
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes INK wait for user response (see UIRESUME)
% uiwait(handles.figure1);


global drawing;
drawing =0;
set(gcf,'WindowButtonDownFcn',@mouseDown)
set(gcf,'WindowButtonMotionFcn',@mouseMove)
set(gcf,'WindowButtonUpFcn',@mouseUp)

global pnt
global Npnt
global I0
global P0
global r0
global DM0
global DMP0
pnt = zeros(1000,3);
Npnt = 0;
I0 = {};
P0 = {};
r0 = {};
DM0 = {};
DMP0 = {};
global Z;
Z = 1;

%Importing template information
for i = 1:14
    name = sprintf('Templates/%d',i-1);
    dat = importdata([name '.csv'],',',0);
    I0{i} = dat;
    dat = importdata([name '_P.csv'],',',0);
    P0{i} = dat;
    dat = importdata([name '_r.csv'],',',0);
    r0{i} = dat;
    dat = importdata([name '_DM.csv'],',',0);
    DM0{i} = dat;
    dat = importdata([name '_DMP.csv'],',',0);
    DMP0{i} = dat;
end
tic

% --- Outputs from this function are returned to the command line.
function varargout = INK_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ClearButton.
function ClearButton_Callback(hObject, eventdata, handles)
% hObject    handle to ClearButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla
global pnt
global Npnt
pnt = zeros(1000,3);
Npnt = 0;
tic

% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pnt
global Npnt
global Z
if Npnt<1000 
pnt(Npnt+1:end,:) =[];
end
name = sprintf('%d_%d.txt',3,1+mod(Z-1,15));
dlmwrite(name,pnt)
Z = Z+1;

function mouseDown(hObject, eventdata, handles) 
global drawing
drawing = 1;

function mouseUp(hObject, eventdata, handles) 
global drawing
drawing = 0;

function mouseMove(hObject, eventdata, handles) 
global drawing
global Npnt
global pnt

if drawing
    C = get(gca,'CurrentPoint');
    if C(1,1)<1 && C(1,1)>0 && C(1,2)<1 && C(1,2)>0
        Npnt = Npnt+1;
        pnt(Npnt,1) = C(1,1);
        pnt(Npnt,2) = C(1,2);
        pnt(Npnt,3) = toc;
        plot(C(1,1),C(1,2),'k','marker','o','MarkerFaceColor','r')
        hold on
        xlim([0 1]); ylim([0 1]);
        set(gca,'XTick',[],'YTick',[])
        box on
    end
end

% --- Executes on button press in ClassifyButton.
function ClassifyButton_Callback(hObject, eventdata, handles)
% hObject    handle to ClassifyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pnt;
global Npnt;
global I0;
global DM0;
global DMP0;
global r0;
global P0;
if Npnt<1000 
pnt(Npnt+1:end,:) =[];
end
warning('off');

%Converting the gesture into a 48x48 image
I = image(pnt(:,1),pnt(:,2),1);

C = centroid(I);
[P,r] = polar1(I);
DMP = DistMap1(P);

%Rotation-based pre-processing: selecting three classes based on MHD
for i = 1:14
    [ang,d] = rot1(P,DMP,r,P0{i},DMP0{i},r0{i});
    S(i,:) = [i, ang, d];
end
S = sortrows(S,3);

%Calculating the four coefficients for the selected classes
for i = 1:3
    I1 = rot(I,S(i,2),C);
    DM1 = DistMap(I1);
    H = HD(I1,DM1,I0{S(i,1)},DM0{S(i,1)});
    MH = MHD(I1,DM1,I0{S(i,1)},DM0{S(i,1)});
    [TC, YC] = TCYC(I1,DM1,I0{S(i,1)},DM0{S(i,1)});
    Z(i,:) = [H, MH, TC, YC]; 
end

%Selecting the class for which the weighted average of coefficients is
%least
Z = Z - min(Z);
Z = Z./max(Z);
Z = Z*[0.35;0.35;0.15;0.15];
[~, w] = min(Z);

%Displaying the result
list = {'Digit 0','Digit 1','Digit 2','Digit 3','Digit 4','Digit 5','Digit 6','Digit 7','Digit 8','Digit 9','Arrow','Torque','N','M','Other'};
msg = sprintf('Result from 1$ recognizer: Class %d ',S(w,1));
msg = [msg,'(',char(list(S(w,1))),')'];
disp(msg);
text(0.25,0.95,msg);
msg = sprintf('CW rotation from template : %0.2f degrees',S(w,2)*180/pi);
text(0.25,0.92,msg);
disp(msg);


















