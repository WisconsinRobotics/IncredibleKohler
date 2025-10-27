function [T0_base, T1B, T2B, T3B, T4B] = computeTransforms_New_Arm(q_rail, q1, q2, q3, q4, L1, L2, L4)
    T0_base = [1  0  0  0
               0  1  0  0
               0  0  1  -q_rail 
               0  0  0  1];
        
    %transformation from {1} to {0}
    T10 = [ 1  0  0  0
            0  1  0  q1 + L1
            0  0  1  0 
            0  0  0  1];
    
    %transformation from {2} to {1};
    T21 = [ 1  0  0  q2
            0  1  0  L2
            0  0  1  0 
            0  0  0  1];
    

   %transformation from {4} to {3}
    s = sin(q3);
    c = cos(q3);
    T32 = [c  -s 0  0
           s  c  0  0
           0  0  1  0 
           0  0  0  1];
    %transformation from {3} to {2}
    s = sin(q4); c = cos(q4);
    T43 = [c  0 s  0
           0  1  0  L2 *c
           -s  0  c  L2 * s 
           0  0  0  1];

    %transformations to the base frame {0}
    T1B = T0_base*T10;
    T2B = T1B*T21;
    T3B = T2B*T32;
    T4B = T3B*T43;
end