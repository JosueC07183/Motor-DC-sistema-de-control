clc;
clear all;
close all; 

%% Controlador con LGR. 
data1 = csvread('Datos_LGR_Grupo02_09.csv');

% Se extraen los primeros 6 segundos de la evaluación, ya que es tiempo 
% suficiente para observar el comportamiento de la salida en función de la 
% entrada escalón aplicada. 
r1 = data1(1:848, 1);
u1 = data1(1:848, 2);
y1 = data1(1:848, 3);

% El tiempo de muestreo corresponde a 6/848, es decir, la cantidad de datos
% extraídos del csv con la información. 
t1 = 0:0.007075472:6; 

figure(1)
plot(t1, y1, t1, r1, t1, u1);
title(['Gráfica de la acción del controlador diseñado con LGR, ' ...
    'sobre el sistema real']); 
legend('Señal realimentada', 'Valor deseado', 'Señal de control')
ylabel('Magnitud'); 
xlabel('Tiempo (s)'); 

%% Controlador con Síntesis Analítica.
data2 = csvread('Datos_SA_Grupo02_09.csv');

% Se extraen los primeros 6 segundos de la evaluación, ya que es tiempo 
% suficiente para observar el comportamiento de la salida en función de la 
% entrada escalón aplicada. 
r2 = data2(1:848, 1);
u2 = data2(1:848, 2);
y2 = data2(1:848, 3);

% El tiempo de muestreo corresponde a 6/848, es decir, la cantidad de datos
% extraídos del csv con la información. 
t2 = 0:0.007075472:6; 

figure(2)
plot(t2, y2, t2, r2, t2, u2); 
title(['Gráfica de la acción del controlador diseñado con síntesis ' ...
    'analítica sobre el sistema real']); 
legend('Señal realimentada', 'Valor deseado', 'Señal de control')
ylabel('Magnitud'); 
xlabel('Tiempo (s)'); 

%% Controlador con Fertik y Sharpe.
data3 = csvread('Datos_Fertik_Sharpe_Grupo02_09.csv');

% Se extraen los primeros 6 segundos de la evaluación, ya que es tiempo 
% suficiente para observar el comportamiento de la salida en función de la 
% entrada escalón aplicada. 
r3 = data3(1:848, 1);
u3 = data3(1:848, 2);
y3 = data3(1:848, 3);

% El tiempo de muestreo corresponde a 6/848, es decir, la cantidad de datos
% extraídos del csv con la información. 
t3 = 0:0.007075472:6; 

figure(3)
plot(t3, y3, t3, r3, t3, u3); 
title(['Gráfica de la acción del controlador diseñado con la regla de ' ...
    'Fertik y Sharpe, analítica sobre el sistema real']); 
legend('Señal realimentada', 'Valor deseado', 'Señal de control')
ylabel('Magnitud'); 
xlabel('Tiempo (s)');  

%% Datos de LGR

fprintf('Datos del sistma con controlador LGR:\n');
% Se recortan los datos para trabajar con la segunda mitad, cuando baja el 
% escalón. 
y11 = data1(436:848,3); 
% Cálculo del sample time y se define el vector de tiempos.
t11 = 0:(3/(848-436)):3;
% Cálculo de la media de los últimos 100 valores del eje y.
Y1 = mean(data1(748:848,3));
% Información del comportamiento antes un cambio en la referencia. El 125
% indica el valor final.
stepinfo(y11,t11,125)
e1 = abs(Y1 - 125); 
fprintf('Error permanente del sistema: %.4f \n', e1);

%% Datos de Síntesis Analítica

fprintf('Datos del sistma con controlador Síntesis Analítica:\n');
% Se recortan los datos para trabajar con la segunda mitad, cuando baja el 
% escalón. 
y22 = data2(437:848,3);
% Cálculo del sample time y se define el vector de tiempos.
t22 = 0:(3/(848-437)):3;
% Cálculo de la media de los últimos 100 valores del eje y.
Y2 = mean(data2(748:848,3));
% Información del comportamiento antes un cambio en la referencia. El 125
% indica el valor final. 
stepinfo(y22,t22,125)
e2 = abs(Y2 - 125); 
fprintf('Error permanente del sistema: %.4f \n', e2);

%% Datsos de Fertik y Sharpe

fprintf('Datos del sistma con controlador Fertik y Sharpe:\n');
% Se recortan los datos para trabajar con la segunda mitad, cuando baja el 
% escalón. 
y33 = data3(436:848,3);
% Cálculo del sample time y se define el vector de tiempos.
t33 = 0:(3/(848-436)):3;
% Cálculo de la media de los últimos 100 valores del eje y.
Y3 = mean(data3(748:848,3));
% Información del comportamiento antes un cambio en la referencia. El 125
% indica el valor final.  
stepinfo(y33,t33,125)
e3 = abs(Y3 - 125); 
fprintf('Error permanente del sistema: %.4f \n', e3);
