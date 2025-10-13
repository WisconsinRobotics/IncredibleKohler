function dCylinder =  CreateLink(L,r,sides,Toffset,linkColor,...
                                 plotFrames,figure_handle);

% default parameters
if L == 0;
    L = 1.0;
end
if r == 0;
    r = L/5;
end
if sides < 4
    sides = 4;
end
if Toffset == 0;
    Toffset = eye(4);
end
if linkColor == 0;
    linkColor = [0.5 0.5 0.5];
end

% create cylinder data (vertices and faces)
dCylinder = CreateLinkData(L,r,sides,Toffset,linkColor);

% set figure
figure(figure_handle);
dCylinder.figure_handle = figure_handle;

% create cylinder patch object
dCylinder =  CreateLinkPatchObject(dCylinder);
% create coordinate frame axes
if plotFrames ~= 0
    dCylinder.T = [1 0 0 0
                   0 1 0 0
                   0 0 1 0
                   0 0 0 1];
    dCylinder.xAxis = line([0 plotFrames],[0 0],[0 0]);           
    dCylinder.yAxis = line([0 0],[0 plotFrames],[0 0]);           
    dCylinder.zAxis = line([0 0],[0 0],[0 plotFrames]);
    set(dCylinder.xAxis,'LineWidth',2);
    set(dCylinder.yAxis,'LineWidth',2);
    set(dCylinder.zAxis,'LineWidth',2);
    set(dCylinder.xAxis,'Color',[0 0 0]);
    set(dCylinder.yAxis,'Color',[0 0 0]);  
    set(dCylinder.zAxis,'Color',[1 0 0]);
    dCylinder.plotFrames = plotFrames;
else
    dCylinder.plotFrames = 0;
end

% set link transparency
alpha(0.5);

end