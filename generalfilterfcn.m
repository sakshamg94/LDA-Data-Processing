function [ufilt,tfilt]=generalfilterfcn(vel,t_raw,Fs,type)
% Syntax - [ufilt,tfilt] = generalfilterfcn(vel,t_raw,Fs,type)
% This is a Gaussian filter function with 50% overlapping windows
% generalized for use with Vectrino (3D) or LDA (2D or 1D) data. Inputs:
% vel is a velocity time series column vector that has either 1,2,3 or
% three colmns corresponding to the velocity componenents output by the
% instrument. t_raw is the time stamp column vector in [ms], which is the
% native output of the BSA Flow Software (note: an artificial time series
% must be constructed for Vectrino data, ensure units of [ms] and a single
% column structure). Fs is the desired resampling frequency of the output
% data. type is a string identifying the instrument used, with acceptable
% values 'vec', '1d_lda', or '2d_lda' which are pretty self explanatory.
% Outputs: ufilt is a velocity time series with the same structure as vel.
% tfilt is a constant interval time stamp column vector with interval 1/Fs.


nPointTol= 2;   % tolerance on # of points - if there are fewer points than
                % this in the Gaussian window, throw out datapoint / set to
                % NaN

if strcmp(type,'vec')==1

    t_max = floor(t_raw(end)/1000); %total sampling time, in [s]

    t_win = 1/Fs;

    n = floor(t_max*Fs);            % added "floor"
    t = t_win:t_win:t_max;

    u = zeros(1,n);
    v = zeros(1,n);
    w = zeros(1,n);

    sigma = t_win;
    dist = t_raw/1000;

    for i = 1:n
        dist = dist-t_win;
        r = abs(dist)<t_win*2;
        if sum(r)<nPointTol 
            u(i) = NaN;
            v(i) = NaN;
            w(i) = NaN;
        else
            weights = exp(-dist(r).^2/(2*sigma^2));
            u(i) = weights'*vel(r,1)/sum(weights); 
            v(i) = weights'*vel(r,2)/sum(weights);
            w(i) = weights'*vel(r,3)/sum(weights);
        end
    end
    
    if sum(isnan(u)) > 0
        u_fixed = fillholes(u,'hold');
    else
        u_fixed = u;
    end
    
    if sum(isnan(v)) > 0
        v_fixed = fillholes(v,'hold');
    else
        v_fixed = v;
    end
    
    if sum(isnan(w)) > 0
        w_fixed = fillholes(w,'hold');
    else
        w_fixed = w;
    end
    
    ufilt=[u_fixed',v_fixed',w_fixed'];

elseif strcmp(type,'2d_lda')==1

    t_max = floor(t_raw(end)/1000); %total sampling time, in [s]

    t_win = 1/Fs;

    n = floor(t_max*Fs);
    t = t_win:t_win:t_max;

    u = zeros(1,n);
    w = zeros(1,n);

    sigma = t_win;
    dist = t_raw/1000;

    for i = 1:n
        dist = dist-t_win;
        r = abs(dist)<t_win*2;
        if sum(r)<nPointTol 
            u(i) = NaN;
            w(i) = NaN;
        else
            weights = exp(-dist(r).^2/(2*sigma^2));
            u(i) = weights'*vel(r,1)/sum(weights); 
            w(i) = weights'*vel(r,2)/sum(weights);
        end
    end
    
    if sum(isnan(u)) > 0
        u_fixed = fillholes(u,'hold');
    else
        u_fixed = u;
    end
    
    if sum(isnan(w)) > 0
        w_fixed = fillholes(w,'hold');
    else
        w_fixed = w;
    end
    
    ufilt=[u_fixed',w_fixed'];
    
elseif strcmp(type,'1d_lda')==1

    t_max = floor(t_raw(end)/1000); % total sampling time, in [s]

    t_win = 1/Fs;                   % time window

    n = floor(t_max*Fs);            % added "floor"
    t = t_win:t_win:t_max;

%     keyboard
    
    u = zeros(1,n);

    sigma = t_win;                  % spread of Gaussian filter
    dist = t_raw/1000;

    for i = 1:n
        dist = dist-t_win;
        r = abs(dist)<t_win*2;
        if sum(r)<nPointTol 
            u(i) = NaN;
        else
            weights = exp(-dist(r).^2/(2*sigma^2));
            u(i) = weights'*vel(r,1)/sum(weights); 
        end
    end
    
%     keyboard
    
    if sum(isnan(u)) > 0
        u_fixed = fillholes(u,'hold');
    else
        u_fixed = u;
    end
    
    ufilt=u_fixed';
    
end

tfilt=t;

end