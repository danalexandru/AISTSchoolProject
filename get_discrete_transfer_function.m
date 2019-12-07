%% Description
% This function turns the continuous transfer functions into discrete ones
function[dict_d_f_tf] = get_discrete_transfer_function(dict_f_tf, Ts)
%% Calculate the transfer function along with it's parameters
dict_d_f_tf = containers.Map;

dict_d_f_tf('value') = c2d(dict_f_tf('value'), Ts, 'tustin');
end