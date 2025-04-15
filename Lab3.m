%ASEN 2803, Lab 3, Group 4-15, Armand Etchen, MOD 15APR2025

%housekeeping
close all;clear;clc;
hold on; grid on;

%constants
kg=33.3;
km=0.0401;
rm=19.2;
jhub=0.0005;
jextra=0.2*0.2794^2;
jload=0.0015;
j=jhub+jextra+jload;
L=0.45;
Marm=0.06;
jarm=0.004;
mtip=0.05;
jm=0.01;
fc=1.8;
jl=jarm+jm;
karm=(2*pi*fc)^2*(jl);

%gain values
kptheta=[10 20 5 10 10 10];
kdtheta=[0 0 0 1 -1 -0.5];

%denominator 
d2=1;
d1=(kg^2*km^2/(j*rm)+kdtheta*kg*km/(j*rm));
d0=kptheta*kg*km/(j*rm);
den=zeros(3,6);
for i=1:6
    den(:,i)=[d2 d1(i) d0(i)];
end

%numerator
num=kptheta*kg*km/(j*rm);

%transfer function
sysTF=tf(zeros(1,1));
for i=1:6
    sysTF(i)=tf(num(i),den(:,i)');
end

%step function
[x1,t]=step(sysTF);
x_act=0.5*x1;

%plotting 
hold on
for i=1:6
    plot(t,x1(:,:,i));
end

title('Closed Loop Transfer Function');
legend('K_p=10, K_\theta=0','K_p=20, K_\theta=0','K_p=5, K_\theta=0',...
    'K_p=10, K_\theta=1','K_p=10, K_\theta=-1','K_p=10, K_\theta=-0.5');
ylabel('\Theta_L/\Theta_D [rad]');
xlabel('Time [s]');