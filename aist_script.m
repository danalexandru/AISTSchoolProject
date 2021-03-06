%% Description:
% This script is the main part from which all the components of the project are called
function [] = aist_script()
%% Clear previous parameters
clc; 
clear;

%% Initial debit parameters
[dict_debit_system_1, dict_e_tf_1, dict_t_tf_1] = get_debit_1_initial_values();
[dict_debit_system_2, dict_e_tf_2, dict_t_tf_2] = get_debit_2_initial_values();

%% Calculate the transfer function the systems
dict_p_tf_1 = calculate_debit_transfer_function(dict_debit_system_1);
dict_p_tf_2 = calculate_debit_transfer_function(dict_debit_system_2);

%% Calculate the fixed transfer function
dict_f_tf_1 = calculate_fixed_part_transfer_funcion(dict_p_tf_1, dict_e_tf_1, dict_t_tf_1);
dict_f_tf_2 = calculate_fixed_part_transfer_funcion(dict_p_tf_2, dict_e_tf_2, dict_t_tf_2);

%% Calculate continuous regulators
dict_pc_1 = get_performance_criteria(dict_debit_system_1('type'), 1);
[dict_pc_1, dict_r_tf_1] = calculate_regulator(dict_p_tf_1, dict_e_tf_1, dict_f_tf_1, dict_pc_1);

dict_pc_2 = get_performance_criteria(dict_debit_system_2('type'), 2);
[dict_pc_2, dict_r_tf_2] = calculate_regulator(dict_p_tf_2, dict_e_tf_2, dict_f_tf_2, dict_pc_2);

%% Simulate continuous debit model
dict_frac_f_1 = get_nomilator_denomilator_from_tf(dict_f_tf_1);
dict_frac_f_2 = get_nomilator_denomilator_from_tf(dict_f_tf_2);

dict_frac_r_1 = get_nomilator_denomilator_from_tf(dict_r_tf_1);
dict_frac_r_2 = get_nomilator_denomilator_from_tf(dict_r_tf_2);

simulate_model_continuous_debit(dict_frac_f_1, dict_frac_r_1, 1);
simulate_model_continuous_debit(dict_frac_f_2, dict_frac_r_2, 2);

%% Get the discrete transfer function for the regulator and the fixed part
Ts = 0.1;

dict_perf_criteria = containers.Map;

dict_perf_criteria('discretisation_period') = Ts;
dict_perf_criteria('pulsation') = pi/(2*Ts);
dict_perf_criteria('damping_ratio') = 0.7;

dict_d_f_tf_1 = get_discrete_transfer_function(dict_f_tf_1, Ts);
dict_d_f_tf_2 = get_discrete_transfer_function(dict_f_tf_2, Ts);

dict_d_r_tf_1 = get_rst_regulator(dict_d_f_tf_1, dict_perf_criteria);
dict_d_r_tf_2 = get_rst_regulator(dict_d_f_tf_2, dict_perf_criteria);

assignin('base', 'Ts', Ts);

%% Get the nominator and denominator for the simulink model (discrete)
dict_frac_d_f_1 = get_nomilator_denomilator_from_tf(dict_d_f_tf_1);
dict_frac_d_f_2 = get_nomilator_denomilator_from_tf(dict_d_f_tf_2);

%% Simulate results
simulate_model_debit(dict_frac_d_f_1, dict_d_r_tf_1, 1);
simulate_model_debit(dict_frac_d_f_2, dict_d_r_tf_2, 2);

%% Get the temperature and pressure transfer functinos
Ts = 0.1;

[dict_d_p_tf_3, dict_d_r_tf_3] = get_temperature_system_values(Ts);
[dict_d_p_tf_4, dict_d_r_tf_4] = get_pressure_system_values(Ts);

%% Simulate results
simulate_model_temperature_pressure(dict_d_p_tf_3, dict_d_r_tf_3, 3);
simulate_model_temperature_pressure(dict_d_p_tf_4, dict_d_r_tf_4, 4);

%% Optimisation portion
csv_file = 'castr_aist_project_dataset.csv';

dict_ident_data = get_identification_data(csv_file);
struct_sol = get_optimisation_results(dict_ident_data);

end