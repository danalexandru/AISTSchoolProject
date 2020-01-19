%% Description
% This method returns the identification data (a0, a1, a2, a3) from the
% initial data from a csv file
function [dict_ident_data] = get_identification_data(csv_file)
%% Check parameters
if (nargin < 1)
    %% Get default csv file
    csv_file = 'castr_aist_project_dataset.csv';
end

%% Extract data from the csv
csv_data = readtable(csv_file);
[m, n] = size(csv_data);

%% Take the data and format them into matrixes
Y = csv_data{1 : end, 1 : end - 1};
I = csv_data{1 : end, end};

% Y = [...
%     ones(m, 1) ...
%     Y(1 : m, 1) ...
%     1./Y(1 : m, 2) ...
%     Y(1 : m, 3) ...
%     Y(1 : m, 4).^2 ...
%     ];

Y = [...
    ones(m, 1) ...
    Y(1 : m, 1) ...
    Y(1 : m, 2) ...
    Y(1 : m, 3) ...
    Y(1 : m, 4) ...
    ];

%% Get the answer to the YA = I equation
% N = min(m, n);
% A = (Y(1 : N, 1 : N))^(-1) * I(1 : N);

%% Get the answer to the YA = I using Yalmip
a0 = sdpvar(1);
a1 = sdpvar(1);
a2 = sdpvar(1);
a3 = sdpvar(1);
a4 = sdpvar(1);

F = [(a0*Y(:, 1) + a1*Y(:, 2) + a2./Y(:, 3) + a3*Y(:, 4) + a4*Y(:, 5).^2) == I];
sol = solvesdp(F);
A = [double(a0) double(a1) double(a2) double(a3) double(a4)];

%% Put the A results into a dictionary
dict_ident_data = containers.Map;

dict_ident_data('a0') = A(1);
dict_ident_data('a1') = A(2);
dict_ident_data('a2') = A(3);
dict_ident_data('a3') = A(4);
dict_ident_data('a4') = A(5);

end