classdef UR10 < handle
    properties
        %> Robot model
        model;
        Brick_h;
        b;
        brickVertexCount;
        BrickPose;
        CollisionFlag = 0;
%         q = zeros(1,7);  
        %> workspace
        workspace = [-1.5 1.5 -1.5 1.5 -0.4 1.5];   
               
        %> If we have a tool model which will replace the final links model, combined ply file of the tool model and the final link models
        toolModelFilename = []; % Available are: 'DabPrintNozzleTool.ply';        
        toolParametersFilename = []; % Available are: 'DabPrintNozzleToolParameters.mat';        
    end
    
    methods%% Class for UR10 robot simulation
        function self = UR10(toolModelAndTCPFilenames)
            if 0 < nargin
                if length(toolModelAndTCPFilenames) ~= 2
                    error('Please pass a cell with two strings, toolModelFilename and toolCenterPointFilename');
                end
                self.toolModelFilename = toolModelAndTCPFilenames{1};
                self.toolParametersFilename = toolModelAndTCPFilenames{2};
            end
%                   Environment();
             self.GetUR10Robot();
             self.PlotAndColourRobot();%robot,workspace);
%             self.movement();
             input('Press enter to continue');
%              [brick,a,VertexCount,Pose]=self.brickmove();
%              self.Brick_h = brick;
%              self.b = a;
%              self.brickVertexCount= VertexCount;
%              self.BrickPose= Pose;
%              disp('brick set')
             self.RMRC(0,-0.2,0.1);
%                 self.RMRC(0.23,0,0.1);  

            drawnow()            

        end

        %% GetUR10Robot
        % Given a name (optional), create and return a UR10 robot model
        function GetUR10Robot(self)
            pause(0.001);
            name = ['UR_10_',datestr(now,'yyyymmddTHHMMSSFFF')];
            base = [0 0 0];

    L1 = Link('d',0.062668,'a',0,'alpha',pi/2,'qlim',deg2rad([-360,360]));
    L2 = Link('d',0,'a',0,'alpha',-pi/2,'qlim', deg2rad([-110,110])); 
    L3 = Link('d',0.124096,'a',0,'alpha',pi/2,'qlim', deg2rad([-360,360]));
    L4 = Link('d',0,'a',0.065868,'alpha',-pi/2,'qlim',deg2rad([-20,170])); 
    L5 = Link('d',0,'a',0.065868,'alpha',pi/2,'qlim',deg2rad([-110,110]));
    L6 = Link('d',0,'a',0,'alpha',-pi/2,'qlim',deg2rad([-200,5]));
    L7 = Link('d',0.115545,'a',0,'alpha',0,'qlim',deg2rad([-360,360]));

            self.model = SerialLink([L1 L2 L3 L4 L5 L6 L7],'name',name);
            q = zeros(1,7);
            self.model.base = transl(base);
        end

        %% PlotAndColourRobot
        % Given a robot index, add the glyphs (vertices and faces) and
        % colour them in if data is available 
        function PlotAndColourRobot(self)%robot,workspace)
            for linkIndex = 0:self.model.n
                [ faceData, vertexData, plyData{linkIndex + 1} ] = plyread(['UR10Link',num2str(linkIndex),'.ply'],'tri'); %#ok<AGROW>
                self.model.faces{linkIndex + 1} = faceData;
                self.model.points{linkIndex + 1} = vertexData;
            end

            if ~isempty(self.toolModelFilename)
                [ faceData, vertexData, plyData{self.model.n + 1} ] = plyread(self.toolModelFilename,'tri'); 
                self.model.faces{self.model.n + 1} = faceData;
                self.model.points{self.model.n + 1} = vertexData;
                toolParameters = load(self.toolParametersFilename);
                self.model.tool = toolParameters.tool;
                self.model.qlim = toolParameters.qlim;
                warning('Please check the joint limits. They may be unsafe')
            end
            % Display robot
            self.model.plotopt = {'nojoints', 'noname','noarrow','nojaxes', 'nowrist','nobase', 'noraise','notiles'};
            self.model.plot3d(zeros(1,self.model.n),'noarrow','workspace',self.workspace);
            if isempty(findobj(get(gca,'Children'),'Type','Light'))
                camlight
            end  
            self.model.delay = 0;

            % Try to correctly colour the arm (if colours are in ply file data)
            for linkIndex = 0:self.model.n
                handles = findobj('Tag', self.model.name);
                h = get(handles,'UserData');
                try 
                    h.link(linkIndex+1).Children.FaceVertexCData = [plyData{linkIndex+1}.vertex.red ...
                                                                  , plyData{linkIndex+1}.vertex.green ...
                                                                  , plyData{linkIndex+1}.vertex.blue]/255;
                    h.link(linkIndex+1).Children.FaceColor = 'interp';
                catch ME_1
                    disp(ME_1);
                    continue;
                end
            end
        end
        
        

             %% Movement        
        function movement(self)

  steps = 50;
   q1 = self.model.getpos();                                                        % Derive joint angles for required end-effector transformation
   T2 = transl(0,0,0);                                                         
   q2 = self.model.ikcon(T2,q1);                                                  
  

    Move = jtraj(q1,q2,steps);
           

     self.model.plot(Move,'trail','r-') 
