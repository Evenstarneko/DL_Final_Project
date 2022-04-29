%Plot Taylor et al 2014 for SFN 2017
clear all; close all; clc;

%Plot formatting
fontsize = 20;
linewidth = 3;
markersize = 4;
smoothwin = 3;

%Load & format data
load data
numsubs = 55;
%First 15 subjects are Taylor et al 2014
%16 to 25 are the similar to Taylor et al 2014 (rotating group from Bond
%and Taylor 2015
%26 to 35 are fixed landmarks in Bond and Taylor 2015
%36 to 45 are from Brudner et al 2016 with rotatin landmarks
%46 to 55 are from an unpublished study looking at aging (just normal
%college aged controls in a rotating landmarks condition)

for si = 1:numsubs
hand_angle(si,:) = data.hand_angle(si,:);
explicit(si,:) = data.explicit(si,:);
temp = data.implicit(si,:);
temp(1:48) = 0;
implicit(si,:) = temp;
end
numofmoves = 456;

figure;hold on;
for si = 1:numsubs
plot(linspace(0,numofmoves,numofmoves),data.rotation(si,:),'Color','red');
end


%Trial locations
baseloc = 1:56;
rotloc = 57:376;
washloc = 377:456;
numofmoves = 456;

%Bins
baselocbin = 1:7;
rotlocbin = 8:47;
washlocbin = 48:57;
numbins = 57;

%Plot hand angle curve%----------------------------------------------------
figure; hold on;
plot(linspace(0,numofmoves,numofmoves),zeros(1,numofmoves),'k--');
plot(linspace(0,numofmoves,numofmoves),45*ones(1,numofmoves),'k--');
plot(56/8*ones(1,numofmoves),linspace(-100,100,numofmoves),'k--');
plot(376/8*ones(1,numofmoves),linspace(-100,100,numofmoves),'k--');
alpha(0.2)
xlabel('Movement Number','fontsize',fontsize);
ylabel('Hand Angle(deg)','fontsize',fontsize);
title('Learning Curve','fontsize',fontsize+1);
set(gca,'xtick',[1 56 136 216 296 376 456]./8);
set(gca,'xticklabel',[1 56 136 216 296 376 456]);
set(gca,'ytick',[-90:15:90]);
set(gca,'yticklabel',[-90:15:90]);
axis([0 numbins -15 60]);
plot_format(linewidth,fontsize);

%Add explicit
plot(explicit(:,[baselocbin,rotlocbin]),'color',[0 0 1],'linewidth',linewidth);
alpha(0.2)

%Add implicit
plot(implicit(:,1:55),'color',[1 0 0],'linewidth',linewidth);
alpha(0.2)

