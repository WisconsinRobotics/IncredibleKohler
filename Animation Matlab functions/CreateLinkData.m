function [dCylinder] = CreateLinkData(L,r,sides,Toffset,linkColor)

%create vertices
vertices = zeros(sides+2,3);
vertices_bottom(1,:) = [0 0 0];
vertices_top(1,:) = [L 0 0];
for i = 1:sides
    theta = 2*pi*(i-1)/sides;
    vertices_bottom(i+1,:) = [0  r*cos(theta)  r*sin(theta)];
    vertices_top(i+1,:) = [L  r*cos(theta)  r*sin(theta)];
end
vertices = [vertices_bottom; vertices_top];

%rotate the vertices to align with the z-axis
for i = 1:size(vertices,1)
    xTemp = -vertices(i,3);
    zTemp =  vertices(i,1);
    yTemp =  vertices(i,2);
    vertices(i,1) = xTemp;
    vertices(i,2) = yTemp;
    vertices(i,3) = zTemp;
end

%offset along z-axis (origin at center of link)
z_offset = -L/2;
for i = 1:size(vertices,1)
    vertices(i,3) = vertices(i,3) + z_offset;
end

%transform vertices to place link frame
vertices_plus_row = [vertices';ones(1,size(vertices,1))];

%rotate by 45 degrees so that a square link is aligned by its edges
sTheta = sin(pi/4); cTheta = cos(pi/4); 
Ttwist = [cTheta  -sTheta   0  0
           sTheta   cTheta  0  0 
             0        0     1  0
             0        0     0  1];
vertices_plus_row = Ttwist*vertices_plus_row;

%transform frame from center to specified location
vertices_plus_row = inv(Toffset)*vertices_plus_row;

vertices = vertices_plus_row(1:3,:)';

%create the end-cap faces
end_faces = zeros(2*sides:3);
for i = 1:sides-1
    end_faces(i,:) = [1 i+1 i+2];
    end_faces(sides+i,:) = [2+sides 2+sides+i 3+sides+i];
end
end_faces(sides,:) = [1 sides+1 2];
end_faces(2*sides,:) = [2+sides 2*sides+2 3+sides];

%create the side faces
side_faces = zeros(2*sides:3);
for i = 1:1:sides-1
    side_faces(i,:) = [i+1 i+2 i+2+sides];
    side_faces(sides+i,:) = [i+2+sides i+3+sides i+2];
end
side_faces(sides,:) = [sides+1 2 2*sides+2];
side_faces(2*sides,:) = [2*sides+2 sides+3 2];
    
faces = [end_faces; side_faces];


dCylinder.vertices = vertices;
dCylinder.original_vertices = vertices;
dCylinder.faces = faces;
dCylinder.color = linkColor;

end