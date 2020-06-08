% ------------ Data input ------------
global X_SCALE Y_SCALE ACCURACY_BUFFER 
global BLOCKAGE_POS BUFFER_POS BUFFER_POS_scaled
global X_ANCH Y_ANCH X_ANCH_ADDITIONAL Y_ANCH_ADDITIONAL
X_SCALE = 1/8;          % the X scale ratio used for this miniature experiment
Y_SCALE = 1/8;          % the Y scale ratio used for this miniature experiment
ACCURACY_BUFFER = 0.1;  % accuracy buffer provided by Decawave

% Position of metal blockage (rectangular shape) used in the experiment
% Four-element vector of the form [x y w h]: 
% x, y of lower-left corner;
% w, h - width and height of the rectangle
BLOCKAGE_POS = [0.7, 0.65, 0.6, 0.02];

% Ground truth values of tag positions, X and Y
Y_TAG = 1.4;    % all the tags have the same ground truth Y value
X_TRUE = [0,      0.25,   0.5,    0.75,   1,      1.25,   1.5,    1.75];
Y_TRUE = repelem(Y_TAG, 8);


% factual buffer position, unscaled
BUFFER_POS = [
    min(X_TRUE) - ACCURACY_BUFFER, ...
    min(Y_TRUE) - ACCURACY_BUFFER, ...
    min(X_TRUE) - ACCURACY_BUFFER + (max(X_TRUE) - min(X_TRUE)) + ACCURACY_BUFFER*3, ...
    2 * ACCURACY_BUFFER];
% scaled buffer position, rectangle
% Four-element vector of the form [x y w h]: 
% x, y of lower-left corner;
% w, h - width and height of the rectangle
BUFFER_POS_scaled = [
    min(X_TRUE) - ACCURACY_BUFFER*X_SCALE, ...
    min(Y_TRUE) - ACCURACY_BUFFER*Y_SCALE, ...
    min(X_TRUE) - ACCURACY_BUFFER*X_SCALE + (max(X_TRUE) - min(X_TRUE)) + ACCURACY_BUFFER*X_SCALE*3, ...
    2 * ACCURACY_BUFFER*Y_SCALE];

% measured positions of tags with 5 anchors: experiment 1
[x_exp1,y_exp1,x_exp1_std,y_exp1_std] = getData("Five_anchors");

% measured positions of tags with 6 anchors: experiment 2
% experiment 2: added one additional anchor to compensate the blockage
% TODO: implement a datapreprocessing pipeline to avoid hard coded data
[x_exp2,y_exp2,x_exp2_std,y_exp2_std] = getData("Six_anchors");


% Calculate the scaled value for measured Y values of both experiments
y_exp1_scaled_delta = (Y_TRUE - y_exp1)*Y_SCALE + Y_TRUE;
y_exp2_scaled_delta = (Y_TRUE - y_exp2)*Y_SCALE + Y_TRUE;
% Anchor position for experiment 1
X_ANCH = [0,  1,  2,  0,      2];
Y_ANCH = [0,  0,  0,  2.8,    2.8];
% Anchor position for experiment 2, one additional anchor in red
X_ANCH_ADDITIONAL = [1];
Y_ANCH_ADDITIONAL = [0.7];

% ------------ Plotting Raw ------------
figure(1);
set(gcf,'unit','normalized','position',[0.2, 0.2, 0.5, 0.5]);
subplot(1,2,1);
% Experiment 1, 5 anchors
plotData(gca, x_exp1, y_exp1, x_exp1_std, y_exp1_std, X_TRUE, Y_TRUE,...
    false, 'Side Blockage NLOS Conditions, 5 Fixed Anchors',...
    'north', true, [-0.5 2.5 -0.5 3]);
subplot(1,2,2);
% % Experiment 2, 6 anchors
plotData(gca, x_exp2, y_exp2, x_exp2_std, y_exp2_std, X_TRUE, Y_TRUE,...
    true, 'Side Blockage NLOS Conditions, 5 Fixed Anchors and 1 Relaying Anchor',...
    'north', true, [-0.5 2.5 -0.5 3]);

% ------------ Plotting Zoomed ------------
figure(2)
subplot(2,1,1);
set(gcf,'unit','normalized','position',[0.2, 0.2, 0.5, 0.5]);
% Experiment 1, 5 anchors, zoomed in
plotData(gca, x_exp1, y_exp1, x_exp1_std, y_exp1_std, X_TRUE, Y_TRUE,...
    false, 'Side Blockage NLOS Conditions, 5 Fixed Anchors (Zoomed in)',...
    'northeast', true, [-0.5 2.5 1.2 1.7]);
