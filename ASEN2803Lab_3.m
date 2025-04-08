%% Defnine variables 
clc
clear

%K_p_theta =[10 20 5 10 10 10];
%K_d_theta =[0 0 0 1 -1 -0.5];

K_p_theta = 10;
K_d_theta = 1;

% for i = 1:length(K_p_theta)
K_g = 33.3;
K_m = 0.0401;
R_m = 19.2;
Jtot = 0.0005 + (0.2 * 0.2794^2) + 0.0015;
JR_m = Jtot * R_m;


n1 = (K_p_theta*K_g*K_m)/JR_m;

d2 = 1;
d1 = ((K_g^2 * K_m^2) / JR_m) + ((K_d_theta * K_g * K_m) / JR_m);
d0 = (K_p_theta * K_g * K_m) / JR_m;

%% Closed Loop System
num = n1;
den = [d2 d1 d0];
sysTF = tf(num,den)

%% Step Response
[x,t] = step(sysTF);
X_Act = 0.5 * x;

plot(t,x)
hold on

%end
 
