path= '/Users/TM/Dropbox/1_Research/LDA/shear layer profiles/';
filename= '20cm_intermed_fast_Z1.000001.txt';

% Load raw data
data= load([path,filename]);

t_raw= data(:,1)/1000;  % time (seconds)
LDA1_raw= data(:,3);    % LDA1-direction velocity (m/s)
LDA2_raw= data(:,4);    % LDA2-direction velocity (m/s)

[u_raw,w_raw]= rotateVelocities(LDA1_raw,LDA2_raw,180+45);

%%
figure(3);clf
plot(t_raw,u_raw,t_raw,w_raw)

%%
figure(4); clf
plot(u_raw-mean(u_raw),w_raw-mean(w_raw),'k.')

%% Filter data to remove noise, make uniformly spaced in time
Fs= 25;     % sampling frequency (Hz)
[u,t]= generalfilterfcn(u_raw,t_raw*1000,Fs,'1d_lda');
[w,t]= generalfilterfcn(w_raw,t_raw*1000,Fs,'1d_lda');

%%
figure(5); clf
plot(t,u,t,w)

%%
figure(6); clf
plot(u-mean(u),w-mean(w),'k.')
hold on
plot(linspace(-.06,.06,100),zeros(1,100),'r:','linewidth',1.3)
plot(zeros(1,100),linspace(-.06,.06,100),'r:','linewidth',1.3)