% Experiment 2, 6 anchors, zoomed in
subplot(2,1,2);
plotData(gca, x_exp2, y_exp2, x_exp2_std, y_exp2_std, X_TRUE, Y_TRUE,...
    true, 'Side Blockage NLOS Conditions, 5 Fixed Anchors and 1 Relaying Anchor (Zoomed in)',...
    'northeast', true, [-0.5 2.5 1.2 1.7]);

% ------------ Plotting Scaled ------------
figure(3);
set(gcf,'unit','normalized','position',[0.2, 0.2, 0.5, 0.5]);
subplot(1,2,1);
% TODO: refactor this scaled plotting into the function plotData, instead
% of plotting in main() 
% 0608 --Zezhou


% ------------ Plotting ------------
% Plot scaled values for experiment 1, no zoom in, no buffer zone
figure(3);
subplot(1,2,1);
set(gcf,'unit','normalized','position',[0.2, 0.2, 0.5, 0.5]);
hold on;
% Plot the dummy handles for legend
block = plot(nan, nan, 'ks', 'MarkerFaceColor','k');
% Plot the anchor positions
anch = plot(X_ANCH,Y_ANCH,'b^');
% Plot the blockage
rectangle('Position',BLOCKAGE_POS, 'EdgeColor','k', 'FaceColor', 'k', 'Curvature', 0.2,'LineWidth',0.3);
% Plot the true positions of tags
true_pos = plot(X_TRUE,Y_TRUE,'r*-','LineWidth',1);
% Plot the measured positions of tags
scaled_1 = plot(x_exp1,y_exp1_scaled_delta,'b.-.','LineWidth',1);
axis([-0.5 2.5 -0.5 3]);
daspect([1 1 1]);
grid on;
l = legend([true_pos,scaled_1,anch, block],...
    'True Position','Measured Position (Scaled Y)',...
    'Anchor', 'Blockage');
set(l, 'Location', 'north');
title('Side Blockage NLOS Conditions, 5 Fixed Anchors, Scaled Y');
xlabel('X coordinate (m)');
ylabel('Y coordinate (m)');
hold off;

% ------------ Plotting ------------
% Plot scaled values for experiment 2, no zoom in, no buffer zone
subplot(1,2,2);
set(gcf,'unit','normalized','position',[0.2, 0.2, 0.5, 0.5]);
hold on;
% Plot the dummy handles for legend
block = plot(nan, nan, 'ks', 'MarkerFaceColor','k');
% Plot the additional anchor
anch = plot(X_ANCH,Y_ANCH,'b^');
anch_add = plot(X_ANCH_ADDITIONAL, Y_ANCH_ADDITIONAL,'r^');
% Plot the blockage
rectangle('Position',BLOCKAGE_POS, 'EdgeColor','k', 'FaceColor', 'k', 'Curvature', 0.2,'LineWidth',0.3);
% Plot the true positions of tags
true_pos = plot(X_TRUE,Y_TRUE,'r*-','LineWidth',1);
% Plot the measured positions of tags
scaled_2 = plot(x_exp2,y_exp2_scaled_delta,'b.-.','LineWidth',1);
axis([-0.5 2.5 -0.5 3]);
daspect([1 1 1]);
grid on;
l = legend([true_pos, scaled_2, anch, anch_add, block],...
    'True Position','Measured Position (Scaled Y)',...
    'Original Anchors', 'Added Anchor', 'Blockage');
set(l, 'Location', 'north');
title('Side Blockage NLOS Conditions, 5 Fixed Anchors and 1 Relaying Anchor, Scaled Y');
xlabel('X coordinate (m)');
ylabel('Y coordinate (m)');
hold off;

function [x_tag_pos_avg,y_tag_pos_avg,x_tag_pos_std,y_tag_pos_std]=getData(name)
    % %Anchor Positions  for height exp
    disp(name)
    cd (name)
    dinfo = dir('pos*.txt');
    filenames = {dinfo.name};
    x_tag_pos_avg=zeros(1,length(filenames));
    y_tag_pos_avg=zeros(1,length(filenames));
    x_tag_pos_std=zeros(1,length(filenames));
    y_tag_pos_std=zeros(1,length(filenames));
    for K = 1 : length(filenames)
        thisfile = filenames{K};
        cleanData(thisfile)
        pos1 = readtable('temp.txt');
        pos1 = pos1(:,1:2);
        pos1 = table2array(pos1);
        pos1 = pos1(any(~isnan(pos1),2),:);
        avgPos1 = mean(pos1);
        stdPos1 = std(pos1);
        x_tag_pos_avg(1,K) = avgPos1(1,1);
        y_tag_pos_avg(1,K) = avgPos1(1,2);
        x_tag_pos_std(1,K) = stdPos1(1,1);
        y_tag_pos_std(1,K) = stdPos1(1,2);
    end
cd ..
end

