%% Description
% This function returns the performance criteria for a given system, based
% on the type and the index (if neccesary)
function[dict_pc] = get_performance_criteria(type, index)
%% Chech initial parameters
if (nargin < 2)
    index = NaN;
elseif (index ~= 1 && index ~= 2)
    return;
end

%% Return performance criteria based on the system type
dict_pc = containers.Map;

if (strcmp(type, 'debit'))
    if (index == 1)
        dict_pc('overshoot') = 0.7;
        dict_pc('pulsation') = NaN;
        dict_pc('transitory_time') = NaN;
    elseif (index == 2)
        dict_pc('overshoot') = 0.7;
        dict_pc('pulsation') = NaN;
        dict_pc('transitory_time') = NaN;
    else
        return;
    end
else
    return;
end

end
