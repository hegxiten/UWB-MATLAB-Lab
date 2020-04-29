% Ground truth
X_TRUE=[0,      0.25,   0.5,    0.75,   1,      1.25,   1.5,    1.75];
T_TRUE=[1.4,    1.4,    1.4,    1.4,    1.4,    1.4,    1.4,    1.4,];

% Experiment 1, 5 anchors
figure(1);
subplot(1,2,1);
hold on;

% Anchor position for geo_1
x_anch=[0,  1,  2,  0,      2];
y_anch=[0,  0,  0,  2.8,    2.8];

x_geo1=[-0.033, 0.280,  0.297,  0.778,  1.093,  1.367,  1.64,   1.95];%5 anchors data Slide 18
y_geo1=[1.344,  1.412,  1.416,  1.552,  1.491,  1.576,  1.59,   1.56];
x_geo1_std=[0.087,  0.038,  0.038,  0.030,  0.026,  0.018,  0.025,  0.029];
y_geo1_std=[0.028,  0.017,  0.017,  0.021,  0.015,  0.010,  0.014,  0.013];

% Plot the std. deviation for all data points of geo1
for i = 1:1:8
    theta = 0 : 0.01 : 2*pi;
    xcenter=x_geo1(i);
    ycenter=y_geo1(i);
    xradius=x_geo1_std(i);
    yradius=y_geo1_std(i);
    x_s = xradius * cos(theta) + xcenter;
    y_s = yradius * sin(theta) + ycenter;
    
    h = fill(x_s,y_s,'b');
    % Choose a number between 0 (invisible) and 1 (opaque) for facealpha.  
    set(h,'facealpha',0.3)
    a5=plot(x_s, y_s);
    hold on
end
% Plot the anchor positions
anch=plot(x_anch,y_anch,'b^');
% Plot the buffer (+-10cm) for decawave
rectangle('Position',[-0.10 1.3 2 0.25], 'LineStyle','--', 'EdgeColor','m');
% Plot the true positions of tags
true_pos=plot(X_TRUE,T_TRUE,'r*');
% Plot the measured positions of tags
measured_1 = plot(x_geo1,y_geo1,'b-o');
axis([-0.5 2.5 -0.5 3]);
daspect([1 1 1]);
l=legend([true_pos,measured_1,a5,anch],'True Position','Measured Position','Standard Deviation','Anchor');
set(l, 'Location', 'north');
title('Geofencing');
xlabel('X coordinate (m)');
ylabel('Y coordinate (m)');
hold off;

subplot(1,2,2)
% Zoom in, plot error bar
errorbar(x_geo1, y_geo1, y_geo1_std, y_geo1_std, x_geo1_std, x_geo1_std,...
    'Marker','o');
hold on;
% replot in a zoomed-in manner
true_pos=plot(X_TRUE,T_TRUE,'r*');
l=legend([true_pos,measured_1],'True Position','Measured Position');
set(l, 'Location', 'southoutside');
axis([-0.5 2.5 1.2 1.7]);
daspect([0.1 0.1 0.1]);
hold off;
% Experiment 2, 6 anchors
figure(2);
set(gcf,'unit','normalized','position',[0.2,0.2,0.5,0.5]);
true_pos=plot(X_TRUE,T_TRUE,'r*');
hold on;

% Anchor position for geo_2
x_anch_addition=[1];
y_anch_addition=[0.7];
anch=plot(x_anch,y_anch,'b^');
anch_add=plot(x_anch_addition, y_anch_addition,'r^');

% Plot the buffer (+-10cm) for decawave
rectangle('Position',[-0.10 1.3 2 0.25], 'LineStyle','--', 'EdgeColor','m');

%6 anchors, one additional to compensate the blocking vehicle
x_geo2=[0.061,  0.432,  0.653,  0.946,  1.064,  1.296,  1.656,  1.75];
y_geo2=[1.47,   1.47,   1.41,   1.434,  1.418,  1.490,  1.510,  1.513];
x_geo2_std=[0.028,  0.041,  0.047,  0.036,  0.019,  0.037,  0.028,  0.025];
y_geo2_std=[0.015,  0.021,  0.028,  0.026,  0.013,  0.014,  0.013,  0.012];

%Plot the std. deviation for all data points of geo2
for i = 1:1:8
    theta = 0 : 0.01 : 2*pi;
    xcenter=x_geo2(i);
    ycenter=y_geo2(i);
    xradius=x_geo2_std(i);
    yradius=y_geo2_std(i);
    x_s = xradius * cos(theta) + xcenter;
    y_s = yradius * sin(theta) + ycenter;
    
    h = fill(x_s,y_s,'b');
    % Choose a number between 0 (invisible) and 1 (opaque) for facealpha.  
    set(h,'facealpha',0.3)
    a6=plot(x_s, y_s);
    hold on
end

ans2=plot(x_geo2,y_geo2,'b-o');
axis([-0.5 2.5 -0.5 3]);
daspect([1 1 1]);
l=legend([true_pos,ans2,a6,anch, anch_add],'True Position','Measured Position','Standard Deviation','Original Anchors', 'Added Anchor');
set(l, 'Location', 'north');
title('Geofencing');
xlabel('X coordinate (m)');
ylabel('Y coordinate (m)');



