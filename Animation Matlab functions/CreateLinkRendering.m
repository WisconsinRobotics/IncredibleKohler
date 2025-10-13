function [d] = CreateLinkRendering(length, radius, number_of_sides, ...
                aligned_axis, normalized_location, linkColor, ...
                plotFrame,figure_handle);

            
% location of axis along center line
L = normalized_location*(length/2);
P = [0; 0; L];

% rotaion matrix from aligned axis to z-axis (nominally aligned to CL)
if aligned_axis == 3
    R = [1 0 0
         0 1 0
         0 0 1];
elseif aligned_axis == 2
    R = [1 0  0
         0 0 -1
         0 1  0];
elseif aligned_axis == 1
    R = [0 0 -1
         0 1  0
         1 0  0];
elseif aligned_axis == -3
    R = [1  0  0
         0 -1  0
         0  0 -1];
elseif aligned_axis == -2
    R = [1  0  0
         0  0  1
         0 -1  0];    
elseif aligned_axis == -1
    R = [ 0 0 1
          0 1 0
         -1 0 0];
else
    R = [1 0 0
         0 1 0
         0 0 1];
end

% form T matrix
Toffset = [  R   P
           0 0 0 1];
       
d =  CreateLink(length,radius,number_of_sides,Toffset,linkColor,plotFrame,figure_handle);