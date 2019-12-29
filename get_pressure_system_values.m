%% Description
% This method returns the temperature discrete process transfer function
% and the discrete regulator transfer function
function [dict_d_p_tf, dict_d_r_tf] = get_pressure_system_values(Ts, q0)
%% Set the process transfer function
dict_d_p_tf = containers.Map;

dict_d_p_tf('nominator') = [0 0.00597];
dict_d_p_tf('denominator') = [1 -1.68364 0.70730];

%% Get the process transfer function value
z = tf('z', Ts);
num = dict_d_p_tf('nominator');
den = dict_d_p_tf('denominator');

B = 0;
A = 0;
for i = 1 : length(num)
    B = B + num(i)*z^(length(den) - i);
end

for i = 1 : length(den)
    A = A + den(i)*z^(length(den) - i);
end

dict_d_p_tf('value') = B/A;

%% Get the regulator transfer function
dict_d_r_tf = containers.Map;

dict_d_r_tf('value') = q0*A/(1*z^(length(den) - 1) - q0*B);
dict_frac_f = get_nomilator_denomilator_from_tf(dict_d_r_tf);

dict_d_r_tf('nominator') = dict_frac_f('nominator');
dict_d_r_tf('denominator') = dict_frac_f('denominator');

end
