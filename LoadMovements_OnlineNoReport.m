%Load data set
clear; close all; clc;


initials = {'WYS','AEB','SCK','EHR','DNN','CN','AP','MPB','BMB','ALM','SK','MT','AB','AM','GY'};

blocks = {'BASEFB','BASEENDFB','ROTONE','ROTTWO'};
movepath = '../Data/OnlineNoAimData/';
datapath = '../Data/OnlineNoAimData/';
movelens = [16,32,168,240];
%Number of blocks
numblocks = 4;
movesperblock = [16,32,168,240];
moveduration = 1000;

for si = 1:length(initials)
    fprintf('Loading Subject %s\n',initials{si});
    trialone = 0;
    movedata=[];
    trialdata=[];
    for bi=1:numblocks
        %Load target set
        fprintf('Loading Game Data for  Block %2.0f\n',bi);
        fileloc = strcat(datapath,initials{si},blocks{bi},'.txt')
        temp=importdata(fileloc);
        size(temp.data)
        temp.data(:,1) = trialone + temp.data(:,1);
        trialdata=[trialdata;temp.data];
        
        %Load movement data
        fprintf('Loading Movement Data for Block %2.0f\n',bi);
        fileloc = strcat(datapath,'MOVE',initials{si},blocks{bi},'.txt');
        temp=importdata(fileloc);
        temp.data(:,1) = trialone + temp.data(:,1);
        movedata=[movedata;temp.data];
        trialone= trialone + movelens(bi);
    end
    
    
    %Separate out movements
    time = NaN*ones(sum(movesperblock),moveduration);
    cursor_x = NaN*ones(sum(movesperblock),moveduration);
    cursor_y = NaN*ones(sum(movesperblock),moveduration);
    hand_x = NaN*ones(sum(movesperblock),moveduration);
    hand_y = NaN*ones(sum(movesperblock),moveduration);
    
    trialnum = movedata(:,1);
    flag = movedata(:,2);
    for mi = 1:trialnum(end)
        where = find(trialnum == mi & (flag > 2 & flag < 5));
        %where = find(trialnum == mi);
        lens(si,mi) = length(where);
        if ~isempty(where) && length(where) < moveduration;
            t = movedata(where,3);
            startx = movedata(where,7);
            starty = movedata(where,8);
            cursorx = movedata(where,9);
            cursory = movedata(where,10);
            handx = movedata(where,11);
            handy = movedata(where,12);
            
            time(mi,1:lens(si,mi)) = t;
            cursor_x(mi,1:lens(si,mi)) = cursorx - startx;
            cursor_y(mi,1:lens(si,mi)) = starty - cursory;
            hand_x(mi,1:lens(si,mi)) = handx - startx;
            hand_y(mi,1:lens(si,mi)) = starty - handy;
            
            cursor_x(mi,lens(si,mi)+1:end) = cursor_x(mi,lens(si,mi));
            cursor_y(mi,lens(si,mi)+1:end) = cursor_y(mi,lens(si,mi));
            hand_x(mi,lens(si,mi)+1:end) = hand_x(mi,lens(si,mi));
            hand_y(mi,lens(si,mi)+1:end) = hand_y(mi,lens(si,mi));
            
        else
            
            fprintf('\n\n!!!!Movement is long\n');
            mi
%             t = movedata(where,3);
%             if ~isempty(t)
%                 startx = movedata(where,7);
%                 starty = movedata(where,8);
%                 cursorx = movedata(where,9) - startx;
%                 cursory = starty - movedata(where,10);
%                 handx = movedata(where,11) - startx;
%                 handy = starty - movedata(where,12);
%                 
%                 
%                 newcursorx = spline(linspace(0,length(cursorx),length(cursorx)),cursorx,linspace(0,length(cursorx),moveduration));
%                 newcursory = spline(linspace(0,length(cursory),length(cursory)),cursory,linspace(0,length(cursory),moveduration));
%                 newhandx = spline(linspace(0,length(handx),length(handx)),handx,linspace(0,length(handx),moveduration));
%                 newhandy = spline(linspace(0,length(handy),length(handy)),handy,linspace(0,length(handy),moveduration));
%                 
%                 time(mi,:) = linspace(0,moveduration,moveduration);
%                 cursor_x(mi,:) = newcursorx;
%                 cursor_y(mi,:) = newcursory;
%                 hand_x(mi,:) = newhandx;
%                 hand_y(mi,:) = newhandy;
%             else
                time(mi,:) = NaN;
                cursor_x(mi,:) = NaN;
                cursor_y(mi,:) = NaN;
                hand_x(mi,:) = NaN;
                hand_y(mi,:) = NaN;
%             end
        end
        %
        
        %         plot(cursor_x(mi,:),cursor_y(mi,:))
        %         axis equal
        %         %axis([-100 100 -100 100])
        %         title(['Target Angle: ',num2str(trialdata(mi,3))]);
        %         h=1
    end
    
    data.time(si,:,:) = time;
    data.cursor_x(si,:,:) = cursor_x;
    data.cursor_y(si,:,:) = cursor_y;
    data.hand_x(si,:,:) = hand_x;
    data.hand_y(si,:,:) = hand_y;
    
    
    
    %Store game data
    data.trialnum(si,:) = trialdata(:,1)';
    data.target_dist(si,:) = trialdata(:,2)';
    data.target_angle(si,:) = trialdata(:,3)';
    data.rotation(si,:)  = trialdata(:,4)';
    data.translation(si,:)  = trialdata(:,5)';
    data.field(si,:) = trialdata(:,6)';
    data.field_strength(si,:) = trialdata(:,7)';
    
    data.aiming_targets(si,:) = trialdata(:,8)';
    data.target_ring(si,:) = trialdata(:,9)';
    data.target_line(si,:) = trialdata(:,10)';
    data.online_feedback(si,:) = trialdata(:,11)';
    data.endpoint_feedback(si,:) = trialdata(:,12)';
    data.channel_feedback(si,:) = trialdata(:,13)';
    
    data.cursor_angle(si,:) = trialdata(:,14)';
    data.cursor_r(si,:) = trialdata(:,15)';
    data.hand_angle(si,:) = trialdata(:,16)';
    data.hand_r(si,:) = trialdata(:,17)';
    
    data.target_x(si,:) = trialdata(:,28)';
    data.target_y(si,:) = trialdata(:,29)';
    data.endcursor_x(si,:) = trialdata(:,30)';
    data.endcursor_y(si,:) = trialdata(:,31)';
    data.endhand_x(si,:) = trialdata(:,32)';
    data.endhand_y(si,:) = trialdata(:,33)';
    
    data.hit(si,:) = trialdata(:,34)';
    
    data.trial_time(si,:) = trialdata(:,35)';
    data.reaction_time(si,:) = trialdata(:,36)';
    data.movement_time(si,:) = trialdata(:,37)';
    data.fb_time(si,:) = trialdata(:,38)';
    data.find_time(si,:) = trialdata(:,39)';
    data.hold_time(si,:) = trialdata(:,40)';
    
    data.abs_start_time(si,:) = trialdata(:,41)';
    data.abs_trial_time(si,:) = trialdata(:,42)';
    data.pixel2mm(si,:) = trialdata(:,43)';
    
    
    for mi = 1:trialnum(end)
        [xr,yr] = coord_transform(data.endhand_x(si,mi),data.endhand_y(si,mi),data.target_angle(si,mi));
        [xr,yr] = coord_transform(xr,yr,0);
        data.hand_angle(si,mi) = atan2(yr,xr)*180/pi;
    end
end
save OnlineNoAimData data