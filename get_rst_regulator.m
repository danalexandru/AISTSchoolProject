%% Description
% This function will return an RST regulator based on the process discrete
% transfer function, discretisation period and performance criteria
function [dict_d_r_tf] = get_rst_regulator(dict_d_p_tf, dict_perf_criteria)
%% Retrieve data from dict_perf_criteria
w = dict_perf_criteria('pulsation');
z = dict_perf_criteria('damping_ratio');
Ts = dict_perf_criteria('discretisation_period');

s = tf('s');

%% Get the desired pols from the performance criteria
Q = w^2/(s^2 + 2*w*z*s + w^2);
Qd = c2d(Q, Ts, 'zoh');

[~, p] = tfdata(Qd);
p = p{1, 1};

%% Retrieve the 2 process polynomials
B = dict_d_p_tf('nominator');
A = dict_d_p_tf('denominator');

%% Generate Sylvester Matrix
d = 0; na = length(A) - 1; nb = length(B) - 1;
n = na + nb + d;

p(length(p) + 1 : n) = 0; p = p';
M = zeros(n, n);
k = 1;

for j = 1 : n
    k = 1;
    for i = 1 : n
        if (j <= nb + d)
           
            if (k <= na + 1)
               M(i + j - 1, j) = A(k);
               k = k + 1;               
            end
        else
            if (k <= nb + 1)
                M(i + j -nb - 1, j) = B(k);
                k = k + 1;
            end
        end
        
    end
end

%% Retrieve the R and S values
Mi = M^-1;
x = Mi*p;
s = x(1 : nb + d);
r = x(nb + d + 1 : end);

S = filt(s', 1, Ts);
R = filt(r', 1, Ts);

%% Retrieve the T value
if (B(2) ~= 0)
    G = 1/B(2);
else
    G = 1;
end

t = G*p(p ~= 0);
T = filt(t', 1, Ts);

%% Create Regulator dictionary
dict_d_r_tf = containers.Map;

dict_d_r_tf('R') = r;
dict_d_r_tf('S') = s;
dict_d_r_tf('T') = t;

dict_rst_tf_values = containers.Map;
dict_rst_tf_values('R') = R;
dict_rst_tf_values('S') = S;
dict_rst_tf_values('T') = T;

dict_d_r_tf('values') = dict_rst_tf_values;
end
