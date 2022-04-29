function [y,vary,iqry,ycleanstd,ycleaniqr,cony,stdy] = nanbin(x,numbins)
%Y = EQUALNUM_BINS(X,NUMBINS)
%This function divided the data in x into an equal number of bins.
%
%Created by Jordan Taylor on March 4, 2008 last modified on 7/2/08
m = size(x);
if m(1) < m(2)
    x = x';
end
x = x(~isnan(x));
if length(x) < numbins
    fprintf('\nERROR: The length of the data is less than the number of bins');
end
y = zeros(1,numbins);
remainder = rem(length(x),numbins);
N = length(x)/numbins;

binstart = round(1:N:length(x));
binstop = [binstart(2:end)-1, length(x)];
binsize = length(binstart:binstop)-1;
for i = 1:numbins
    xx = x(binstart(i):binstop(i));
    y(i) = nanmean(x(binstart(i):binstop(i)),1);
    vary(i) = nanvar(x(binstart(i):binstop(i)),1);
    stdy(i) = nanstd(x(binstart(i):binstop(i)),1);
    
    cony(i) = 1.96*nanstd(x(binstart(i):binstop(i)),1)/binsize;

    iqry(i) = iqr(x(binstart(i):binstop(i)),1);
    
    where = find(abs(xx) < 1.5*iqry(i));
    ycleaniqr(i) = nanmean(xx(where),1);
    where = find(abs(xx) < 3*stdy(i));
    ycleanstd(i) = nanmean(xx(where),1);
    
end
return
