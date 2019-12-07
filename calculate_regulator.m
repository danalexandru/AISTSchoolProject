%% Description
% This function calculates a PI regulator for a given system
function [dict_pc, dict_r_tf] = calculate_regulator(dict_p_tf, dict_e_tf, dict_f_tf, dict_pc)
%% Calculate the transfer function along with it's parameters
dict_r_tf = containers.Map;

s = tf('s');
dict_pc('transitory_time') = min(dict_p_tf('time_constant'), dict_e_tf('time_constant')) * ...
    (-2*log(0.05*sqrt(1 - dict_pc('overshoot')^2)));
dict_pc('pulsation') = -log(0.05*sqrt(1 - dict_pc('overshoot')^2)) / ...
    (dict_pc('transitory_time')*dict_pc('overshoot'));

dict_r_tf('time_constant') = max(dict_p_tf('time_constant'), dict_e_tf('time_constant'));
dict_r_tf('amplification') = (dict_pc('pulsation')*dict_r_tf('time_constant')) / ...
    (2*dict_pc('overshoot')*dict_f_tf('amplification'));

dict_r_tf('value') = dict_r_tf('amplification') * ...
    (1 + dict_r_tf('time_constant')*s) / ...
    (dict_r_tf('time_constant')*s);

end