%        self.model.animate(Move);
           drawnow();

        end
        

       
        
        %% Move RMRC Taken From Tutorial
        
        function RMRC(self, goalX, goalY, goalZ)
            
t = 5;             % Total time (s)
deltaT = 0.05;      % Control frequency
steps = t/deltaT;   % No. of steps for simulation
delta = 2*pi/steps; % Small angle change
epsilon = 0.1;      % Threshold value for manipulability/Damped Least Squares
W = diag([1 1 1 0.1 0.1 0.1]);    % Weighting matrix for the velocity vector

% 1.2) Allocate array data
m = zeros(steps,1);             % Array for Measure of Manipulability
qMatrix = zeros(steps,7);       % Array for joint anglesR
qdot = zeros(steps,7);          % Array for joint velocities
theta = zeros(3,steps);         % Array for roll-pitch-yaw angles
x = zeros(3,steps);             % Array for x-y-z trajectory
positionError = zeros(3,steps); % For plotting trajectory error
angleError = zeros(3,steps);    % For plotting trajectory error
currentAngles = self.model.getpos();
currentPos  = self.model.fkine(currentAngles);
% 1.3) Set up trajectory, initial pose


s = lspb(0,1,steps);                % Trapezoidal trajectory scalar
for i=1:steps
    x(1,i) = (1-s(i))*currentPos(1,4) + s(i)*goalX; % Points in x
    x(2,i) = (1-s(i))*currentPos(2,4) + s(i)*goalY; % Points in y
    x(3,i) = (1-s(i))*currentPos(3,4) + s(i)*goalZ; % Points in z
    theta(1,i) = 0;                 % Roll angle 
    theta(2,i) = 5*pi/9;            % Pitch angle
    theta(3,i) = 0;                 % Yaw angle
end


    

 T = [rpy2r(theta(1,1),theta(2,1),theta(3,1)) x(:,1);zeros(1,3) 1];          % Create transformation of first point and angle
  q0 = zeros(1,7);                                                            % Initial guess for joint angles
   qMatrix(1,:) = self.model.ikcon(T,q0);                                            % Solve joint angles to achieve first waypoint

