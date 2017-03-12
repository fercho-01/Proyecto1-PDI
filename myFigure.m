%----------------------------------
%   Tarea 1, Interfaz Grafica
%   Por:
%       - Luis Fernando Orozco (lfernando.orozco@udea.edu.co)
%         Estudiante de Ingeniería de Sistemas, Udea
%         CC 1216716983
%       - Santiago Sanmartin (santiago.sanmartin@udea.edu.co)
%         Estudiante de Ingenieria de Sistemas, Udea
%         CC 1017209945
%       V1 Marzo 2017


function varargout = myFigure(varargin)
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

function myFigure_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

guidata(hObject, handles);

varargout{1} = handles.output;

%Evento ejecutado al oprimir el boton iniciar
function pushbutton1_Callback(hObject, eventdata, handles)

%Declaración de variables globales
global vid                  %elemento de video
global data                 %Imagenes capturada por la camara web
global sizeBox              %Tamaño del cuadrado rojo
global offsetX offsetY      %Ubicación X y Y, del cuadrado rojo
global continuar            %Variable de control para saber cuando dejar de capturar imagenes

%Inicialización de variables
continuar = true;       
sizeBox = 300;
offsetX = 480/2 - sizeBox/2;
offsetY = 640/2 - sizeBox/2;
vid = videoinput('winvideo',1,'MJPG_640x480'); %Se configura la entrada de video
set(vid, 'FramesPerTrigger', Inf);
set(vid, 'ReturnedColorspace', 'rgb')
vid.FrameGrabInterval = 5;

%Se inicia la entrada de video
start(vid); 

%Se procesan todas las imagenes proporcionadas por la camara
while(continuar)
   data = getsnapshot(vid); %Captura de la imagen de la camara
   
   %Pintar cuadrado rojo
   for i=1:sizeBox
       for j=1:sizeBox
           if(i==1 || j==1 || i==sizeBox || j==sizeBox)
              data(offsetX+i,offsetY+j,2:3) = 0;
              data(offsetX+i,offsetY+j,1) = 255;
           end
       end
       
   end
   %Se muestra la imagen con el cuadrado rojo
   imshow(data);
end



%Evento ejecutado al oprimir el boton "Tomar Foto"
function pushbutton3_Callback(hObject, eventdata, handles)

%declaración de variables globales
global vid              %Elemento de video
global data             %Imagen capturada por la camara web
global sizeBox          %Tamaño del cuadro rojo
global offsetX offsetY  %Ubicación X y Y del cuadro rojo
global continuar        %Variable de control usada para saber cuando dejar de capturar imagenes

%Inicialización de las variables
continuar = false;
tamanoInicial = 300;                    %Tamaño de la porción de la imagen a procesar
tamanoFinal = 60;                       %Tamaño de la imagen final
escala = tamanoFinal / tamanoInicial;   %Escala de reducción de la imagen
txt = string('');                       %cadena de texto con los comandos de la imagen para la impresora
state = 0;                              %Variable de control para saber si el marcador pinta o no
temp = string('');                      %variable temporal con un comando para la impresora
threeCount = 0;                         %Conteo de pasos horizontales

%Iniciar el procesamiento de la imagen
data = im2bw(data,0.5); %convertir la imagen a blanco y negro
stop(vid); %se para la captura de imagenes por la camara web
img=data(offsetX+2:offsetX+sizeBox-1,offsetY+2:offsetY+sizeBox-1); %se extrae la porcion de la imgen que esta en el cuadrado rojo
b3 = img; 
b3 = imresize(b3,escala); %se cambia la resolución de la imagen
imshow(b3); %se muestra la imagen

%Generar la cadena con los comandos
%   1 -> Retrocede un paso
%   2 -> Sube el marcador
%   3 -> Realiza un paso
%   4 -> Baja el marcador
%   5 -> Realiza un salto de linea

for i=1:60
   for j=1:60
       if(b3(i,j)==1)                   %pixel blanco
           if(state)                    %si el marcador esta abajo
              state = 0;                %sube el marcador
              temp = string('2');       %crea el comando para subir el marcador
              txt = strcat(txt,temp);   %lo concatena en la cadena
           end
           
       else                             %pixel negro
           if(~state)                   %si el marcador esta arriba
               state = 1;               %baja el marcador
               temp = string('4');      %crea el comando para bajar el marcador
               txt = strcat(txt,temp);  %lo concatena en la cadena
           end
       end
       temp = string('3');              %avanza un paso      
       threeCount= threeCount+1;        %se actualiza la cantidad de pasos realizados
       txt = strcat(txt,temp);          %se añade el comando a la cadena de comandos   
   end
      if(state==1)                      %al finalizar una fila si el marcador termina abajo
          state = 0;                    %sube el marcador
          temp = string('2');           %crea el comando
          txt = strcat(txt,temp);       %se añade el comando a la cadena de comandos
      end
   
   temp = string('5');                  %se crea comando de linea nueva
   txt = strcat(txt,temp);              %se añade el comando a la cadena de comandos
   temp = string('');                   %se limpia la variable temporal
   for i = 1:threeCount
       temp = strcat('1',temp);         %se crea un comando de paso en sentido contrario por cada paso realizado
   end
   threeCount = 0;                      %se reinicia la cantidad de pasos realizados
   txt = strcat(txt,temp);              %se añade la lista de comandos a la cadena de comandos
   
end

%Creación del archivo con los comandos
f = fullfile('c:\','myfiles','salida.txt')  %ruta donde se crea el archivo
fi = fopen(f, 'w');                         %Se crea un archivo de escritura
fprintf(fi, txt);                           %se imprime la cadena de comandos en el archivo
fclose(fi);                                 %se cierra el archivo
