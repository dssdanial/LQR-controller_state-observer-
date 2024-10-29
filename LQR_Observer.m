
%% Danial Sabzevari  

%%
clc;
clear;
close all;

%% Initial condition
t0=0;
dt=0.01;
t_f=20;
t=t0:dt:t_f;

r=sin(t);
x0=[0 0 0.5 0.5]; %arbitary initial states

A=[5 0;2 3];
B=[1 0;0 2];
C=[0 1];
D=zeros(1,2);
G_ol=ss(A,B,C,D);
%% LQR

% Question 2 ***********************
Q=[10 0;0 10];
R=[1 0;0 2];

%Controlability:
Mq=[B A*B];
if(rank(Mq)==2)
    disp('***** System is Controllable, rank=2');
else
    disp('***** System is Not Controllable');
end

[K_lqr,S,CLP]=lqr(A,B,Q,R);
G=-R\B'*K_lqr;
Gcl_fbk=ss(A-B*K_lqr,B, C, D);

disp('Controller Gain:');
disp(G);

% Question 3  ***********************
Acl=A-B*K_lqr;
lambda=eig(Acl);
if(lambda(1)<0 && lambda(2)<0)
    disp('***** System is Asymtotycally stable *****');
    disp('Negative eigenvalues are:');
    lambda
else
    disp('***** System is not Asymtotycally stable');
end


% Qustion 4 ************************
Obs_Dpoles=[-10 -15];
G=place(A',C',Obs_Dpoles)';
% Observability
O=[C; C*A];
if(rank(O)==2)
    disp('***** System is Observable, rank=2');
else
    disp('***** System is Not Observable');
end

Ao=A-G*C;
Bo=[B-D G];
Co=C;
Do=D;
G_obs=ss(Ao,B,C,D);
% [y_ol,~,x_ol]=lsim(Gcl_fbk,[r' r'], t);
% [y_obs,~,x_obs]=lsim(G_obs, [r' y_ol],t);



% Question5******************************** 
Aaug=[A -B*K_lqr; G*C A-G*C-B*K_lqr];
Baug=[B ;B];
Caug=[C -D*K_lqr];
Daug=D;
new_sys=ss(Aaug, Baug,Caug,Daug);
[y_aug,~,x_aug]=lsim(new_sys, [r' zeros(length(r),1)],t,x0);


Err_X1= x_aug(:,1)-x_aug(:,3);
Err_X2= x_aug(:,2)-x_aug(:,4);


% Qeuation 6:
[a, b]=ss2tf(A-B*K_lqr,B(:,1),C,D(1));
T=tf(a,b)
r=sin(t);
[y1,~,x1]=lsim(T,r,t);
r=sin(5*t);
[y2,~,x2]=lsim(T,r,t);
r=sin(0.1*t);
[y3,~,x3]=lsim(T,r,t);

bode(T)
%% Plot
figure(1);
subplot(211);
plot(t, x_aug(:,2), t, x_aug(:,4));
legend('X','Xhat');
xlabel('time(s)');
ylabel('X2');

subplot(212);
plot(t, Err_X2);
xlabel('time(s)');
ylabel('Error X2');

figure(2);
subplot(2,2,[3,4]);
plot(t,y1,t,y2,t,y2);
legend('output: sin(t)','output: sin(5t)','output: sin(0.1t)');
xlabel('time(s)');
ylabel('Amplitude');
title('Closed-loop system');
subplot(2,1,1);
bode(T);
title('Bode diagram');











