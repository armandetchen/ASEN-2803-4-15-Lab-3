%ASEN 2803, Lab 3, Group 4-15, Armand Etchen, MOD 28APR2025

%housekeeping
close all;clear;clc;
hold on; grid on;
set(0,'DefaultLineLineWidth',2);

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

%gain values (question 1.2)
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

%determining user derived gain values
kptheta_test=13;
kdtheta_test=1.5;

%denominator
d2_test=1;
d1_test=(kg^2*km^2/(j*rm)+kdtheta_test*kg*km/(j*rm));
d0_test=kptheta_test*kg*km/(j*rm);
den_test=[d2_test d1_test d0_test];

%numerator
num_test=kptheta_test*kg*km/(j*rm);

%transfer function
sysTF_test=tf(num_test,den_test(:)');

%square wave reference signal, A=0.5rad, T=2s, t:[0,10]
[x2,t2]=gensig('square',5,10);
x2=x2-0.5;
x2=-x2;

%system response
[x3, t3]=lsim(sysTF_test,x2,t2);

%plotting system state for model data
figure(2);
plot(t3,x3);
hold on
plot(t2,x2);

%overshoot 20%
x2_overshoot_pos=x2*1.2;
x2_overshoot_neg=x2*0.8;
plot(t2,x2_overshoot_neg);
plot(t2,x2_overshoot_pos);

%settling time 5%
x2_5over=x2*1.05;
x2_5under=x2*0.95;
plot(t2,x2_5under);
plot(t2,x2_5over);

%plot labels
title('User Input Gain Values')
legend('Calculated Value','Reference Value','20% Under','20% Over','5% Under','5% Over');
xlabel('Time [s]');
ylabel('Arm Position [rad]');
grid on;
ylim([-0.7 0.7]);

%parsing experimental data with calculated gain values
filename='dataset3.txt';
inmat=readmatrix(filename);
ttest=inmat(:,1);
ttest=ttest(1501:11501);
ttest=ttest-ttest(1);
ttest=ttest/1000;
thetatest=inmat(:,2);
thetatest=thetatest(1501:11501);

%plotting experimental data for user derived gain
figure(3)
plot(ttest,thetatest);
hold on;
plot(t2,x2*1.2);
plot(t2,x2*0.8);
plot(t2,x2*1.05);
plot(t2,x2*0.95);
xline(5,'LineStyle',':','LineWidth',2);
xlim([0 10]);
ylim([-0.6 0.6]);
title('Experimental Hub Angle vs. Time for K_p=13, K_d=1.5');
xlabel('Time [s]');
ylabel('Arm Position [rad]');
grid on;
legend('Measured','20% Over','20% Under','5% Over','5% Under');

%plotting comparison of experimental and modelled data for user derived gain
figure(4);
plot(ttest,thetatest);
hold on;
plot(t2,x2);
plot(t3,x3);
xlim([0 10]);
ylim([-0.6 0.6]);
plot(ttest,thetatest);
plot(t2,x2*1.2);
plot(t2,x2*0.8);
plot(t2,x2*1.05);
plot(t2,x2*0.95);
xline(5,'LineStyle',':','LineWidth',2);
legend('','Reference Value','Model Response','Measured Angle','20% Over','20% Under','5% Over','5% Under');
xlabel('Time [s]');
ylabel('Arm Position [rad]');
title('Experimental vs. Modelled Arm Position vs Time for K_p=13, K_d=1.5');
grid on;

