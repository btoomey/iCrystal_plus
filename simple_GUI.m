function varargout = simple_GUI(varargin)
% SIMPLE_GUI MATLAB code for simple_GUI.fig
%      SIMPLE_GUI, by itself, creates a new SIMPLE_GUI or raises the existing
%      singleton*.
%
%      H = SIMPLE_GUI returns the handle to a new SIMPLE_GUI or the handle to
%      the existing singleton*.
%
%      SIMPLE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMPLE_GUI.M with the given input arguments.
%
%      SIMPLE_GUI('Property','Value',...) creates a new SIMPLE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simple_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to simple_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simple_GUI

% Last Modified by GUIDE v2.5 10-Aug-2013 15:34:45

% Begin initialization code - DO NOT EDIT
global default;
global checkbox;
forcegoin = 0;
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simple_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @simple_GUI_OutputFcn, ...
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


% --- Executes just before simple_GUI is made visible.
function simple_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simple_GUI (see VARARGIN)

% Choose default command line output for simple_GUI
%handles.output = hObject;

% Update handles structure


handles.unselectedTabColor=get(handles.tab1text,'BackgroundColor');
handles.selectedTabColor=handles.unselectedTabColor-0.1;

% Set units to normalize for easier handling
set(handles.tab1text,'Units','normalized')
set(handles.tab2text,'Units','normalized')
set(handles.tab1Panel,'Units','normalized')
set(handles.tab2Panel,'Units','normalized')

% Create tab labels (as many as you want according to following code template)

% Tab 1
pos1=get(handles.tab1text,'Position');
handles.a1=axes('Units','normalized',...
                'Box','on',...
                'XTick',[],...
                'YTick',[],...
                'Color',handles.selectedTabColor,...
                'Position',[pos1(1) pos1(2) pos1(3) pos1(4)+0.01],...
                'ButtonDownFcn','simple_GUI(''a1bd'',gcbo,[],guidata(gcbo))');
handles.t1=text('String','Non-PBC',...
                'Units','normalized',...
                'Position',[(pos1(3)-pos1(1))/2,pos1(2)/2+pos1(4)+0.2],...
                'HorizontalAlignment','left',...
                'VerticalAlignment','middle',...
                'Margin',0.1,...
                'FontSize',10,...
                'FontWeight', 'bold',...
                'Backgroundcolor',handles.selectedTabColor,...
                'ButtonDownFcn','simple_GUI(''t1bd'',gcbo,[],guidata(gcbo))');

% Tab 2
pos2=get(handles.tab2text,'Position');
pos2(1)=pos1(1)+pos1(3);
handles.a2=axes('Units','normalized',...
                'Box','on',...
                'XTick',[],...
                'YTick',[],...
                'Color',handles.unselectedTabColor,...
                'Position',[pos2(1) pos2(2) pos2(3) pos2(4)+0.01],...
                'ButtonDownFcn','simple_GUI(''a2bd'',gcbo,[],guidata(gcbo))');
handles.t2=text('String','PBC',...
                'Units','normalized',...
                'Position',[pos2(3)/2,pos2(2)/2+pos2(4)+0.2],...
                'HorizontalAlignment','left',...
                'VerticalAlignment','middle',...
                'Margin',0.1,...
                'FontSize',10,...
                'FontWeight', 'bold',...
                'Backgroundcolor',handles.unselectedTabColor,...
                'ButtonDownFcn','simple_GUI(''t2bd'',gcbo,[],guidata(gcbo))');
           
            
% Manage panels (place them in the correct position and manage visibilities)
pan1pos=get(handles.tab1Panel,'Position');
set(handles.tab2Panel,'Position',pan1pos)
set(handles.tab2Panel,'Visible','off')

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes simple_GUI wait for user response (see UIRESUME)
% uiwait(handles.simpletabfig);


% Text object 1 callback (tab 1)
function t1bd(hObject,eventdata,handles)

set(hObject,'BackgroundColor',handles.selectedTabColor)
set(handles.t2,'BackgroundColor',handles.unselectedTabColor)
set(handles.a1,'Color',handles.selectedTabColor)
set(handles.a2,'Color',handles.unselectedTabColor)
set(handles.tab1Panel,'Visible','on')
set(handles.tab2Panel,'Visible','off')