function cleanData(filename)
disp(filename)
fid = fopen(filename);
fid1 = fopen('temp.txt','wt');
% Can you please explain the use of regexp here and its purpose? 
% I am not too familiar with the use of regexp in general.
% -- Zezhou 0608
while ~feof(fid)
    tline = fgetl(fid);
    expression = '[^\n]*POS[^\n]*';
% I need some help understanding the purpose of 'POS' here. E.g. some
% examples of matching cases? Thank you very much! (sorry for not being 
% trained in regexp before)
% -- Zezhou 0608
    matches = regexp(tline,expression,'match');
% What is the case of matching? I ran the code and printed nothing matching 
% but all not matching. Is it just to print an additional /n sign for each line?
% -- Zezhou 0608
    if (isempty(matches ))
        fwrite(fid1,tline);
        fprintf(fid1,'\n');
    end
end
fclose(fid);
fclose(fid1); 
end

function plotData(ax, xTag, yTag, xTagStd, yTagStd, X_TRUE, Y_TRUE,...
    hasRelayingAnchors, plotTitle, legendPos, isErrorBar, zoomFactors)
% ------------ Plotting ------------
hold on;
% Plot the std. deviation for all data points
if isErrorBar
    e = errorbar(xTag, yTag, yTagStd, yTagStd, xTagStd, xTagStd,...
        'Marker','o','LineStyle','-','LineWidth',1, 'Color', 'b');
else
    std = plot(nan, nan, 'bo', 'MarkerFaceColor','b');
    for i = 1:1:length(xTag)
        theta = 0 : 0.01 : 2*pi;
        xcenter = xTag(i);
        ycenter = yTag(i);
        xradius = xTagStd(i);
        yradius = yTagStd(i);
        x_s = xradius * cos(theta) + xcenter;
        y_s = yradius * sin(theta) + ycenter;
        h = fill(x_s,y_s,'b','facealpha',0.3);
        hold on
    end
end

% Plot the dummy handles for the legend
buff = plot(nan, nan, 'LineStyle','-.', 'Color',[.61 .51 .74]); % purple
block = plot(nan, nan, 'ks', 'MarkerFaceColor','k');

% Plot the connection from truth to measurements
for i = 1:1:length(xTag)
    quiver(X_TRUE(i), Y_TRUE(i), xTag(i)-X_TRUE(i), yTag(i)-Y_TRUE(i),...
        'color','k','LineStyle',':','LineWidth',0.3);
    hold on
end
global X_ANCH Y_ANCH BUFFER_POS BLOCKAGE_POS X_ANCH_ADDITIONAL Y_ANCH_ADDITIONAL
% Plot the anchor positions
anch = plot(X_ANCH,Y_ANCH,'b^');
if hasRelayingAnchors
    % Plot the added relaying anchor
    anch_add = plot(X_ANCH_ADDITIONAL, Y_ANCH_ADDITIONAL,'r^');
end
% Plot the buffer (+-10cm) for decawave
rectangle('Position',BUFFER_POS, 'LineStyle','--', 'EdgeColor','m', ...
    'Curvature', 1,'LineWidth',0.3);
% Plot the blockage
rectangle('Position',BLOCKAGE_POS, 'EdgeColor','k', 'FaceColor', 'k', ...
    'Curvature', 0.2,'LineWidth',0.3);
% Plot the true positions of tags
true_pos = plot(X_TRUE,Y_TRUE,'r*-','LineWidth',1);
% Plot the measured positions of tags
measured = plot(xTag,yTag,'b.-.','LineWidth',1);
axis(zoomFactors);
daspect([1 1 1]);
grid on;
if isErrorBar
    if ~hasRelayingAnchors
        l = legend([true_pos,e,anch,buff,block],...
        'True Position','Measured Position',...
        'Fixed Anchors', 'Accuracy Buffer (�0.1m)', 'Blockage');
    else
        l = legend([true_pos,e,anch,anch_add,buff,block],...
        'True Position','Measured Position',...
        'Fixed Anchors', 'Relaying Anchor(s)', 'Accuracy Buffer (�0.1m)',...
        'Blockage');
    end
else
    if ~hasRelayingAnchors
        l = legend([true_pos,measured,buff,anch,block],...
        'True Position','Measured Position','Accuracy Buffer (�0.1m)',...
        'Fixed Anchors', 'Blockage');
    else
        l = legend([true_pos,measured,buff,anch,anch_add,block],...
        'True Position','Measured Position','Accuracy Buffer (�0.1m)',...
        'Fixed Anchors', 'Relaying Anchor(s)','Blockage');
    end
end
set(l, 'Location', legendPos);
title(plotTitle);
xlabel('X coordinate (m)');
ylabel('Y coordinate (m)');
hold off;
end