%% Description
% This function calculates the fixed part of the transfer function
function[dict_f_tf] = calculate_fixed_part_transfer_funcion(dict_p_tf, dict_e_tf, dict_t_tf)
%% Calculate the transfer function along with it's parameters
dict_f_tf = containers.Map;

dict_f_tf('amplification') = ...
    dict_p_tf('amplification') * ...
    dict_e_tf('amplification') * ...
    dict_t_tf('amplification');

dict_f_tf('time_constant') = [...
    dict_p_tf('time_constant') * dict_e_tf('time_constant'), ...
    dict_p_tf('time_constant') + dict_e_tf('time_constant')...
    ];

dict_f_tf('value') = dict_p_tf('value') * dict_e_tf('value') * dict_t_tf('value');

end