% 1.4) Track the trajectory with RMRC
for i = 1:steps-1
    T = self.model.fkine(qMatrix(i,:));                                           % Get forward transformation at current joint state
    deltaX = x(:,i+1) - T(1:3,4);                                         	% Get position error from next waypoint
    Rd = rpy2r(theta(1,i+1),theta(2,i+1),theta(3,i+1));                     % Get next RPY angles, convert to rotation matrix
    Ra = T(1:3,1:3);                                                        % Current end-effector rotation matrix
    Rdot = (1/deltaT)*(Rd - Ra);                                                % Calculate rotation matrix error
    S = Rdot*Ra';                                                           % Skew symmetric!
    linear_velocity = (1/deltaT)*deltaX;
    angular_velocity = [S(3,2);S(1,3);S(2,1)];                              % Check the structure of Skew Symmetric matrix!!
    deltaTheta = tr2rpy(Rd*Ra');                                            % Convert rotation matrix to RPY angles
    xdot = W*[linear_velocity;angular_velocity];                          	% Calculate end-effector velocity to reach next waypoint.
    J = self.model.jacob0(qMatrix(i,:));                 % Get Jacobian at current joint state
    m(i) = sqrt(det(J*J'));
    if m(i) < epsilon  % If manipulability is less than given threshold
        lambda = (1 - m(i)/epsilon)*5E-2;
    else
        lambda = 0;
    end
    invJ = pinv(J'*J + lambda *eye(7))*J';                                   % DLS Inverse
    qdot(i,:) = (invJ*xdot)';                                                % Solve the RMRC equation (you may need to transpose the         vector)
    for j = 1:7                                                             % Loop through joints 1 to 6
        if qMatrix(i,j) + deltaT*qdot(i,j) < self.model.qlim(j,1)                     % If next joint angle is lower than joint limit...
            qdot(i,j) = 0; % Stop the motor
        elseif qMatrix(i,j) + deltaT*qdot(i,j) > self.model.qlim(j,2)                 % If next joint angle is greater than joint limit ...
            qdot(i,j) = 0; % Stop the motor
        end
    end
    qMatrix(i+1,:) = qMatrix(i,:) + deltaT*qdot(i,:);                         	% Update next joint state based on joint velocities
    positionError(:,i) = x(:,i+1) - T(1:3,4);                               % For plotting
    angleError(:,i) = deltaTheta;                                           % For plotting

    
            
end

% % 1.5) Plot the results
% % figure(1)
% plot3(x(1,:),x(2,:),x(3,:),'k.','LineWidth',1)
self.model.plot(qMatrix,'trail','r-')
% self.BrickPose = makehgtform('translate',currentPos(1:3,4)');
%             updatedPoints = [self.BrickPose * [self.b,ones(self.brickVertexCount,1)]']';
%             self.Brick_h.Vertices = updatedPoints(:,1:3);
%            drawnow();
    


% for i = 1:7
%     figure(2)
%     subplot(3,2,i)
%     plot(qMatrix(:,i),'k','LineWidth',1)
%     title(['Joint ', num2str(i)])
%     ylabel('Angle (rad)')
%     refline(0,self.model.qlim(i,1));
%     refline(0,self.model.qlim(i,2));
%     
%     figure(3)
%     subplot(3,2,i)
%     plot(qdot(:,i),'k','LineWidth',1)
%     title(['Joint ',num2str(i)]);
%     ylabel('Velocity (rad/s)')
%     refline(0,0)
% end
% 
% figure(4)
% subplot(2,1,1)
% plot(positionError'*1000,'LineWidth',1)
% refline(0,0)
% xlabel('Step')
% ylabel('Position Error (mm)')
% legend('X-Axis','Y-Axis','Z-Axis')
% 
% subplot(2,1,2)
% plot(angleError','LineWidth',1)
% refline(0,0)
% xlabel('Step')
% ylabel('Angle Error (rad)')
% legend('Roll','Pitch','Yaw')
% figure(5)
% plot(m,'k','LineWidth',1)
% refline(0,epsilon)
% title('Manipulability')
        end
        
         %% Move Brick
         function [Brick_h,b,brickVertexCount,BrickPose]=brickmove(self)
                   %Brick 
                  
        [f,b,data] = plyread('brick.ply','tri');
        vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
        Brick_h = trisurf(f,b(:,1) + 0,b(:,2) - 0.2, b(:,3) + 0.1 ...
            ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat')
        
        brickVertexCount = size(b,1);
        BrickPose = eye(6);
        hold on; 

        
         end
         
         function detectCollision(self,qMatrix)
           

                if wall_1==true || wall_2 == true
                self.CollisionFlag =1;
                disp('avoiding collition')

                end
         end
        
             %% IsIntersectionPointInsideTriangle
% Given a point which is known to be on the same plane as the triangle
% determine if the point is 
% inside (result == 1) or 
% outside a triangle (result ==0 )
function result = IsIntersectionPointInsideTriangle(self,intersectP,triangleVerts)

u = triangleVerts(2,:) - triangleVerts(1,:);
v = triangleVerts(3,:) - triangleVerts(1,:);

uu = dot(u,u);
uv = dot(u,v);
vv = dot(v,v);

w = intersectP - triangleVerts(1,:);
wu = dot(w,u);
wv = dot(w,v);

D = uv * uv - uu * vv;

% Get and test parametric coords (s and t)
s = (uv * wv - vv * wu) / D;
if (s < 0.0 || s > 1.0)        % intersectP is outside Triangle
    result = 0;
    return;
end

t = (uv * wu - uu * wv) / D;
if (t < 0.0 || (s + t) > 1.0)  % intersectP is outside Triangle
    result = 0;
    return;
end

result = 1;                      % intersectP is in Triangle
end

%% IsCollision
% This is based upon the output of questions 2.5 and 2.6
% Given a robot model (robot), and trajectory (i.e. joint state vector) (qMatrix)
% and triangle obstacles in the environment (faces,vertex,faceNormals)
function result = IsCollision(self,qMatrix,faces,vertex,faceNormals,returnOnceFound)
if nargin < 6
    returnOnceFound = true;
end
result = false;

for qIndex = 1:size(qMatrix,1)
    % Get the transform of every joint (i.e. start and end of every link)
    tr = GetLinkPoses(qMatrix(qIndex,:), self);

    % Go through each link and also each triangle face
    for i = 1 : size(tr,3)-1    
        for faceIndex = 1:size(faces,1)
            vertOnPlane = vertex(faces(faceIndex,1)',:);
            [intersectP,check] = LinePlaneIntersection(faceNormals(faceIndex,:),vertOnPlane,tr(1:3,4,i)',tr(1:3,4,i+1)'); 
            if check == 1 && IsIntersectionPointInsideTriangle(intersectP,vertex(faces(faceIndex,:)',:))
                plot3(intersectP(1),intersectP(2),intersectP(3),'g*');
                display('Intersection');
                result = true;
                if returnOnceFound
                    return
                end
            end
        end    
    end
end
end

%% GetLinkPoses
% q - robot joint angles
% robot -  seriallink robot model
% transforms - list of transforms
function [ transforms ] = GetLinkPoses( q, self)

links = self.links;
transforms = zeros(4, 4, length(links) + 1);
transforms(:,:,1) = self.base;

for i = 1:length(links)
    L = links(1,i);
    
    current_transform = transforms(:,:, i);
    
    current_transform = current_transform * trotz(q(1,i) + L.offset) * ...
    transl(0,0, L.d) * transl(L.a,0,0) * trotx(L.alpha);
    transforms(:,:,i + 1) = current_transform;
end
end

    end
end