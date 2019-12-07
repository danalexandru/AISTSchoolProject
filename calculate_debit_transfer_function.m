%% Description
% This method calculates the debit transfer function
function[dict_p_tf] = calculate_debit_transfer_function(dict_debit_system)
%% Retrieve required parameters;
F0 = dict_debit_system('initial_debit');
D = dict_debit_system('diameter');
L = dict_debit_system('length');
alpha = dict_debit_system('flow_coefficient');
q = dict_debit_system('density');


S = pi * D * L;
V0 = pi * L * D^2 /4;

%% Calculate the transfer function along with it's parameters
dict_p_tf = containers.Map;

dict_p_tf('amplification') = (alpha^2 * V0)/F0;
dict_p_tf('time_constant') = (alpha^2 * S^2)/(F0 * q);

s = tf('s');
dict_p_tf('value') = dict_p_tf('amplification')/(dict_p_tf('time_constant')*s + 1);

end