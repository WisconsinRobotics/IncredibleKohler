function [J, Jv, Jw] = Jacobian_4DOF(T10,T20,T30, T40)

%---- basic Jacobian
z00 = [0 0 1]';
z10 = T10(1:3,3); o10 = T10(1:3,4);
z20 = T20(1:3,3); o20 = T20(1:3,4);
z30 = T30(1:3,3); o30 = T30(1:3,4);
z40 = T40(1:3,3); o40 = T40(1:3,4);
Jc1 = [cross(z00,o40)];
Jc2 = [cross(z10,o40-o10)];
Jc3 = [cross(z20,o40-o20)];
Jc4 = [cross(z30,o40-o30)];
% Angular part (revolute)
Jw1 = z00;
Jw2 = z10;
Jw3 = z20;
Jw4 = z30;

% Combine
Jv = [Jc1 Jc2 Jc3 Jc4];
Jw = [Jw1 Jw2 Jw3 Jw4];
J  = [Jv; Jw];
