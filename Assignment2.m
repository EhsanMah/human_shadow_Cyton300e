clear all
clc
clf

%% movement
Cyton = UR10
load('cyton_q.mat');
Cyton.movement(cyton_q);