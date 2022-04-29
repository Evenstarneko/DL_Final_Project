function format_plot(linewidth,fontsize)
if nargin < 1
    linewidth = 2;
end
if nargin < 2
    fontsize = 14;
end

set(gca,'box','on');
set(gca,'fontsize',fontsize-1);
set(gca,'linewidth',linewidth);
axis square
