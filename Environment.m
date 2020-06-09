%% Environment 
% This script sets up all the additional component and safety features in the environment.
% All the .Ply / CAD files were taken from opensource resources. Reference included with the codes 

%% Floor        [Taken From: https://au.mathworks.com/matlabcentral/answers/300826-how-do-i-insert-an-image-in-my-2-d-and-3-d-plots-in-matlab-8-2-r2013b ]
% Plots floor texture in the environment
hold on;      % Add to the plot
xlabel('x');
ylabel('y');
zlabel('z');
img = imread('Back1.jpg');     % Load a sample image
xImage = [-1.5 1; -1.5 1];   % The x data for the image corners
yImage = [-1.3 -1.3; -1.3 -1.3];             % The y data for the image corners
zImage = [1.5 1.5; -0.4 -0.4];   % The z data for the image corners
surf(xImage,yImage,zImage,...    % Plot the surface
     'CData',img,...
     'FaceColor','texturemap');
 

hold on;      % Add to the plot
xlabel('x');
ylabel('y');
zlabel('z');
img = imread('Back2.jpg');     % Load a sample image
yImage = [-1.3 1.5; -1.3 1.5];   % The x data for the image corners
xImage = [-1.5 -1.5; -1.5 -1.5];             % The y data for the image corners
zImage = [1.5 1.5; -0.4 -0.4];   % The z data for the image corners
surf(xImage,yImage,zImage,...    % Plot the surface
     'CData',img,...
     'FaceColor','texturemap'); 


hold on;      % Add to the plot
xlabel('x');
ylabel('y');
zlabel('z');
img = imread('sand.jpg');     % Load a sample image
yImage = [-1.3 1.5; -1.3 1.5];   % The x data for the image corners
zImage = [-0.39 -0.39; -0.39 -0.39];             % The y data for the image corners
xImage = [1.0 1.0; -1.5 -1.5];   % The z data for the image corners
surf(xImage,yImage,zImage,...    % Plot the surface
     'CData',img,...
     'FaceColor','texturemap'); 
 
 hold on;      % Add to the plot
xlabel('x');
ylabel('y');
zlabel('z');
img = imread('construction.png');     % Load a sample image
xImage = [-0.6 0; -0.6 0];   % The x data for the image corners
yImage = [1.01 1.01; 1.01 1.01];             % The y data for the image corners
zImage = [0.2 0.2; -0.2 -0.2];   % The z data for the image corners
surf(xImage,yImage,zImage,...    % Plot the surface
     'CData',img,...
     'FaceColor','texturemap');
 
hold on;      % Add to the plot
xlabel('x');
ylabel('y');
zlabel('z');
img = imread('Robot.png');     % Load a sample image
yImage = [-0.3 0.3; -0.3 0.3];   % The x data for the image corners
xImage = [0.73 0.73; 0.73 0.73];             % The y data for the image corners
zImage = [0.2 0.2; -0.2 -0.2];   % The z data for the image corners
surf(xImage,yImage,zImage,...    % Plot the surface
     'CData',img,...
     'FaceColor','texturemap'); 
%% Platform        [Taken From:https://grabcad.com/library?page=6&sort=most_downloaded&tags=trolley]
% Plots a platform in the simulation environment to place the robot
[f,v,data] = plyread('Trolley.ply','tri');
vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;

        tableMesh_h = trisurf(f,v(:,1) + 0,v(:,2) - 0.15, v(:,3) - 0.08 ...
        ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');

hold on; 

[f,v,data] = plyread('stand.ply','tri');
vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;

        tableMesh_h = trisurf(f,v(:,1) + 0.83,v(:,2) - 0.7, v(:,3) - 0.08 ...
        ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');

hold on; 

%% Fences
% Plots Fences around the workspace to stop anyone to enter while the robot
% is in operation.
        %Fence 1
        [f,a,data] = plyread('fence.ply','tri');
        vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
        fence_h = trisurf(f,a(:,1) - 0.1,a(:,2) -1, a(:,3) + 0 ...
            ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');
        hold on;
        
        %Fence 2
        [f,a,data] = plyread('fence.ply','tri');
        vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
        fence_h = trisurf(f,a(:,1) - 0.1,a(:,2) + 1, a(:,3) -0 ...
            ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');
        hold on;
        
        %Fence 3
        [f,a,data] = plyread('fence1.ply','tri');
        vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
        fence_h = trisurf(f,a(:,1) + 0.72,a(:,2) + 0, a(:,3) - 0 ...
            ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');
        hold on;
        
        %Fence 4
        [f,a,data] = plyread('fence1.ply','tri');
        vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
        fence_h = trisurf(f,a(:,1) - 1,a(:,2) + 0, a(:,3) -0 ...
            ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');
        hold on;
        
%% Bricks       [Taken From: http://done3d.com/concrete-column/]
% Plots a half constructed brick wall and a stack of loose brick.

        %Brick Wall
        [f,a,data] = plyread('brickwall.ply','tri');
        vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
        fence_h = trisurf(f,a(:,1) + 0.27,a(:,2) + 0, a(:,3) -0.4 ...
            ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');
        hold on;
        
        %Brick Stack
        [f,a,data] = plyread('stacked.ply','tri');
        vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
        fence_h = trisurf(f,a(:,1) + 0,a(:,2) - 0.2, a(:,3) -0.08 ...
            ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');
        hold on;
 %% Emergency Stop Button       [Taken From: https://sketchfab.com/3d-models/emergency-stop-button-012e4809a41445ca9de17286f677fabb#download ]
 % Plots an Emergency Stop button outside of the workspace to ensure safety
 %  This can be accessed if any unexpected event occurs and kill the operation.  
 [f,v,data] = plyread('E-button.ply','tri');
vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;

        Ebutton_h = trisurf(f,v(:,1) + 0.83,v(:,2) - 0.7, v(:,3) - 0.08 ...
        ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');

hold on; 
