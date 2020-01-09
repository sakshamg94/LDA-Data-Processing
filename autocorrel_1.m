% Code for evaluating temporal autocorrelation of velocity downstream of
% canopy
%% User inputs for case: hc, speed(or j), sparsity, height
clear; clc;
hc = 20;
% Speeds
j = 1; % for fast(1)-med(2)-slow(3)
if j == 1
    speed = 'fast';
    Re_d = 1270;
elseif j == 2
    speed = 'med';
    Re_d = 950;
elseif j == 3
    speed = 'slow';
    Re_d = 640;
end

% Sparsities
sparsity = 'dense';
if strcmp(sparsity,'dense')
    lam_p = 0.18;       % The planform density
elseif strcmp(sparsity,'intermed')
    lam_p = 0.080;
elseif spstrcmp(sparsity,'sparse')
    lam_p = 0.050;
end

filename = [num2str(hc) 'cm_' sparsity '_profiles_sg.mat'];
load(filename);

%% Loop over 7 heights for fix 'hc,speed,sparsity' to get 7 autocorrelation
i = 1;
for height = 1:1:7  %% ++for Z %%%% i before
    u = 	U{height,j}; %% j is the speed -- fixed by user
    N      = length(u);
    
    if (mod(N,2) == 1)
        u = u(1:N-1); % last entry of u,w,t are truncated to get length(u)=even
        w = W{height,j}(1:N-1);
        t   =   time{height,j}(1:N-1); t = circshift(t,1); t(1,1) = 0;
        N = length(u); % Note this is the length of the new truncated u
    else
        w = W{height,j};
        t   =   time{height,j}; t = circshift(t,1); t(1,1) = 0;
    end

    ubar = mean(u);
    wbar = mean(w);
    
    uprime = u-ubar;
    wprime = w-wbar;
    
    uu     = uprime.^2;
    ww     = wprime.^2;
    
    uubar  = mean(uu);
    wwbar  = mean(uu);
    
    Su     = mean(uprime.^3)/(uubar.^1.5);
    Sw     = mean(wprime.^3)/(wwbar.^1.5);
	
	Ku	   = mean(uprime.^4)/(uubar.^2);
    Kw	   = mean(uprime.^4)/(uubar.^2);
    % Computation of autocorrelation with Fourier transforms and Hann windowing
    start(i)=tic;
    tshots = 0:1:N-1;
    w = 0.5*(1 - cos(2*pi*tshots/N))';
    Yf = 1/N*(fft(uprime.*w)); %Fourier coefficients
    Rf = Yf.*conj(Yf);
    R{height,1} = N*ifft(Rf);
    ac2{height,1} = R{height,1}./R{height,1}(1);          % NORMALIZED AUTOCORRELATION %
    elapsed_time(i) = toc(start(i));
    i = i+1;
    
    %% Filtering the correlation to remove noise Savitzky-Golay Filters
    %     order = 3;
    %     framelen = 39;
    %     sgf = sgolayfilt(ac2{height,1},order,framelen);
    %     m = (framelen-1)/2;
    %     B = sgolay(order,framelen);
    %     steady = conv(ac2{height,1},B(m+1,:),'same');
    %     ybeg = B(1:m,:)*ac2{height,1}(1:framelen);
    %     yend = B(framelen-m+1:framelen,:)*ac2{height,1}(N-framelen+1:N);
    %     cmplt = steady;
    %     cmplt(1:m) = ybeg;
    %     cmplt(N-m+1:N) = yend;
    %     ac3{height,1} = cmplt;          % FILTERED AUTOCORRELATION %
end

%% Plotting the normalized autocorrelation function
% plotStyle = {'r-','g-','b-'};
figure(1); clf; hold on

cmap = colormap('hot');
cmap = cmap(1:60,:);
colormap(cmap)
c = colorbar;

M = N;%length(ac2{1,1});
for height = 1:1:7
    plot(t(1:floor(M/2)), ac2{height,1}(1:floor(M/2)),'Color',cmap(height*7,:));
end

title_format = '$h_c/H=$ %0.02f, $Re_d=$ %d, $\\lambda_p=$ %0.03f'; % %s flow, %s canopy";
str = sprintf(title_format,hc/H,Re_d,lam_p);
title(str,'interpreter','latex');%'FontSize', 11.5);
set(gca,'fontsize',12)
xlim([0 5])
ylabel('${\left\langle u(t)u(t+s) \right\rangle }/{\left\langle u{{(t)}^{2}} \right\rangle }\;$','interpreter','latex');%,'FontSize', 13);
xlabel('time lag : $s$ in $seconds$','interpreter','latex');
c.Label.String = '$z/H$';
c.Label.Interpreter = 'latex';

