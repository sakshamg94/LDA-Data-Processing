clear all
close all

path= '/Shear Layer Experiments/';% Shear Layer Experiments/
filename= '20cm_intermed_fast_Z1.000001.txt';

% Load raw data
data= load([path,filename]);

t_raw= data(:,1)/1000;  % time (seconds)
LDA1_raw= data(:,3);    % LDA1-direction velocity (m/s)
LDA2_raw= data(:,4);    % LDA2-direction velocity (m/s)

Fs= 25;     % sampling frequency (Hz)
[LDA1_filt,t]= generalfilterfcn(LDA1_raw,t_raw*1000,Fs,'1d_lda');
[LDA2_filt,t]= generalfilterfcn(LDA2_raw,t_raw*1000,Fs,'1d_lda');

[u,w]= rotateVelocities(LDA1_filt,LDA2_filt,180+45);

figure(1); clf
plot(u-mean(u),w-mean(w),'k.')

figure(2); clf
plot(LDA1_raw-mean(LDA1_raw),LDA2_raw-mean(LDA2_raw),'k.')

figure(3);clf
plot(LDA1_filt-mean(LDA1_filt),LDA2_filt-mean(LDA2_filt),'k.')

figure(4); clf
plot(t,u,t,w);

figure(5); clf
plot(t_raw,LDA1_raw)%t,LDA1);

figure(6); clf
plot(t_raw,LDA2_raw)%t,LDA1);

%%
figure(7); clf
plot(t,u)%t,LDA1);

figure(8); clf
plot(t,w)%t,LDA1);

figure(7); clf
plot(t_raw,LDA1_raw,t_raw,LDA1_raw);