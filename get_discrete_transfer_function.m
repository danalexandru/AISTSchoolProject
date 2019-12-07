%% Description
% This function turns the continuous transfer functions into discrete ones
function[dict_d_f_tf] = get_discrete_transfer_function(dict_f_tf, Ts)
%% Calculate the transfer function along with it's parameters
dict_d_f_tf = containers.Map;

dict_d_f_tf('value') = c2d(dict_f_tf('value'), Ts, 'tustin');

%% Retrieve nominator and denominator of discrete transfer function
dict_frac = get_nomilator_denomilator_from_tf(dict_d_f_tf);
num = dict_frac('nominator');
den = dict_frac('denominator');

%% Rasterize the aspect of the nominator
while (length(num) > 1)
    if (num(1) ~= 0)
        break;
    else
        num = num(2 : end);
    end
end

%% Rasterize the aspect of the denominator
while (length(den) > 1)
    if (den(1) ~= 0)
        break;
    else
        den = den(2 : end);
    end
end

%% Add nominator and denominator to tf dictionary
dict_d_f_tf('amplifier') = num;
dict_d_f_tf('time_constant') = den;
end