% Text object 2 callback (tab 2)
function t2bd(hObject,eventdata,handles)

set(hObject,'BackgroundColor',handles.selectedTabColor)
set(handles.t1,'BackgroundColor',handles.unselectedTabColor)
set(handles.a2,'Color',handles.selectedTabColor)
set(handles.a1,'Color',handles.unselectedTabColor)
set(handles.tab2Panel,'Visible','on')
set(handles.tab1Panel,'Visible','off')




% Axes object 1 callback (tab 1)
function a1bd(hObject,eventdata,handles)

set(hObject,'Color',handles.selectedTabColor)
set(handles.a2,'Color',handles.unselectedTabColor)
set(handles.t1,'BackgroundColor',handles.selectedTabColor)
set(handles.t2,'BackgroundColor',handles.unselectedTabColor)
set(handles.tab1Panel,'Visible','on')
set(handles.tab2Panel,'Visible','off')


% Axes object 2 callback (tab 2)
function a2bd(hObject,eventdata,handles)

set(hObject,'Color',handles.selectedTabColor)
set(handles.a1,'Color',handles.unselectedTabColor)
set(handles.t2,'BackgroundColor',handles.selectedTabColor)
set(handles.t1,'BackgroundColor',handles.unselectedTabColor)
set(handles.tab2Panel,'Visible','on')
set(handles.tab1Panel,'Visible','off')


% UIWAIT makes simple_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = simple_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
varargout = cell(1,1);
varargout{1,1} = 0;
% Get default command line output from handles structure
%varargout{1} = handles.output;


% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'.txt'}, 'File Selector');
fullpathname = strcat(pathname, filename);
set(handles.text3, 'String',fullpathname);
assignin('base','fullPathName',fullpathname);



function tol1_Callback(hObject, eventdata, handles)
% hObject    handle to tol1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tol1 as text
%        str2double(get(hObject,'String')) returns contents of tol1 as a double
global default;
default = [default, hObject];
if ~isempty(get(hObject,'String'))
    tol1 = str2double(get(hObject,'String'));
    assignin('base','tol1',tol1);
    save('tol.mat', 'tol1')
end






% --- Executes during object creation, after setting all properties.
function tol1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tol1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% assignin('base', 'allHandles', handles);
t1 = clock;
tol1 = get(handles.('tol1'),'string');
if ~isempty(tol1)
tol1 = str2double(tol1);
end
tol2 = get(handles.('tol2'),'string');
if ~isempty(tol2)
tol2 = str2double(tol2);
end
tol3 = get(handles.('tol3'),'string');  
if ~isempty(tol3)
tol3 = str2double(tol3);
end
tol4 = get(handles.('tol4'),'string');
if ~isempty(tol4)
tol4 = str2double(tol4);
end
tol5 = get(handles.('tol5'),'string');
if ~isempty(tol5)
tol5 = str2double(tol5);
end
address = get(handles.('text3'),'string');
savepath = get(handles.('text45'),'string');
save('tol.mat','tol1','tol2','tol3','tol4','tol5','handles','address');
save('path.mat');
main;
superprint;
disp('Finished printing');
global table
info = evalin('base','info');
% allHandles = evalin('base', 'allHandles')
table = [handles.display];
if isempty(info{size(info,1),2})
    dataD = info(1:size(info,1)-1,[1,5]);
else
    dataD = info(:,[1,5]);
end
set(table(1), 'data', dataD);
t2 = clock;
e = etime(t2,t1);
e = num2str(e);
strf = ['Thank you for using, this run took',' ',e,' seconds'];
disp(strf);









function center_pbc_Callback(hObject, eventdata, handles)
% hObject    handle to center_pbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of center_pbc as text
%        str2double(get(hObject,'String')) returns contents of center_pbc as a double
global default;
default = [default, hObject];
center_pbc = str2num(get(hObject,'String'));
assignin('base','center_pbc',center_pbc);

