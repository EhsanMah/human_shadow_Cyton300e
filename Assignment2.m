clear all
clc
clf

%% movement
Cyton = UR10

load('cyton_q.mat');
% for i=120:5:15
%     pos = Cyton.model.fkine(cyton_q(i,:))
%     if pos(3,4)>0 
Cyton.RMRC(0.00,0.00,0.2)
Cyton.RMRC(0.00,0.05,0.2)
Cyton.RMRC(0.1,0.00,0.2)
disp('first pose done')
%     else
%         
%         disp('not viable point')
%     end
% 
% 
% end
% for i =2:size(cyton_q)
%% Pos= Cyton.model.fkine(cyton_q(1,:)); 
  imaqreset;
   Cyton = UR10;
% create color and depth kinect videoinput objects
colorVid = videoinput('kinect', 1);
depthVid = videoinput('kinect', 2);
triggerconfig (depthVid,'manual');
framesPerTrig = 1;
depthVid.FramesPerTrigger=framesPerTrig;
depthVid.TriggerRepeat=inf;
src = getselectedsource(depthVid);
src.EnableBodyTracking = 'on'; 
% triggerconfig([depthVid colorVid],'manual');
start(depthVid);

% start(colorVid);
himg = figure;

   
    %# infinite loop
                                         %# index
    
    
    
prevPos = zeros(1,3);
SkeletonConnectionMap = [ [4 3];  % Neck
                          [3 21]; % Head
                          [21 2]; % Right Leg
                          [2 1];
                          [21 9];
                          [9 10];  % Hip
                          [10 11];
                          [11 12]; % Left Leg
                          [12 24];
                          [12 25];
                          [21 5];  % Spine
                          [5 6];
                          [6 7];   % Left Hand
                          [7 8];
                          [8 22];
                          [8 23];
                          [1 17];
                          [17 18];
                          [18 19];  % Right Hand
                          [19 20];
                          [1 13];
                          [13 14];
                          [14 15];
                          [15 16];
                        ];
while ishandle(himg)
trigger(depthVid)
[depthMap, ts, depthMetaData] = getdata (depthVid);
% [colorMap, ts, colorMetaData] = getdata (colorVid);
anyBodiesTracked = any(depthMetaData.IsBodyTracked ~= 0);
trackedBodies = find(depthMetaData.IsBodyTracked);
nBodies = length(trackedBodies);
colors = ['g';'r';'b';'c';'y';'m'];
imshow (depthMap, [0 4096]);
  %# update point & text

if  sum(depthMetaData.IsBodyTracked) >0
skeletonJoints = depthMetaData.DepthJointIndices (:,:,depthMetaData.IsBodyTracked);
hold on;

for i = 1:24

X1 = [skeletonJoints(SkeletonConnectionMap(i,1),1,1); skeletonJoints(SkeletonConnectionMap(i,2),1,1)];
Y1 = [skeletonJoints(SkeletonConnectionMap(i,1),2,1), skeletonJoints(SkeletonConnectionMap(i,2),2,1)];
jointPos = depthMetaData.JointPositions(:,:,1);
handPos = jointPos(8,:);
robPose = handPos/8;
jointX = robPose(1,1);
jointY = robPose(1,3);
jointZ = robPose(1,2);

if jointX<0.35||jointX>-0.35||jointY<0.3||jointY>-0.3 ||jointZ<0.36 || jointZ>-0.65
%     if jointX-prevPos(1,1)>0.04 || jointY-prevPos(1,2)>0.04 || jointZ-prevPos(1,3)>0.04 
          Cyton.RMRC(jointX,jointY,jointZ+0.04)
        disp("Hand Position Changed")
        disp(handPos)
        disp("Robot Position Changed")
        disp(robPose)
        disp('numbers of body detected')
        disp(nBodies)  
%     end

    prevPos(1,1)= jointX;
    prevPos(1,2)= jointY;
    prevPos(1,3)= jointZ;
end

axis on;

%   h = plot(skeletonJoints(SkeletonConnectionMap(i,1),1,body), skeletonJoints(SkeletonConnectionMap(i,2),1,body),'.','MarkerSize',15); % Plota no imshow as juntas
 line(X1,Y1, 'LineWidth', 2, 'LineStyle', '-' , 'Marker', '+', 'Color', colors(1));
 rectangle('Position',[100 100 350 250],'LineWidth', 3,'EdgeColor',[1 0 0]);
   
end
hold off;

end

end
stop(depthVid);

% end