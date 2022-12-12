clc; 
clear all; 
close all; 

s = tf('s');

% Parámetros del modelo de primero orden identificado como el de mejor
% ajuste
K = 1.2296;
T = 0.2294; 

% Pruebas de cada controlador sobre el modelo. Se utiliza como base un PID
% estándar en cada caso:

%% Utilizando LGR.

kp1 = 0.8133; 
Ti1 = 0.2294; 
Td1 = 0; 

L1 = (K*kp1*(Ti1*Td1*s^2+Ti1*s+1))/(Ti1*s*(T*s+1));  
sisotool(L1)

%% Utilizando Síntesis Analítica. 
tau_c = 5.3; 

kp2 = 1/(0.2294*tau_c); 
Ti2 = 0.2294; 
Td2 = 0;

L2 = (K*kp2*(Ti2*Td2*s^2+Ti2*s+1))/(Ti2*s*(T*s+1));  
sisotool(L2)

%% Utilizando la regla de Fertik y Sharpe

kp3 = 0.4554; 
Ti3 = 0.1491; 
Td3 = 0;

L3 = (K*kp3*(Ti3*Td3*s^2+Ti3*s+1))/(Ti3*s*(T*s+1));  
sisotool(L3)