% --- Executes during object creation, after setting all properties.
function center_pbc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to center_pbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dimX_pbc_Callback(hObject, eventdata, handles)
% hObject    handle to dimX_pbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dimX_pbc as text
%        str2double(get(hObject,'String')) returns contents of dimX_pbc as a double
global default;
default = [default, hObject];
dimX_pbc = str2double(get(hObject,'String'));
assignin('base','dimX_pbc',dimX_pbc);

% --- Executes during object creation, after setting all properties.
function dimX_pbc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dimX_pbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
numregion = get(handles.('RegIndex'),'string');
if ~isempty(numregion)
numregion = str2num(numregion);
end
center_npbc = get(handles.('center_npbc'),'string');
if ~isempty(center_npbc)
center_npbc = str2num(center_npbc);
end
dimX_npbc = get(handles.('dimX_npbc'),'string');
if ~isempty(dimX_npbc)
dimX_npbc = str2num(dimX_npbc);
end
dimY_npbc = get(handles.('dimY_npbc'),'string');
if ~isempty(dimY_npbc)
dimY_npbc = str2num(dimY_npbc);
end
dimZ_npbc = get(handles.('dimZ_npbc'),'string');
if ~isempty(dimZ_npbc)
dimZ_npbc = str2num(dimZ_npbc);
end
dr_npbc = get(handles.('dr_npbc'),'string');
dr_npbc =dr_npbc{2,1};
if ~isempty(dr_npbc)
dr_npbc = str2num(dr_npbc);
end
rmin_npbc = get(handles.('rmin_npbc'),'string');
if ~isempty(rmin_npbc)
rmin_npbc = str2num(rmin_npbc);
end
rmax_npbc = get(handles.('rmax_npbc'),'string');
if ~isempty(rmax_npbc)
rmax_npbc = str2num(rmax_npbc);
end
elem1_npbc = get(handles.('elem1'),'string');
elem2_npbc = get(handles.('elem2'),'string');

regionIndexCheckbox = get(findobj('tag','regionIndex'),'value');
userBox = get(findobj('tag','userBox'),'value');
save('rdf_npbc_data.mat','numregion','center_npbc','dimX_npbc','dimY_npbc','dimZ_npbc','dr_npbc','rmin_npbc','rmax_npbc','elem1_npbc','elem2_npbc','regionIndexCheckbox','userBox');
rdf_npbc;





function RegIndex_Callback(hObject, eventdata, handles)
% hObject    handle to RegIndex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RegIndex as text
%        str2double(get(hObject,'String')) returns contents of RegIndex as a double
global default;
default = [default, hObject];
numregion = str2num(get(hObject,'String'));
assignin('base','numregion',numregion);

% --- Executes during object creation, after setting all properties.
function RegIndex_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RegIndex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dimY_pbc_Callback(hObject, eventdata, handles)
% hObject    handle to dimY_pbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dimY_pbc as text
%        str2double(get(hObject,'String')) returns contents of dimY_pbc as a double
global default;
default = [default, hObject];
dimY_pbc = str2double(get(hObject,'String')) ;
assignin('base','dimY_pbc',dimY_pbc);

% --- Executes during object creation, after setting all properties.
function dimY_pbc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dimY_pbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dimZ_pbc_Callback(hObject, eventdata, handles)
% hObject    handle to dimZ_pbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dimZ_pbc as text
%        str2double(get(hObject,'String')) returns contents of dimZ_pbc as a double
global default;
default = [default, hObject];
dimZ_pbc = str2double(get(hObject,'String'));
assignin('base','dimZ_pbc',dimZ_pbc);

% --- Executes during object creation, after setting all properties.
function dimZ_pbc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dimZ_pbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tol2_Callback(hObject, eventdata, handles)
% hObject    handle to tol2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tol2 as text
%        str2double(get(hObject,'String')) returns contents of tol2 as a double
global default;
default = [default, hObject];
if ~isempty(get(hObject,'String'))
    tol2 = str2double(get(hObject,'String'));
    assignin('base','tol2',tol2);
end


% --- Executes during object creation, after setting all properties.
function tol2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tol2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tol3_Callback(hObject, eventdata, handles)
% hObject    handle to tol3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tol3 as text
%        str2double(get(hObject,'String')) returns contents of tol3 as a double
global default;
default = [default, hObject];
if ~isempty(get(hObject,'String'))
    tol3 = str2double(get(hObject,'String'));
    assignin('base','tol3',tol3);
