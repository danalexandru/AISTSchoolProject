%% Description
% This function simulates the first debit model
function[] = simulate_model_debit(dict_frac_d_f, dict_d_r_tf, index)
%% Extract nominators and denominators (discrete)
num_d_f = dict_frac_d_f('nominator');
den_d_f = dict_frac_d_f('denominator');

%% Extract RST polinomials
r = dict_d_r_tf('R')';
s = dict_d_r_tf('S')';
t = dict_d_r_tf('T')';

%% Assign Nominator and Denominator to Workspace (discrete)
assignin('base', 'num_d_f', num_d_f);
assignin('base', 'den_d_f', den_d_f);

assignin('base', 'r', r);
assignin('base', 's', s);
assignin('base', 't', t);

%% Simulate the model
load_system('model_12.mdl');
sim('model_12.mdl', 100);
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
       'Discrete System');

end
