 clc
 clf
 clear all
%% DH parameters of Cyton
    L1 = Link('d',0.157751,'a',0,'alpha',pi/2,'qlim',deg2rad([-360,360]));
    L2 = Link('d',0,'a',0,'alpha',-pi/2,'qlim', deg2rad([-360,360])); 
    L3 = Link('d',0.124096,'a',0,'alpha',pi/2,'qlim', deg2rad([-360,360]));
    L4 = Link('d',0,'a',0.065868,'alpha',-pi/2,'qlim',deg2rad([-360,360])); 
    L5 = Link('d',0,'a',0.065868,'alpha',pi/2,'qlim',deg2rad([-360,360]));
    L6 = Link('d',0,'a',0,'alpha',-pi/2,'qlim',deg2rad([-360,360]));
    L7 = Link('d',0.115545,'a',0,'alpha',0,'qlim',deg2rad([-360,360]));
base = [0 0 -0.3];
cyton= SerialLink([L1 L2 L3 L4 L5 L6 L7],'name',name,'base',base);
 