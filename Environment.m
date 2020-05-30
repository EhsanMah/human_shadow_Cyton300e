%% Environment        

%% TABLE
[f,v,data] = plyread('table1.ply','tri');
vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;

        tableMesh_h = trisurf(f,v(:,1) + 0,v(:,2) + 0, v(:,3) - 0.07 ...
        ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');

hold on; 

%% Fences

        %Fence 1
        [f,a,data] = plyread('fence.ply','tri');
        vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
        fence_h = trisurf(f,a(:,1) + 0,a(:,2) -1, a(:,3) -0.2 ...
            ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');
        hold on;
        
        %Fence 2
        [f,a,data] = plyread('fence.ply','tri');
        vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
        fence_h = trisurf(f,a(:,1) + 0,a(:,2) + 1, a(:,3) -0.2 ...
            ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');
        hold on;
        
        %Fence 3
        [f,a,data] = plyread('fence1.ply','tri');
        vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
        fence_h = trisurf(f,a(:,1) - 1.2,a(:,2) + 0, a(:,3) - 0.2 ...
            ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');
        hold on;
        
        %Fence 4
        [f,a,data] = plyread('fence1.ply','tri');
        vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
        fence_h = trisurf(f,a(:,1) + 1.2,a(:,2) + 0, a(:,3) -0.2 ...
            ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');
        hold on;
        
%% Brick
        %Brick
        [f,a,data] = plyread('Brick.ply','tri');
        vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
        fence_h = trisurf(f,a(:,1) + 0.2,a(:,2) + 0, a(:,3) + 0 ...
            ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');
        hold on;