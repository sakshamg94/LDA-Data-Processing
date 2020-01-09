function [x]=fillholes(x,fillmeth,fillset)

numsamps=length(x);

if sum(isnan(x))==numsamps;
    for i=1:numsamps;
        x(i)=0;
    end;
    fillmeth='fail';
end;

if strcmp(fillmeth,'hold'); %hold previous
    lookback=0;
    while isnan(x(1));
        x(1)=x(numsamps-lookback);
        lookback=lookback+1;
    end;
    for n=2:numsamps;
        if isnan(x(n));
            x(n)=x(n-1);
        end;
    end;
elseif strcmp(fillmeth,'mean'); %mean
    xmean=nanmean(x);
    for n=1:numsamps;
        if isnan(x(n));
            x(n)=xmean;
        end;
    end;
elseif strcmp(fillmeth,'neighbors'); %avg neighbors
    if isnan(x(1));
        lookback=0;
        lookforward=0;
        while isnan(x(2+lookforward));
            lookforward=lookforward+1;
        end;
        while isnan(x(numsamps-lookback))
            lookback=lookback+1;
        end;
        x(1,1)=(x(2+lookforward)+x(numsamps-lookback))/2;
    end;
    if isnan(x(numsamps));
        lookback=1;
        lookforward=1;
        while isnan(x(lookforward));
            lookforward=lookforward+1;
        end;
        while isnan(x(numsamps-lookback))
            lookback=lookback+1;
        end;
        x(numsamps)=(x(lookforward)+x(numsamps-lookback))/2;
    end;
    for n=2:numsamps-1;
        if isnan(x(n));
            lookforward=1;
            while isnan(x(n+lookforward));
                lookforward=lookforward+1;
            end;
            x(n)=(x(n-1)+x(n+lookforward))/2;
        end;
    end;
elseif strcmp(fillmeth,'spline'); %cubic spline
    steps=fillset;
    [rows,cols]=size(x);
    if rows>cols;
        xtemp=[x(numsamps-(steps)+1:numsamps); x; x(1:steps)];
    elseif cols>rows;
        xtemp=[x(numsamps-(steps)+1:numsamps) x x(1:steps)];
    end;
    for n=1+(steps):numsamps+(steps);
        if isnan(xtemp(n));
            if sum(isnan(xtemp((n-steps):(n+steps))))>((length(xtemp((n-steps):(n+steps))))-2)
                filler=nanmean(xtemp);
            else
                filler=interp1((n-steps):(n+steps),xtemp((n-steps):(n+steps)),n,'spline');
            end;
            if filler>max(xtemp)
                xtemp(n)=max(xtemp);
            elseif filler<min(xtemp)
                xtemp(n)=min(xtemp);
            else
                xtemp(n)=filler;
            end;
        end;
    end;
    x=xtemp(1+(steps):numsamps+(steps));
    
%     tempx=[x;x;x];
%     len=length(x);
%     steps=30;
%     for n=steps+1+len:(numsamps-steps-1)+len;
%         if isnan(tempx(n));
%             tempx(n)=interp1((n-steps):(n+steps),tempx((n-steps):(n+steps)),n,'spline');
%         end;
%     end;
%     x=tempx(1+len:len+len);
end;

if sum(isnan(x))>0;
    for i=1:numsamps;
        x(i)=0;
    end;
end;