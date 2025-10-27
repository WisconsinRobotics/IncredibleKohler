function [qbase, q1, q2, q3] = IK_New_Arm_solver(x, y, z, theta, L4)
    x4 = x
    y4 = y
    z4 = z;

    qbase = z4;
    theta = theta + pi

    x3 = x4 + L4 * cos(theta)
    y3 = y4 - L4 * sin(theta)

    q1 = y3
    q2 = x3
    q3 = pi/2 - theta
    
    %q3 = pi/2 - q3;
