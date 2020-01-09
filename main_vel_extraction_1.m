% Code that processes the raw LDA data to actual u-w velocities 
% Uses rotation of velocity and filtering
clear u_raw w_raw t_raw t u w LDA1_raw LDA2_raw data u w t mean_u mean_w filename
close all

i=1  % ++for Z
j=1 % for fast(1)-med(2)-slow(3)
path= '';
% filename= ['bedform_inference_test' '.000001.txt'];
filename = '16cmhmaxCorals_75cmLc_20pt5H_34pt5Pump_X51Weir_top.000001.txt';
%filename= [num2str(hc) 'cm_' sparsity '_' speed '_Z' num2str(height) '.000001.txt'];
% refer file "autocorrel_1.m" in SakshPC to find the rel code for file
% naming above
% Load raw data
data= load([path,filename]);

t_raw= data(:,1)/1000;  % time (seconds)
LDA1_raw= data(:,3);    % LDA1-direction velocity (m/s)j
LDA2_raw= data(:,4);    % LDA2-direction velocity (m/s)

[u_raw,w_raw]= rotateVelocities(LDA1_raw,LDA2_raw,180+45);

%%
figure(3);clf
plot(t_raw,u_raw,t_raw,w_raw)

%%
figure(4); clf
plot(u_raw-mean(u_raw),w_raw-mean(w_raw),'k.')

% plot(LDA1_raw-mean(LDA1_raw),LDA2_raw-mean(LDA2_raw),'k.')
%% Filter data to remove noise, make uniformly spaced in time
Fs= 25;     % sampling frequency (Hz)
[u,t]= generalfilterfcn(u_raw,t_raw*1000,Fs,'1d_lda');
[w,t]= generalfilterfcn(w_raw,t_raw*1000,Fs,'1d_lda');

%% MAKE U={}; W={}; time={}; when i=1 ; 
% used column space for fast(1)-med(2)-slow(3)

U{i,j}=u;
W{i,j}=w;
time{i,j}=t;
%%
figure(5); clf
plot(t,u,t,w)

%%
figure(7); clf
plot(u-mean(u),w-mean(w),'k.')
hold on
plot(linspace(-.06,.06,100),zeros(1,100),'r:','linewidth',1.3)
plot(zeros(1,100),linspace(-.06,.06,100),'r:','linewidth',1.3)

%%
mean_u=mean(u)
mean_w=mean(w)
mean_mag_vel=mean(sqrt(u.*u+w.*w))
u_mean_sparse_L_sg(i,j)=mean_u;
mean_mag_vel_sparse_L_sg(i,j)=mean_mag_vel;
w_mean_sparse_L_sg(i,j)=mean_w;
