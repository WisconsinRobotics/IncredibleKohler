
clear all; close all; clc
%------------------------------------------------
% Animation example: Example_3.m
%   Animate a three-link robot as a function of time
%   and plot the location of the operational point
%------------------------------------------------

%----link parameters
L0 = 0.5; L1 = 20; L2 = 20; L3 = 20; L4 = 0.5;
% operational point location expressed in frame {4}
pE_4 = [1; 1; -1]; 

%----rendering parameters
r0 = 40;  sides0 = 4; axis0 = 3; norm_L0 = 1.0;
    linkColor0 = [0.5 0.5 0.5]; plotFrame0 = 5 ;
r1 = 3.0;  sides1 = 4; axis1 = 3; norm_L1 = -1.0;
    linkColor1 = [1 0 0]; plotFrame1 = 5;
r2 = 2.5;  sides2 = 4; axis2 = 3; norm_L2 = -1.0;
    linkColor2 = [0 1 0]; plotFrame2 = 5;
r3 = 2.0;  sides3 = 4; axis3 = 3; norm_L3 = -1.0;
    linkColor3 = [0 0 1]; plotFrame3 = 5;
r4 = 0.5; sides4 = 4; axis4 = 3; norm_L4 = -1.0;
    linkColor4 = [1 1 1]; plotFrame4 = 5;
   
% initialize rendering view parameters    
f_handle = 9;
axis_limits = 1.5*[-r0 r0 -r0 r0 0 r0];
render_view_point = [1 1 1];
render_view_up = [0 0 1];
SetRenderingViewParameters(axis_limits,render_view_point,...
                                    render_view_up, f_handle)

%----initialize 3D rendering of robot links:
% base (doesn't move - created for aesthetic reasons)
d0 =  CreateLinkRendering(L0,r0,sides0,axis0,norm_L0,linkColor0,plotFrame0,f_handle);
% link 1
d1 =  CreateLinkRendering(L1,r1,sides1,axis1,norm_L1,linkColor1,plotFrame1,f_handle);
% link 2
d2 =  CreateLinkRendering(L2,r2,sides2,axis2,norm_L2,linkColor2,plotFrame2,f_handle);
% link 3
d3 =  CreateLinkRendering(L3,r3,sides3,axis3,norm_L3,linkColor3,plotFrame3,f_handle);
% link 4 (for tool frame)
d4 =  CreateLinkRendering(L4,r4,sides4,axis4,norm_L4,linkColor4,plotFrame4,f_handle);

%----construct the time vector
tEnd = 5; SamplesPerSec = 20;
t = linspace(0,tEnd,tEnd*SamplesPerSec)';

%calcualte the robot kinematics
for i = 1:size(t,1)

    % joint displacement at time t(i)
    theta1 = (pi)*sin(t(i)); % link 1 motion
    theta2 = (pi/2)*sin(2*t(i)); % link 2 motion
    theta3 = (pi/2)*sin(3*t(i)); % link 3 motion
      
    %transformation from {1} to {0}
    s = sin(theta1); c = cos(theta1);
    T10 = [c -s  0  0
           s  c  0  0
           0  0  1  0 
           0  0  0  1];
    
    %transformation from {2} to {1}
    s = sin(theta2); c = cos(theta2);
    T21 = [c  0  s  0
           0  1  0  0
          -s  0  c  L1 
           0  0  0  1];
    
    %transformation from {3} to {2}
    s = sin(theta3); c = cos(theta3);
    T32 = [c  0  s  0
           0  1  0  0
          -s  0  c  L2 
           0  0  0  1];
    
    %transformation from {4} to {3}
    T43 = [1  0  0  0
           0  1  0  0
           0  0  1  L3 
           0  0  0  1];

    %transformations to the base frame {0}
    T20 = T10*T21;
    T30 = T20*T32;
    T40 = T30*T43;

    %calcualte the location of the operation point in frame {0}
    PE_4 = [pE_4; 1];
    PE_0 = T40*PE_4;
    pE_0 = PE_0(1:3,1);

    %save the x, y, z value of the operational point for plotting
    xE_0(i) = pE_0(1);
    yE_0(i) = pE_0(2);
    zE_0(i) = pE_0(3);

    %update the link rednering            
    figure(f_handle); % set the current figure to the rendering window
    UpdateLink(d1,T10);
    UpdateLink(d2,T20);
    UpdateLink(d3,T30);
    UpdateLink(d4,T40);
    
    if i == 1
        pause; % to allow resizing of graphics window
    end
    %pause for a moment between time points to slow down the rendering    
    pause(.025)
end

%---plot location of the operational point as
%   a function of time
figure

subplot(3,1,1)
plot(t,xE_0)
xlabel('time'); ylabel('xE'); grid on

subplot(3,1,2)
plot(t,yE_0)
xlabel('time'); ylabel('yE'); grid on

subplot(3,1,3)
plot(t,zE_0)
xlabel('time'); ylabel('zE'); grid on
