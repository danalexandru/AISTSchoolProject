%% This method returns the debit initial values
function [dict_debit_system, dict_e_tf, dict_t_tf] = get_debit_1_initial_values()
%% Dictionary containing debit system initial settings
dict_debit_system = containers.Map;

dict_debit_system('type') = 'debit';
dict_debit_system('initial_debit') = 1400; % m^3 / h;
dict_debit_system('diameter') = 200; % m
dict_debit_system('length') = 10 / pi; % m
dict_debit_system('flow_coefficient') = 0.9;
dict_debit_system('density') = 715 * 10^3; % g/ m^3;

%% Execution Element Transfer Function
dict_e_tf = containers.Map;
dict_e_tf('amplification') = 0.16;
dict_e_tf('time_constant') = 6;

s = tf('s');
dict_e_tf('value') = dict_e_tf('amplification') / (dict_e_tf('time_constant')*s + 1);

%% Transducer Transfer Function
dict_t_tf = containers.Map;

dict_t_tf('amplification') = 2080 /3;
dict_t_tf('value') = dict_t_tf('amplification');
end