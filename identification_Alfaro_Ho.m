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
grid on
xlabel("Tiempo (s)")
ylabel("Variables")
legend("Salida","Entrada")

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

% Tiempo cuando la salida es del 50%
delta_50 = 0.50*delta_y;
y50 = y0 + delta_50;
ind_50 = find(y <= y50,1);
t50 = t(ind_50)-t0;

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
plot(t, u, t, y, t, y_A, 'linewidth', 2)
legend('Entrada', 'Sistema', 'Alfaro 123c (POMTM)')
grid on

% Se calcula el índice de error por medio de IAE
IAE_Alfaro = trapz(t, abs(y-y_A));
fprintf(['Alfaro123c (POMTM): %.4f \n'], IAE_Alfaro);

%% Alfaro123c (SOMTM)
num =  (-0.6240*t25 + 0.9866*t50 - 0.3626*t75);
den = (0.3533*t25 - 0.7036*t50 + 0.3503*t75);
A_A2 = num/den;
T_A2 = (t75 - t25)/(0.9866 + 0.7036*A_A2);
L_A2 = t75 - (1.3421 + 1.3455*A_A2)*T_A2;
P_A2 = (K)/((T_A2*s + 1)*(A_A2*T_A2*s+1));

% Gráfica de la entrada, la salida y el modelo para Alfaro123c
y_A2 = lsim(P_A2, u_Sample, t) + y0;
figure(3)
plot(t, u, t, y, t, y_A2, 'linewidth', 2)
legend('Entrada', 'Sistema', 'Alfaro 123c (SOMTM)')
grid on

% Se calcula el índice de error por medio de IAE
IAE_Alfaro2 = trapz(t, abs(y-y_A2));
fprintf(['Alfaro123c (SOMTM): %.4f \n'], IAE_Alfaro2);

%% Alfaro123c (PDMTM)
T_A3 = 0.5776*(t75 - t25);
L_A3 = 1.5552*t25 - 0.5552*t75;
A_A3 = 1;
P_A3 = (K)/((T_A3*s + 1)*(A_A3*T_A3*s+1));

% Gráfica de la entrada, la salida y el modelo para Alfaro123c
y_A3 = lsim(P_A3, u_Sample, t) + y0;
figure(4)
plot(t, u, t, y, t, y_A3, 'linewidth', 2)
legend('Entrada', 'Sistema', 'Alfaro 123c (PDMTM)')
grid on

% Se calcula el índice de error por medio de IAE
IAE_Alfaro3 = trapz(t, abs(y-y_A3));
fprintf(['Alfaro123c (PDMTM): %.4f \n'], IAE_Alfaro3);

%% Ho
T_H = 0.670*(t85 - t35);
L_H = 1.290*t35 + (1 - 1.290)*t85;
P_H = (K)/((T_H*s + 1));

% Gráfica de la entrada, la salida y el modelo para Ho
y_H = lsim(P_H, u_Sample, t);
figure(5)
plot(t, u, t, y, t, y_H, 'linewidth', 2)
legend('Entrada', 'Sistema', 'Ho')
grid on

% Se calcula el índice de error por medio de IAE
IAE_Ho = trapz(t, abs(y-y_H));
fprintf(['Ho: %.4f \n'], IAE_Ho);

%% System Identification
%systemIdentification

% Para un polo
Pm1 = 1.2296/(0.22938*s+1);

% Gráfica de la entrada, la salida y el modelo para SysIdent
ym1 = lsim(Pm1, u_Sample, t);
figure(6)
plot(t, u, t, y, t, ym1, 'linewidth', 2)
legend('Entrada', 'Sistema', 'SysIdent')
IAE_m1 = trapz(t,abs(y-ym1));
fprintf(['SysIdent (POMTM): %.4f \n'], IAE_m1);

% Para dos polos
Pm2 = 1.2302/((0.23327*s+1)*(0.00080321*s+1));

% Gráfica de la entrada, la salida y el modelo para SysIdent
ym2 = lsim(Pm2, u_Sample, t);
figure(7)
plot(t, u, t, y, t, ym2, 'linewidth', 2)
legend('Entrada', 'Sistema', 'SysIdent')
IAE_m2 = trapz(t,abs(y-ym2));
fprintf(['SysIdent (PDMTM): %.4f \n'], IAE_m2);