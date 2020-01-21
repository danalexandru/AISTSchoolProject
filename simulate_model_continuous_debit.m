%% Description
% This function simulates the first debit model
function[] = simulate_model_continuous_debit(dict_frac_f, dict_frac_r, index)
%% Extract nominators and denominators (discrete)
num_f = dict_frac_f('nominator');
den_f = dict_frac_f('denominator');

num_r = dict_frac_r('nominator');
den_r = dict_frac_r('denominator');

%% Assign Nominator and Denominator to Workspace (discrete)
assignin('base', 'num_f', num_f);
assignin('base', 'den_f', den_f);

assignin('base', 'num_r', num_r);
assignin('base', 'den_r', den_r);

%% Simulate the model
load_system('model_12_continuous.mdl');
sim('model_12_continuous.mdl', 100);
figure(index);
plot(y_out_ideal.time, y_out_ideal.signals.values, '-.r');
grid on;
hold on;
plot(y_out.time, y_out.signals.values, '-b');
title ('Simulink Model');
xlabel('t');
ylabel('y');
hold off;
legend('Ideal System', ...
       'Continuous System');

end
