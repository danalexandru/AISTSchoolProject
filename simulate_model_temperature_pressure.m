%% Description
% This function simulates the first debit model
function [] = simulate_model_temperature_pressure(dict_d_p_tf, dict_d_r_tf, index)
%% Extract nominators and denominators
num_d_p = dict_d_p_tf('nominator');
den_d_p = dict_d_p_tf('denominator');

num_d_r = dict_d_r_tf('nominator');
den_d_r = dict_d_r_tf('denominator');

%% Assign Nominator and Denominator to Workspace
assignin('base', 'num_d_p', num_d_p);
assignin('base', 'den_d_p', den_d_p);

assignin('base', 'num_d_r', num_d_r);
assignin('base', 'den_d_r', den_d_r);

%% Simulate the model
load_system('model_34.mdl');
sim('model_34.mdl', 100);
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
