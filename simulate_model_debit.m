%% Description
% This function simulates the first debit model
function[] = simulate_model_debit(dict_frac_f, dict_frac_r, dict_frac_d_f, dict_frac_d_r, index)
%% Extract nominators and denominators (continuous)
num_f = dict_frac_f('nominator');
den_f = dict_frac_f('denominator');

num_r = dict_frac_r('nominator');
den_r = dict_frac_r('denominator');

%% Extract nominators and denominators (discrete)
num_d_f = dict_frac_d_f('nominator');
den_d_f = dict_frac_d_f('denominator');

num_d_r = dict_frac_d_r('nominator');
den_d_r = dict_frac_d_r('denominator');

%% Assign Nominator and Denominator to Workspace (continuous)
assignin('base', 'num_f', num_f);
assignin('base', 'den_f', den_f);

assignin('base', 'num_r', num_r);
assignin('base', 'den_r', den_r);

%% Assign Nominator and Denominator to Workspace (discrete)
assignin('base', 'num_d_f', num_d_f);
assignin('base', 'den_d_f', den_d_f);

assignin('base', 'num_d_r', num_d_r);
assignin('base', 'den_d_r', den_d_r);

%% Simulate the model
load_system('model_12.mdl');
sim('model_12.mdl', 100);
figure(index);
plot(y_out_ideal.time, y_out_ideal.signals.values, '-.k');
grid on;
hold on;
plot(y_out_continuous.time, y_out_continuous.signals.values, '-b');
plot(y_out_discrete.time, y_out_discrete.signals.values, '--r');
title ('Simulink Model');
xlabel('t');
ylabel('y');
hold off;
legend('Continuous system no perturbance', ...
       'Continuous System', ...
       'Discrete System');

end
