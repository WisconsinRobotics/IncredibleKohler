% Example_1: Single link rendering example
clear all; close all; clc

%----set rendering window view parameters
figure_handle = 9;
axis_limits = [-10 10 -10 10 -10 10];
render_view = [1 1 1]; view_up = [0 0 1];
SetRenderingViewParameters(axis_limits,render_view,...
                           view_up,figure_handle);   

%----initialize link rendering
length = 10;
radius = 2;
number_of_sides = 10;
aligned_axis = 1; 
normalized_location = -1.0;
linkColor = [0 0 1]; 
plotFrame = 5;

%----create link rendering object
d =  CreateLinkRendering(length, radius, number_of_sides, ...
                         aligned_axis, normalized_location, ...
                         linkColor, plotFrame, figure_handle);    

%----z axis displacment 
pause;
T10 = [1 0 0 0
       0 1 0 0
       0 0 1 5
       0 0 0 1];
UpdateLink(d,T10);
pause;
T10 = [1 0 0 5
       0 1 0 0
       0 0 1 5
       0 0 0 1];
UpdateLink(d,T10);