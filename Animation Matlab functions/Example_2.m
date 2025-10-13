% Example_2: Multi-link manipulator rendering example
clear all; close all; clc

%----set rendering window view parameters
f_handle = 9;
axis_limits = [-75 75 -75 75 -50 50];
render_view = [-1 1 1]; view_up = [0 0 1];
SetRenderingViewParameters(axis_limits,render_view,...
                           view_up,f_handle); 

%----initialize rendering

%  base (link 0) rendering initialization
%    (doesn't move - created for aesthetic reasons)
r0 = 10; L0 = 20;  sides0 = 10; axis0 = 3; norm_L0 = -1.0;
    linkColor0 = [0 0 0.75]; plotFrame0 = 5 ;
d0 =  CreateLinkRendering(L0,r0,sides0,axis0,norm_L0,linkColor0,...
                          plotFrame0,f_handle);

% link 1 rendering initialization
r1 = 5.0; L1 = 30;  sides1 = 4; axis1 = 1; norm_L1 = -1.0;
    linkColor1 = [0 0.75 0]; plotFrame1 = 5;
d1 =  CreateLinkRendering(L1,r1,sides1,axis1,norm_L1,linkColor1,...
                          plotFrame1,f_handle);

% link 2 rendering initialization
r2 = 4.0; L2 =30;  sides2 = 4; axis2 = 1; norm_L2 = -1.0;
    linkColor2 = [0.75 0 0]; plotFrame2 = 5;
d2 =  CreateLinkRendering(L2,r2,sides2,axis2,norm_L2,linkColor2,...
                          plotFrame2,f_handle);

% link 3 rendering initialization
r3 = 2.0; L3 = 30;  sides3 = 10; axis3 = 3; norm_L3 = 0.0;
    linkColor3 = [0.75 0 0.75]; plotFrame3 = 5;
d3 =  CreateLinkRendering(L3,r3,sides3,axis3,norm_L3,linkColor3,...
                          plotFrame3,f_handle);

% end-effector frame rendering initialization
r4 = 1.0; L4 = 1.0;  sides4 = 4; axis4 = 3; norm_L4 = -1.0;
    linkColor4 = [0 0 0]; plotFrame4 = 5;
d4 =  CreateLinkRendering(L4,r4,sides4,axis4,norm_L4,linkColor4,...
                          plotFrame4,f_handle);

%----calculate robot manipulator link displacements
%    as a function of time
tEnd = 10; SamplesPerSec = 20;
t = linspace(0,tEnd,tEnd*SamplesPerSec)';
theta1 = (pi)*sin(t); % link 1 motion
theta2 = (pi/2)*sin(2*t);
x3 = (L3/3)*sin(3*t);

for i = 1:size(t,1)
    %transformation from {1} to {0}
    s = sin(theta1(i)); c = cos(theta1(i));
    T10(:,:,i) = [c -s  0  0
                  s  c  0  0
                  0  0  1  L0+r1 
                  0  0  0  1];
    %transformation from {2} to {1}
    s = sin(theta2(i)); c = cos(theta2(i));
    T21(:,:,i) = [c -s  0  L1
                  s  c  0  0
                  0  0  1  0 
                  0  0  0  1];
    %transformation from {3} to {2}
    T32(:,:,i) = [1   0   0  L2
                  0  -1   0  0
                  0   0  -1  -x3(i) 
                  0   0   0  1];
    %transformation from {e} to {3}
    Te3(:,:,i) = [1  0  0  0
                  0  1  0  0
                  0  0  1  L3/2 
                  0  0  0  1];
    T20(:,:,i) = T10(:,:,i)*T21(:,:,i);
    T30(:,:,i) = T20(:,:,i)*T32(:,:,i);
    Te0(:,:,i) = T30(:,:,i)*Te3(:,:,i);
end

%----loop through the calculated robot motions and update rendering
for i = 1:size(t,1)
    % update the link rendering
    UpdateLink(d1,T10(:,:,i));
    UpdateLink(d2,T20(:,:,i));
    UpdateLink(d3,T30(:,:,i));
    UpdateLink(d4,Te0(:,:,i));
    if i == 1
        pause; % to allow resizing of graphics window
    end
    pause(0.05);
end


