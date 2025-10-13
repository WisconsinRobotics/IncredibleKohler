
clear all; close all; clc
%------------------------------------------------
% Animation example: Example_3.m
%   Animate a three-link robot as a function of time
%   and plot the location of the operational point
%------------------------------------------------

%----link parameters
Lbase = 6; L0 = 0.01; L1 = 6; L2 = 6; L3 = .01; L4 = 4;
% operational point location expressed in frame {4}
pE_3 = [0; 1; 0]; 

%----rendering parameters
rbase = .5;  sidesbase = 4; axisbase = 3; norm_Lbase = 1.0;
    linkColorbase = [.5 0.5 0.5]; plotFramebase = 2 ;
r0 = 2;  sides0 = 4; axis0 = 2; norm_L0 = -1.0;
    linkColor0 = [.5 0.5 0.5]; plotFrame0 = 2 ;
r1 = 2;  sides1 = 4; axis1 = 1; norm_L1 = -1.0;
    linkColor1 = [1 0 0]; plotFrame1 = 5;
r2 = 1.5;  sides2 = 4; axis2 = 1; norm_L2 = -1.0;
    linkColor2 = [0 1 0]; plotFrame2 = 5;
r3 = 1.0;  sides3 = 8; axis3 = 2; norm_L3 = -1.0;
    linkColor3 = [0 0 1]; plotFrame3 = 5;
r4 = 1.0;  sides4 = 8; axis4 = 2; norm_L4 = -1.0;
    linkColor4 = [0 0 1]; plotFrame4 = 5;

   
%----set rendering window view parameters
% figure handle
f_handle = 1;
% axis limits
axis_limits = [-15 15 0 20 -15 15];
% camera position
render_view = [1 1 1];
% vertical orientation
view_up = [0 1 0];
% initialize rendering view
SetRenderingViewParameters(axis_limits,render_view,view_up,f_handle);

%----initialize 3D rendering of robot links:
% base (doesn't move - created for aesthetic reasons)
dbase =  CreateLinkRendering(Lbase,rbase,sidesbase,axisbase,norm_Lbase,linkColorbase,plotFramebase,f_handle);

d0 =  CreateLinkRendering(L0,r0,sides0,axis0,norm_L0,linkColor1,plotFrame1,f_handle);
% link 1
d1 =  CreateLinkRendering(L1,r1,sides1,axis1,norm_L1,linkColor1,plotFrame1,f_handle);
% link 2
d2 =  CreateLinkRendering(L2,r2,sides2,axis2,norm_L2,linkColor2,plotFrame2,f_handle);
% link 3
d3 =  CreateLinkRendering(L3,r3,sides3,axis3,norm_L3,linkColor3,plotFrame3,f_handle);
d4 =  CreateLinkRendering(L4,r4,sides4,axis4,norm_L4,linkColor4,plotFrame4,f_handle);

%----construct the time vector
tEnd = pi; SamplesPerSec = 20;
t = linspace(0,tEnd,tEnd*SamplesPerSec)';
qbase = 0;
q1 = 0;
q2 = 0;
q3 = 0;
q4 = 0;

%calcualte the robot kinematics
while 1
    
    % joint displacement at time t(i)
    %theta1 = -2*(pi)*sin(t(i)); % link 1 motion
    %theta2 = (pi/2)*(1-sin(t(i))); % link 2 motion
    %theta3 = (pi/3)*sin(t(i)); % link 3 motion
    q_rail = qbase;
    theta1 = q1;
    theta2 = q2;
    theta3 = q3;
    theta4 = q4;
    
    T0_base = [1  0  0  0
               0  1  0  0
               0  0  1  -q_rail 
               0  0  0  1];
        
    %transformation from {1} to {0}
    s = sin(theta1); c = cos(theta1);
    T10 = [ s  c  0  -L1*s
           -c  s  0  L1*c
            0  0  1  0 
            0  0  0  1];
    
    %transformation from {2} to {1}
    s = sin(theta2); c = cos(theta2);
    T21 = [s  c  0 -L2*s
          -c  s  0  L2*c
           0  0  1  0 
           0  0  0  1];
    

   %transformation from {4} to {3}
    s = sin(theta3); c = cos(theta3);
    T32 = [c  -s 0  0
           s  c  0  0
           0  0  1  0 
           0  0  0  1];
    %transformation from {3} to {2}
    s = sin(theta4); c = cos(theta4);
    T43 = [c  0 -s  0
           0  1  0  0
           s  0  c  0 
           0  0  0  1];

    %transformations to the base frame {0}
    T1B = T0_base*T10;
    T2B = T1B*T21;
    T3B = T2B*T32;
    T4B = T3B*T43;

    %calcualte the location of the operation point in frame {0}
    PE_3 = [pE_3; 1];
    PE_B = T4B*PE_3;
    pE_B = PE_B(1:3,1);

    %save the x, y, z value of the operational point for plotting
    %xE_0(i) = pE_B(1);
    %yE_0(i) = pE_B(2);
    %zE_0(i) = pE_B(3);

    %update the link rednering            
    figure(f_handle); % set the current figure to the rendering window
    UpdateLink(d0,T0_base);
    UpdateLink(d1,T1B);
    UpdateLink(d2,T2B);
    UpdateLink(d3,T3B);
    UpdateLink(d4,T4B);

    %pause for a moment between time points to slow down the rendering    
    w = waitforbuttonpress;
    % Check if a key was pressed
    if w == 1 
        % Get the character of the pressed key
        move = get(gcf, 'CurrentCharacter'); 
        disp(['You pressed: ', move]);
    else
        move = "0";
        disp('No key was pressed.');
    end
    if (move == "q")
        qbase = qbase + .1;
    elseif (move == "a")
        qbase = qbase - .1;
    elseif (move == "w")
        q1 = q1 + .1;
    elseif (move == "s")
        q1 = q1 - .1;
    elseif (move == "e")
        q2 = q2 + .1;
    elseif (move == "d")
        q2 = q2 - .1;
    elseif (move == "r")
        q3 = q3 + .1;
    elseif (move == "f")
        q3 = q3 - .1;
    elseif (move == "t")
        q4 = q4 + .1;
    elseif (move == "g")
        q4 = q4 - .1;
    end

end

%---plot location of the operational point as
%   a function of time
% figure
% 
% subplot(3,1,1)
% plot(t,xE_0)
% xlabel('time'); ylabel('xE'); grid on
% 
% subplot(3,1,2)
% plot(t,yE_0)
% xlabel('time'); ylabel('yE'); grid on
% 
% subplot(3,1,3)
% plot(t,zE_0)
% xlabel('time'); ylabel('zE'); grid on
