classdef UR10 < handle
    properties
        %> Robot model
        model;
             q = zeros(1,7);
        %> workspace
        workspace = [-1 1 -1 1 -0.3 1];   
               
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
            
            self.GetUR10Robot();
            self.PlotAndColourRobot();
%             self.movement();

            drawnow            
            % camzoom(2)
            % campos([6.9744    3.5061    1.8165]);

%             camzoom(4)
%             view([122,14]);
%             camzoom(8)
%             teach(self.model);
        end

        %% GetUR10Robot
        % Given a name (optional), create and return a UR10 robot model
        function GetUR10Robot(self)
            pause(0.001);
            name = ['UR_10_',datestr(now,'yyyymmddTHHMMSSFFF')];
            base = [0 0 -0.3];
    L1 = Link('d',0.157751,'a',0,'alpha',pi/2,'qlim',deg2rad([-360,360]));
    L2 = Link('d',0,'a',0,'alpha',-pi/2,'qlim', deg2rad([-360,360])); 
    L3 = Link('d',0.124096,'a',0,'alpha',pi/2,'qlim', deg2rad([-360,360]));
    L4 = Link('d',0,'a',0.065868,'alpha',-pi/2,'qlim',deg2rad([-360,360])); 
    L5 = Link('d',0,'a',0.065868,'alpha',pi/2,'qlim',deg2rad([-360,360]));
    L6 = Link('d',0,'a',0,'alpha',-pi/2,'qlim',deg2rad([-360,360]));
    L7 = Link('d',0.115545,'a',0,'alpha',0,'qlim',deg2rad([-360,360]));

            self.model = SerialLink([L1 L2 L3 L4 L5 L6 L7],'name',name);
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
            self.model.plot3d(zeros(1,self.model.n),'noarrow' ,'workspace',self.workspace  );
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
        function movement(self, qMatrix)
            for i = 1:size(qMatrix)
               self.model.animate(qMatrix(i,:))
               pause(0.01); 
            end

%   steps = 50;
%    q1 = self.model.getpos();                                                        % Derive joint angles for required end-effector transformation
%    T2 = transl(0.3,0,0);                                                         
%    q2 = self.model.ikcon(T2,q1);                                                  
%   
% 
%     Move = jtraj(q1,q2,steps);
%            
% 
% %      self.model.plot(Move,'trail','r-') 
% %        self.model.animate(Move);
%            drawnow();

        end
    end
end