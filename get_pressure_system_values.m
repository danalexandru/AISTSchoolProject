%% Description
% This method returns the temperature discrete process transfer function
% and the discrete regulator transfer function
function [dict_d_p_tf, dict_d_r_tf] = get_pressure_system_values(Ts)
%% Set the process transfer function
dict_d_p_tf = containers.Map;

dict_d_p_tf('nominator') = [0 0.00597];
dict_d_p_tf('denominator') = [1 -1.68364 0.70730];

dict_d_p_tf('value') = filt(dict_d_p_tf('nominator'), dict_d_p_tf('denominator'), Ts);

%% Get the regulator transfer function
dict_perf_criteria = containers.Map;

dict_perf_criteria('discretisation_period') = Ts;
dict_perf_criteria('pulsation') = pi/(2*Ts);
dict_perf_criteria('damping_ratio') = 0.7;

dict_d_r_tf = get_rst_regulator(dict_d_p_tf, dict_perf_criteria);

end
