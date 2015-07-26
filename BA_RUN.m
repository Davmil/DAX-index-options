%%%%%%%%%%%%%%%% Run script %%%%%%%%%%%%%%%%%%%%%%%%%%%

cd C:\Users\David\Documents\Bachelorarbeit\main;
% cd D:\Bachelorarbeit\main;

format short g

% Importing
run('BA_0_StartUp.m')

% Filtering
run('BA_0b_Filtering.m')

% Estimate Volatility
run('BA_0c_Vol_Est.m')

% Value model prices
run('BA_3_Model_Prices.m')

% Determine Pricing Errors
run('BA_3b_Pricing_Errors.m')


% 1_Stylized Facts, 2_Plots und 2b_Plots_ImplVola per Hand