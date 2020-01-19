%% Description 
% This method returns the lagrangian
function [struct_sol] = get_optimisation_results(dict_ident_data)
%% Retrieve the identification data
a0 = dict_ident_data('a0');
a1 = dict_ident_data('a1');
a2 = dict_ident_data('a2');
a3 = dict_ident_data('a3');
a4 = dict_ident_data('a4');

%% Write the g inequatilites in matrix form A*y <= b
A = [...
    -1  0   0   0; ...
    1   0   0   0; ...
    0   -1  0   0; ...
    0   1   0   0; ...
    0   0   -1  0; ...
    0   0   1   0; ...
    0   0   0   -1; ...
    0   0   0   1 ...
    ];

b = [...
    -1000; ...
    1600; ...
    -430; ...
    540; ...
    -3.3; ...
    4.5; ...
    -840; ...
    860  ...
    ];

%% Define the Yalmip variables
y1 = sdpvar(1); y2 = sdpvar(1); y3 = sdpvar(1); y4 = sdpvar(1);
l1 = sdpvar(1); l2 = sdpvar(1); l3 = sdpvar(1); l4 = sdpvar(1);
l5 = sdpvar(1); l6 = sdpvar(1); l7 = sdpvar(1); l8 = sdpvar(1);
    
index = 2^8 - 1;
solutions = [];
while (index >= 0)
    %% Determine active lambdas
    is_active = dec2bin(index, 8) - '0';
    l = diag(is_active)*[l1; l2; l3; l4; l5; l6; l7; l8];
    
    %% Use Yalmip
    try
        F = [...
            a1 - l(1) + l(2) == 0, ...
            -a2/(y2^2) - l(3) + l(4) == 0, ...
            a3 - l(5) + l(6) == 0, ...
            2*a4*y4 - l(7) + l(8) == 0, ...
            A*[y1; y2; y3; y4] <= b, ...
            l >= zeros(8, 1), ...
            ];
    
    %% Get results
        sol = solvesdp(F);
        y1_sol = double(y1);
        y2_sol = double(y2);
        y3_sol = double(y3);
        y4_sol = double(y4);

        l_sol = zeros(8, 1);
        for i = 1 : 8
            if (is_active(i) == 1)
                l_sol(i) = double(l(i));
            end
        end
    catch 
        index = index - 1;
        continue;
    end
    
    %% Decrease index
    index = index - 1;
    if (sol.problem ~= 0 || sum(isnan([y1_sol y2_sol y3_sol y4_sol l_sol']) > 0))
        continue
    end

    solutions = [solutions; y1_sol y2_sol y3_sol y4_sol l_sol'];
    
end

%% Return the minimum
z = @(y1, y2, y3, y4) a0 + a1*y1 + a2/y2 + a3*y3 + a4*y4^2;

[M, ~] = size(solutions);
index = -1;
z_min = inf;
for i = 1 : M
    y_1 = solutions(i, 1);
    y_2 = solutions(i, 2);
    y_3 = solutions(i, 3);
    y_4 = solutions(i, 4);
    
    if (z(y_1, y_2, y_3, y_4) < z_min)
        index = i;
        z_min = z(y_1, y_2, y_3, y_4);
    end
end

%% Put solution in a structure
struct_sol = struct;

struct_sol.y1 = solutions(index, 1);
struct_sol.y2 = solutions(index, 2);
struct_sol.y3 = solutions(index, 3);
struct_sol.y4 = solutions(index, 4);

struct_sol.l1 = solutions(index, 5);
struct_sol.l2 = solutions(index, 6);
struct_sol.l3 = solutions(index, 7);
struct_sol.l4 = solutions(index, 8);
struct_sol.l5 = solutions(index, 9);
struct_sol.l6 = solutions(index, 10);
struct_sol.l7 = solutions(index, 11);
struct_sol.l8 = solutions(index, 12);

struct_sol.z_min = z_min;
end