end

% --- Executes during object creation, after setting all properties.
function tol3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tol3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tol4_Callback(hObject, eventdata, handles)
% hObject    handle to tol4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tol4 as text
%        str2double(get(hObject,'String')) returns contents of tol4 as a double
global default;
default = [default, hObject];
if ~isempty(get(hObject,'String'))
    tol4 = str2double(get(hObject,'String'));
    assignin('base','tol4',tol4);
end


% --- Executes during object creation, after setting all properties.
function tol4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tol4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tol5_Callback(hObject, eventdata, handles)
% hObject    handle to tol5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tol5 as text
%        str2double(get(hObject,'String')) returns contents of tol5 as a double
global default;
default = [default, hObject];
if ~isempty(get(hObject,'String'))
    tol5 = str2double(get(hObject,'String'));
    assignin('base','tol5',tol5);
end


% --- Executes during object creation, after setting all properties.
function tol5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tol5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tol6_Callback(hObject, eventdata, handles)
% hObject    handle to tol6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tol6 as text
%        str2double(get(hObject,'String')) returns contents of tol6 as a double
global default;
default = [default, hObject];
if ~isempty(get(hObject,'String'))
    tol6 = str2double(get(hObject,'String'));
    assignin('base','tol6',tol6);
end

% --- Executes during object creation, after setting all properties.
function tol6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tol6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%[saveFileName, savePathName] = uiputfile({'*.txt'}, 'Save as');
folder_name = uigetdir;
%savefullpathname = strcat(savePathName, saveFileName);
set(handles.text45, 'String',folder_name);
%assignin('base','saveFullPathName',savePathName);
%dlmwrite(savefullpathname,[dimx_pbc,dimy_pbc,dimz_pbc],'delimiter', '\t');

% --- Executes during object creation, after setting all properties.
function tab1text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tab1text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in regionIndex.
function regionIndex_Callback(hObject, eventdata, handles)
% hObject    handle to regionIndex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of regionIndex
global checkbox;
checkbox = [checkbox, hObject];
regionIndexCheckbox = get(hObject,'Value');
assignin('base','regionIndexCheckbox',regionIndexCheckbox);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over regionIndex.
function regionIndex_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to regionIndex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in userBox.
function userBox_Callback(hObject, eventdata, handles)
% hObject    handle to userBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of userBox
global checkbox;
checkbox = [checkbox, hObject];
userBox = get(hObject,'Value');
assignin('base','userBox',userBox);



function center_npbc_Callback(hObject, eventdata, handles)
% hObject    handle to center_npbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of center_npbc as text
%        str2double(get(hObject,'String')) returns contents of center_npbc as a double
global default;
default = [default, hObject];
center_npbc = str2num(get(hObject,'String'));
assignin('base','center_npbc',center_npbc);

% --- Executes during object creation, after setting all properties.
function center_npbc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to center_npbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dimX_npbc_Callback(hObject, eventdata, handles)
% hObject    handle to dimX_npbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dimX_npbc as text
%        str2double(get(hObject,'String')) returns contents of dimX_npbc as a double
global default;
default = [default, hObject];
dimX_npbc = str2double(get(hObject,'String'));
assignin('base','dimX_npbc',dimX_npbc);

% --- Executes during object creation, after setting all properties.
function dimX_npbc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dimX_npbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dimY_npbc_Callback(hObject, eventdata, handles)
% hObject    handle to dimY_npbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dimY_npbc as text
%        str2double(get(hObject,'String')) returns contents of dimY_npbc as a double
global default;
default = [default, hObject];
dimY_npbc = str2double(get(hObject,'String'));
assignin('base','dimY_npbc',dimY_npbc);

% --- Executes during object creation, after setting all properties.
function dimY_npbc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dimY_npbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dimZ_npbc_Callback(hObject, eventdata, handles)
% hObject    handle to dimZ_npbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dimZ_npbc as text
%        str2double(get(hObject,'String')) returns contents of dimZ_npbc as a double
global default;
default = [default, hObject];
dimZ_npbc = str2double(get(hObject,'String'));
assignin('base','dimZ_npbc',dimZ_npbc);


