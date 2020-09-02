function [dt]=deseason(y,dates);
% dates em numero juliano
dd = round(mean(diff(dates)));
T = length(y);

if dd == 1
    
    nn = 365;
    
elseif dd == 30
    
    nn = 12;
    
end

% figure
% plot(dates,y)
% hold on
% datetick('x')

% Smooth the data using a 13-term moving average. 
sW13 = [1/(nn*2);repmat(1/nn,nn-1,1);1/(nn*2)];
yS = conv(y,sW13,'same');

% plot(dates,yS,'g')
% To prevent observation loss, repeat the first and last smoothed values six times.
mm = round(nn/2);
yS(1:mm) = yS(mm+1); yS(T-(mm-1):T) = yS(T-mm);


% plot(dates,yS,'m')
% Subtract the smoothed series from the original series to detrend the data.
xt = y-yS;
xt = xt';

% plot(dates,xt,'k')

% Month means
s = 12;

for ii = 1:s
sst(ii) = nanmean(xt(str2num(datestr(dates,'mm'))==ii),1);
end

sst = sst';
if dd == 1
tt = linspace(datenum(0,1,1),datenum(0,12,1),12)';
tm = linspace(datenum(0,1,1),datenum(0,12,31),nn)';
sst = interp1(tt,sst,tm,'linear','extrap');
end

% Put smoothed values back into a vector of length N
nc = floor(T/nn); % no. complete years
rm = mod(T,nn); % no. extra months
sst = [repmat(sst,nc,1);sst(1:rm)];

% tt = repmat([1:s]',nc,1);
% tm = tt*30;
% tm = [tm(1):tm(end)];
% 
% sst2 = [sst2;sst(1:rm)];

% plot(dates,sst,'k','LineWidth',2);
 
%  Center the seasonal estimate (additive)
sBar = mean(sst); % for centering
sst = sst-sBar;
plot(dates,sst,'m','LineWidth',2); 
 
 
 
 %deseasonalize
 dt = y' - sst;
%  plot(dates,dt,'g')
 return