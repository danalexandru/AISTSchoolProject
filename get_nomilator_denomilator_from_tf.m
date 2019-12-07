%% Description
% This function returns the nominator and denominator for a transfer
% function
function[dict_frac_f] = get_nomilator_denomilator_from_tf(dict_f_tf)
%% Extract the nominator and denominator
[num, den] = tfdata(dict_f_tf('value'));

num = num{1, 1};
den = den{1, 1};

%% Put the nominator and denominator into a dictionary
dict_frac_f = containers.Map;

dict_frac_f('nominator') = num;
dict_frac_f('denominator') = den;
end
