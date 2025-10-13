function UpdateLink(dCylinder,T)

vertices = dCylinder.original_vertices; 
vertices_plus_row = [vertices';ones(1,size(vertices,1))];
vertices_plus_row = T*vertices_plus_row;
vertices = vertices_plus_row(1:3,:)';
dCylinder.vertices = vertices;
set(dCylinder.patch,'vertices',vertices);    

if dCylinder.plotFrames ~= 0
    xAxis = T*[0.5*dCylinder.plotFrames 0 0 1]';
    yAxis = T*[0 0.5*dCylinder.plotFrames 0 1]';
    zAxis = T*[0 0 dCylinder.plotFrames 1]';
    oAxis = T*[0 0 0 1]';
    XunitAxis = [oAxis xAxis];
    YunitAxis = [oAxis yAxis];
    ZunitAxis = [oAxis zAxis];
    set(dCylinder.xAxis,'XData',XunitAxis(1,:),'YData',XunitAxis(2,:),'ZData',XunitAxis(3,:));
    set(dCylinder.yAxis,'XData',YunitAxis(1,:),'YData',YunitAxis(2,:),'ZData',YunitAxis(3,:));
    set(dCylinder.zAxis,'XData',ZunitAxis(1,:),'YData',ZunitAxis(2,:),'ZData',ZunitAxis(3,:));
end
    
end