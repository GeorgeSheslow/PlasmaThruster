%% PPT Simulation
%% ELEC5020 - Capstone A - University of Sydney
%% George Sheslow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
%% Simulation Config
Tsim=1e-3;
%Total simulation time
fs = 100000;
Ts = 1/fs;

%% Mechanical Parameters
r_o = 1;
r_i = 1;
%% Electrical Parameters
V_o = 1;
C = 1;
R_c = 1;
R_e = 1;
R_pe = 1;
L_c = 1;
L_e = 1;

%% Plasma Parameters 

T_e = 1;
n_e = 1;
delta = 1;
sigma_p = 1;

%% Constants

u_o = 1;



% Initial Conditions

resistance = plasma_resistance(1);
%% Run Simulation
sim('PPT_sim.slx');