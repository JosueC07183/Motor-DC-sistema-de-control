clc;
clear all;
close all;

% Se importan los datos
data = csvread('delta_155a125.csv');
t = data(443:1050, 1)-2.5018968;
u = data(443:1050, 2)-155;
y = data(443:1050, 3)-187.94;

% Corrección del pico en la señal de salida
y(544-443) = (y(543-443)+y(545-443))/2;

% Se grafica la salida como la entrada del sistema en función del tiempo
figure(1)
plot(t, y, t, u, "--k")
title('Gráfica de la acción del sistema para una entrada escalón')
xlabel("Tiempo (s)")
ylabel("Magnitud")
legend("Salida", "Entrada")
grid on

% Se calculan los valores inicial y final de la salida por medio de la
% media aritmética de los primeros y últimos diez valores.
y0 = mean(y(1:1:10));
yf = mean(y(length(y)-10:1:length(y)));

% Se definen los valores inicial y final de la entrada de la misma forma.
u0 = mean(u(1:1:10));
uf = mean(u(length(u)-10:1:length(u)));

% Diferencia en la salida
delta_y = yf - y0;

% Diferencia en la entrada
delta_u = uf - u0;

% Se define la frecuencia compleja para las FT y el valor de la ganancia es
% constante en todas las funciones
K = delta_y/delta_u;
s = tf('s');

% Se obtiene el tiempo inicial
index_uf = find(u == uf, 1);
t0 = t(index_uf);

% Tiempo cuando la salida es del 25%
delta_25 = 0.25*delta_y;
y25 = y0 + delta_25;
ind_25 = find(y <= y25,1);
t25 = t(ind_25)-t0;

% Tiempo cuando la salida es del 35%
delta_35 = 0.35*delta_y;
y35 = y0 + delta_35;
ind_35 = find(y <= y35,1);
t35 = t(ind_35)-t0;

% Tiempo cuando la salida es del 75%
[~, ind_75] = min(abs((y(1:end)-y0) - 0.75*(yf-y0)));
t75 = t(ind_75)-t0;

% Tiempo cuando la salida es del 85%
delta_85 = 0.85*delta_y;
y85 = y0 + delta_85;
ind_85 = find(y <= y85,1);
t85 = t(ind_85)-t0;

% Determina el comportamiento necesario del escalón
u_Sample = (uf-u0)*heaviside(t-t0);

%% Alfaro123c (POMTM)
T_A = 0.910*(t75 - t25);
L_A = 1.262 * t25 + ((1-1.262)*t75);
P_A = (K)/(T_A*s+1);

% Gráfica de la entrada, la salida y el modelo para Alfaro123c
y_A = lsim(P_A, u_Sample, t);
figure(2)
plot(t, u, t, y, t, y_A)
title('Identificación experimental utilizando el método de Alfaro')
ylabel('Magnitud');
xlabel('Tiempo (s)'); 
legend('Entrada', 'Sistema', 'Alfaro 123c (POMTM)')
grid on

% Se calcula el índice de error por medio de IAE
IAE_Alfaro = trapz(t, abs(y-y_A));
fprintf(['IAE de Alfaro123c (POMTM): %.4f \n'], IAE_Alfaro);

%% Ho
T_H = 0.670*(t85 - t35);
L_H = 1.290*t35 + (1 - 1.290)*t85;
P_H = (K)/((T_H*s + 1));

% Gráfica de la entrada, la salida y el modelo para Ho
y_H = lsim(P_H, u_Sample, t);
figure(3)
plot(t, u, t, y, t, y_H)
title('Identificación experimental utilizando el método de Ho')
ylabel('Magnitud');
xlabel('Tiempo (s)'); 
legend('Entrada', 'Sistema', 'Ho (POMTM)')
grid on

% Se calcula el índice de error por medio de IAE
IAE_Ho = trapz(t, abs(y-y_H));
fprintf(['IAE de Ho: %.4f \n'], IAE_Ho);

%% System Identification
%systemIdentification

% Para un polo
Pm1 = 1.2296/(0.22938*s+1);

% Gráfica de la entrada, la salida y el modelo para SysIdent
ym1 = lsim(Pm1, u_Sample, t);
figure(4)
plot(t, u, t, y, t, ym1)
title('Identificación experimental utilizando el System Identification Tool')
ylabel('Magnitud');
xlabel('Tiempo (s)'); 
legend('Entrada', 'Sistema', 'SysIdent (POMTM)')
grid on

% Se calcula el índice de error por medio de IAE
IAE_m1 = trapz(t,abs(y-ym1));
fprintf(['IAE de SysIdent (POMTM): %.4f \n'], IAE_m1);