% --- Executes during object creation, after setting all properties.
function dimZ_npbc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dimZ_npbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dr_npbc_Callback(hObject, eventdata, handles)
% hObject    handle to dr_npbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dr_npbc as text
%        str2double(get(hObject,'String')) returns contents of dr_npbc as a double
global default;
default = [default, hObject];
dr_npbc= str2double(get(hObject,'String'));
assignin('base','dr_npbc',dr_npbc);

% --- Executes during object creation, after setting all properties.
function dr_npbc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dr_npbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rmin_npbc_Callback(hObject, eventdata, handles)
% hObject    handle to rmin_npbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rmin_npbc as text
%        str2double(get(hObject,'String')) returns contents of rmin_npbc as a double
global default;
default = [default, hObject];
if ~isempty(get(hObject,'String'))
    rmin_npbc = str2double(get(hObject,'String'));
    assignin('base','rmin_npbc',rmin_npbc);
end

% --- Executes during object creation, after setting all properties.
function rmin_npbc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rmin_npbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rmax_npbc_Callback(hObject, eventdata, handles)
% hObject    handle to rmax_npbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rmax_npbc as text
%        str2double(get(hObject,'String')) returns contents of rmax_npbc as a double
global default;
default = [default, hObject];
if ~isempty(get(hObject,'String'))
    rmax_npbc = str2double(get(hObject,'String'));
    assignin('base','rmax_npbc',rmax_npbc);
end


% --- Executes during object creation, after setting all properties.
function rmax_npbc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rmax_npbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function elem1_Callback(hObject, eventdata, handles)
% hObject    handle to elem1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of elem1 as text
%        str2double(get(hObject,'String')) returns contents of elem1 as a double
global default;
default = [default, hObject];
elem1_npbc = get(hObject,'String');
assignin('base','elem1_npbc',elem1_npbc);


% --- Executes during object creation, after setting all properties.
function elem1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elem1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function elem2_Callback(hObject, eventdata, handles)
% hObject    handle to elem2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of elem2 as text
%        str2double(get(hObject,'String')) returns contents of elem2 as a double
global default;
default = [default, hObject];
elem2_npbc = get(hObject,'String');
assignin('base','elem2_npbc',elem2_npbc);

% --- Executes during object creation, after setting all properties.
function elem2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elem2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
center_pbc = get(handles.('center_pbc'),'string');
if ~isempty(center_pbc)
center_pbc = str2num(center_pbc);
end
dimX_pbc = get(handles.('dimX_pbc'),'string');
if ~isempty(dimX_pbc)
dimX_pbc = str2num(dimX_pbc);
end
dimY_pbc = get(handles.('dimY_pbc'),'string');
if ~isempty(dimY_pbc)
dimY_pbc = str2num(dimY_pbc);
end
dimZ_pbc = get(handles.('dimZ_pbc'),'string');
if ~isempty(dimZ_pbc)
dimZ_pbc = str2num(dimZ_pbc);
end
dr_pbc = get(handles.('dr_pbc'),'string');
if ~isempty(dr_pbc)
dr_pbc = str2num(dr_pbc);
end
rmin_pbc = get(handles.('rmin_pbc'),'string');
if ~isempty(rmin_pbc)
rmin_pbc = str2num(rmin_pbc);
end
rmax_pbc = get(handles.('rmax_pbc'),'string');
if ~isempty(rmax_pbc)
rmax_pbc = str2num(rmax_pbc);
end
elem1_pbc = get(handles.('elem1_pbc'),'string');
elem2_pbc = get(handles.('elem2_pbc'),'string');

save('rdf_pbc_data.mat','center_pbc','dimX_pbc','dimY_pbc','dimZ_pbc','dr_pbc','rmin_pbc','rmax_pbc','elem1_pbc','elem2_pbc');
rdf_pbc;


