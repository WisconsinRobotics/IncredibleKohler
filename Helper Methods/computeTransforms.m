function [T0_base, T1B, T2B, T3B, T4B] = computeTransforms(qbase, q1, q2, q3, q4, L1, L2)
    T0_base = [1  0  0  0
               0  1  0  0
               0  0  1  -qbase
               0  0  0  1];
        
    % {1} to {0}
    s = sin(q1); c = cos(q1);
    T10 = [ s  c  0  -L1*s
           -c  s  0   L1*c
            0  0  1   0
            0  0  0   1];
    
    % {2} to {1}
    s = sin(q2); c = cos(q2);
    T21 = [s  c  0  -L2*s
          -c  s  0   L2*c
           0  0  1   0
           0  0  0   1];
    
    % {3} to {2}
    s = sin(q3); c = cos(q3);
    T32 = [c -s 0 0
           s  c 0 0
           0  0 1 0
           0  0 0 1];
    
    % {4} to {3}
    s = sin(q4); c = cos(q4);
    T43 = [c  0 -s 0
           0  1  0 0
           s  0  c 0
           0  0  0 1];

    % Combine
    T1B = T0_base*T10;
    T2B = T1B*T21;
    T3B = T2B*T32;
    T4B = T3B*T43;
end