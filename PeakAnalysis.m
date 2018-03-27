function varargout = PeakAnalysis(varargin)
% PEAKANALYSIS MATLAB code for PeakAnalysis.fig
%      PEAKANALYSIS, by itself, creates a new PEAKANALYSIS or raises the existing
%      singleton*.
%
%      H = PEAKANALYSIS returns the handle to a new PEAKANALYSIS or the handle to
%      the existing singleton*.
%
%      PEAKANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PEAKANALYSIS.M with the given input arguments.
%
%      PEAKANALYSIS('Property','Value',...) creates a new PEAKANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PeakAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PeakAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PeakAnalysis

% Last Modified by GUIDE v2.5 13-Jul-2015 12:23:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PeakAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @PeakAnalysis_OutputFcn, ...
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


% --- Executes just before PeakAnalysis is made visible.
function PeakAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PeakAnalysis (see VARARGIN)

% Choose default command line output for PeakAnalysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% For Listbox 1:
update_listbox(handles);
set(handles.listbox1,'Value',[]);



% UIWAIT makes PeakAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PeakAnalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in update_button.
function update_button_Callback(hObject, eventdata, handles)
% hObject    handle to update_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
update_listbox(handles)

function update_listbox(handles)
% hObject    handle to update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

% Updates the listbox to match the current workspace
vars = evalin('base','who');
set(handles.listbox1,'String',vars)

function [var1,var2] = get_var_names(handles)
% GET_VAR_NAMES Returns names of two variables to plot

list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
var1 = [];
var2 = [];
if length(index_selected) ~= 2
    errordlg('You must select two variables','Incorrect Selection','modal')
else
    var1 = list_entries{index_selected(1)};
    var2 = list_entries{index_selected(2)};
end 

% --- Executes on button press in plot_button.
function plot_button_Callback(hObject, eventdata, handles)
% PLOT_BUTTON_CALLBACK Plots two input variables
% hObject    handle to plot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  
[x,y] = get_var_names(handles);
if isempty(x) && isempty(y)
    return
end

try
    evalin('base',['plot(',x,',',y,')'])
catch ex
    errordlg(...
      ex.getReport('basic'),'Error generating linear plot','modal')
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
plot(gcf);

% --- Automated Detection of Local Maxima and Minima --- %

function MarkMaxPoints_Callback(hObject, eventdata, handles)
% MARKMAXPOINTS_CALLBACK Marks all local maxima 
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1

GreenYGrayLevelAvg = evalin('base','GreenYGrayLevelAvg');
GreenXDistance = evalin('base','GreenXDistance');
maxpkInd = LocalMinima(-GreenYGrayLevelAvg,2,-4);
ymaxpk = GreenYGrayLevelAvg(maxpkInd);
plot(GreenXDistance,GreenYGrayLevelAvg,'b'); hold on; scatter(maxpkInd,ymaxpk,12,'r','o','filled'); hold off;
assignin('base','xmaxpeak',maxpkInd); 
assignin('base','ymaxpeak',ymaxpk);

function MarkMinPoints_Callback(hObject, eventdata, handles)
% MARKMINPOINTS_CALLBACK Marks all local minima
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
GreenYGrayLevelAvg = evalin('base','GreenYGrayLevelAvg');
GreenXDistance = evalin('base','GreenXDistance');
minpkInd = LocalMinima(GreenYGrayLevelAvg,2,44);
yminpk = GreenYGrayLevelAvg(minpkInd);
plot(GreenXDistance,GreenYGrayLevelAvg,'b'); hold on; scatter(minpkInd,yminpk,12,'g','o','filled'); hold off;
assignin('base','yminpeak',yminpk);

% --- Manual Detection of Local Maxima and Minima --- %

% --- Executes on button press in DetectMax.
function DetectMax_Callback(hObject, eventdata, handles)
% DETECTMAX_CALLBACK Saves Cartesian coordinates of all local maxima to workspace 
% hObject    handle to DetectMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Mark local maxima by mouse click 
[xmax, ymax] = getpts
hold on;

% Save local maxima to workspace 
assignin('base','xmax', xmax);
assignin('base','ymax', ymax);
xmax = evalin('base','GreenXDistance');
ymax = evalin('base','GreenYGrayLevelAvg');

% --- Executes on button press in DetectMin.
function DetectMin_Callback(hObject, eventdata, handles)
% DETECTMIN_CALLBACK Saves Cartesian coordinates of all local minima to workspace 
% hObject    handle to DetectMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

xmax = evalin('base','xmax');
ymax = evalin('base','ymax');

% Plot local maxima 
scatter(xmax,ymax, 12,'r','o','filled'); 

% Mark local minima by mouse click 
[xmin, ymin] = getpts

% Save local minima to workspace
assignin('base','xmin', xmin);
assignin('base','ymin', ymin);
xmin = evalin('base','xmin');
ymin = evalin('base','ymin');

% Plot local minima
scatter(xmin,ymin,12,'g','o','filled'); hold off;

% --- Executes on button press in SolveManVars.
function SolveManVars_Callback(hObject, eventdata, handles)
% SOLVEMANVARS_CALLBACK Computes variables of interest using manual method of detection and saves as a .mat
% file 
% hObject    handle to SolveManVars (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

xmaxpeak = evalin('base','xmax');
mitoloc = xmaxpeak;
ymaxpeak = evalin('base','ymax');
mitopeak_y = ymaxpeak;
yminpeak = evalin('base','ymin');
mitotr_y = yminpeak;
dist = abs(mitopeak_y - mitotr_y);
savefile = 'MitoVars.mat';
save(savefile,'mitoloc','mitopeak_y','mitotr_y','dist');
disp(sprintf('Output Complete as MitoVars.mat'));

% --- Executes on button press in SolveAutoVars.
function SolveAutoVars_Callback(hObject, eventdata, handles)
% SOLVEAUTOVARS_CALLBACK Computes variables of interest using automated method of detection and saves as a .mat
% file 
% hObject    handle to SolveAutoVars (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xmaxpeak = evalin('base','xmaxpeak');
mitoloc = xmaxpeak;
ymaxpeak = evalin('base','ymaxpeak');
mitopeak_y = ymaxpeak;
yminpeak = evalin('base','yminpeak');
mitotr_y = yminpeak;
dist = abs(mitopeak_y - mitotr_y);
savefile = 'MitoVars.mat';
save(savefile,'mitoloc','mitopeak_y','mitotr_y','dist');
disp(sprintf('Output Complete as MitoVars.mat'));
