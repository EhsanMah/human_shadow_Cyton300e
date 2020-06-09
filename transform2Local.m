function [localX,localY,localZ] = transform2Local(x,y,z)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

newX=z-0.2;
newY= x;
newZ= y;

if(newZ == 0)
   newZ = 0.2; 
end
if newX>0.35
    newX= 0.35;
    
end
    

 if newX<-0.05
    newX= -0.05;
    
end
    

if newY>0.25
    newY= 0.25;
    
end
    

if newY<-0.25
    newY=-0.25;
    
end
    

if newZ>0.35
    newZ= 0.35;
    
end
    

if newZ<-0.05
    newZ= -0.05;
    
end
    

 localX = newX;
 localY = newY;
 localZ= newZ;

end