function dr_pbc_Callback(hObject, eventdata, handles)
% hObject    handle to dr_pbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dr_pbc as text
%        str2double(get(hObject,'String')) returns contents of dr_pbc as a double
global default;
default = [default, hObject];
dr_pbc= str2double(get(hObject,'String'));
assignin('base','dr_pbc',dr_pbc);

% --- Executes during object creation, after setting all properties.
function dr_pbc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dr_pbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rmin_pbc_Callback(hObject, eventdata, handles)
% hObject    handle to rmin_pbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rmin_pbc as text
%        str2double(get(hObject,'String')) returns contents of rmin_pbc as a double
global default;
default = [default, hObject];
if ~isempty(get(hObject,'String'))
    rmin_pbc = str2double(get(hObject,'String'));
    assignin('base','rmin_pbc',rmin_pbc);
end


% --- Executes during object creation, after setting all properties.
function rmin_pbc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rmin_pbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rmax_pbc_Callback(hObject, eventdata, handles)
% hObject    handle to rmax_pbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rmax_pbc as text
%        str2double(get(hObject,'String')) returns contents of rmax_pbc as a double
global default;
default = [default, hObject];
if ~isempty(get(hObject,'String'))
    rmax_pbc = str2double(get(hObject,'String'));
    assignin('base','rmax_pbc',rmax_pbc);
end


% --- Executes during object creation, after setting all properties.
function rmax_pbc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rmax_pbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function elem1_pbc_Callback(hObject, eventdata, handles)
% hObject    handle to elem1_pbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of elem1_pbc as text
%        str2double(get(hObject,'String')) returns contents of elem1_pbc as a double
global default;
default = [default, hObject];
elem1_pbc = get(hObject,'String');
assignin('base','elem1_pbc',elem1_pbc);


% --- Executes during object creation, after setting all properties.
function elem1_pbc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elem1_pbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function elem2_pbc_Callback(hObject, eventdata, handles)
% hObject    handle to elem2_pbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of elem2_pbc as text
%        str2double(get(hObject,'String')) returns contents of elem2_pbc as a double
global default;
default = [default, hObject];
elem2_pbc = get(hObject,'String');
assignin('base','elem2_pbc',elem2_pbc);

% --- Executes during object creation, after setting all properties.
function elem2_pbc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elem2_pbc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in clearAll.
function clearAll_Callback(hObject, eventdata, handles)
% hObject    handle to clearAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global default;
if exist('default','var')
    m = size(default, 2);
    if ismatrix(default)
        default = [];
    end
    m = size(default, 2);
    if m ~= 0
    % For each row ...
        for idx = 1:m
        % ... pass the values in each column to the SET command.
            set(default(idx), 'String', '');
        end
    end
end

global checkbox;
mc = size(checkbox, 2);
for idx = 1:mc
    set(checkbox(idx), 'value',0);
end
global table
size(table);
if ~isempty(table)
set(table(1), 'data', {});
end
table = [];
default = [];
checkbox = [];
% tolfile = fullfile(cd, 'tol.mat');
% delete(tolfile);
% evalin('base','clearvars');

% 
% global default;
% m = size(default, 2);
% 
% % For each row ...
% for idx = 1:m
% % ... pass the values in each column to the SET command.
%     set(default(idx), 'String', '');
% end
% 
% global checkbox;
% mc = size(checkbox, 2);
% for idx = 1:mc
%     set(checkbox(idx), 'value',0);
% end
% global table
% mt = size(table,2);
% set(table(1), 'data', {});
% table = [];
% default = [];
% checkbox = [];
tolfile = fullfile(cd, 'tol.mat');
delete(tolfile);
rdfnpbcdatafile = fullfile(cd,'rdf_npbc_data.mat');
rdfpbcdatafile = fullfile(cd,'rdf_pbc_data.mat');
delete(rdfnpbcdatafile);
delete(rdfpbcdatafile);
evalin('base','clearvars');


% --- Executes during object creation, after setting all properties.
function text3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global default;
default = [default, hObject];


% % --- Executes during object creation, after setting all properties.
function text45_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global default;
default = [default, hObject];


% --- Executes when entered data in editable cell(s) in display.
function display_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to display (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected cell(s) is changed in display.
function display_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to display (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function display_CreateFcn(hObject, eventdata, handles)
