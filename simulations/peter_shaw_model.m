function PPT_Model_2011_krinberg_final()
%% Parallel Plate Pulsed Plasma Thruster Model %%
% Version April 2011
% Copyright 2011 Surrey Space Centre , University of Surrey , UK
% Author: Peter V. Shaw
% Contact Address :
% Postal: Peter Shaw,
% Surrey Space University of Surrey , Guildford , Surrey , GU2 7XH, UK
% Email: p.shaw@surrey.ac.uk
% Phone : +44(0)1483 684710
% Fax : +44(0)1483 689503 %% Disclaimer
%%
% Although the author has attempted to find and correct any bugs in
% this software program, the author is not responsible for any damage % or losses of any kind caused by the use or misuse of this program.
% The author is under no obligation to provide support , service ,
% corrections , or upgrades to the software program . Any reproduction
% or unauthorised use of the program contained herin is prohibted
% without the express permission of the author or Surrey Space Centre , % University of Surrey , UK.
% This material is protected under copyright law of the United Kingdom. %% Introduction
%%
% This model is based on the work published by of Andre Anders from the
% cathode spot and thin field deposition field and Igor Krinberg from the
% Pinched high current plasma flow f i e l d .
% This model calculates several parameters and characteristics of a
% discharging pulsed plasma thruster , using a lumped circuit analysis
% model. Where the circuit is modelled as a LCR circuit . The model has been made so that only real or experimentally obatined values for components need
% to be entered .
% The model is designed for a parallel plate pulsed plasma thruster that
% uses electrodes that are parallel to each other and are in the form of a rectangular bar with an imputted width , length , thickness and seperated by a given distance . The model is specifically designed for the energy
% supply (bank , storage device etc ) to be in the form of a capacitor .
% Lastly the design is set up for the case where NO Teflon or other propellant is located between the electrode spacing. The propellant is assumed to come from the erroded mass from the electrodes .
%% Upkeep
%%
% This section clears the workspace and command window of all previously
% stored variables and past work . The ’ tic ’ function begins the count % total computation time for the program.
clc 
clear 
tic
%% Global Variables 
%%
% Mechanical Setup 
global PPT V0 % Initial discharge voltage of capacitor
global PPT_C  % Capacitance of High voltage capacitor
global PPT_Height % Speration distance between the electrodes 
global PPT_Thickness % Thickness of the electrodes
global PPT_Width % Width of the electrodes
global L_Cap % Inductance of main PPT capacitor
global R_Cap % Equivalent Series Resistance (ESR) of main PPT capacitor
global freq_discharge % Discharge frequency of PPT
global B_ext_across % Cross magnetic f i e l d experienced pinched coloumn . Should be 0.
global B_ext_axial % Axial magnetic f i e l d experienced pinched coloumn .

% Initial electrode and plasma conditions
% by plasma by plasma
global mass_no % Total mass number of electrode material
global Elec_Conductivity % Conductivity of the electrode material
global E_Q % Complete set of ionisation energies for electrode
global Cn % Initial distribution of the ion charge state in the mixing region

global PPT_I_r % Ion errosion rate for the electrode
global Z0 % Initial mean ion charge state of plasma flow
global PPT_i_e % Ion current normalised by arc current
global PPT_m_i % Particle mass of electrode material
global Te_spot % Temperature of plasma jet near the mixing region
global rmin % Distance from cathode that mixing region forms
global Tem % Maximum electron temperature within a microjet
global M0 % Mach number (same for all cathode materials)
global Cu_spot % Max current per spot for electrode material
global ts_spot % Time for the ion charge state distribution to reach steady state for the specific electrode material 
global R0_per_spot % Initial radius of the plasma flow at the mixing region

% Simulation variables
global t_end % Computation time at the end of each discharge 
global delays % Small change in time to work out d/dt in dde23 % In the electrode model X is the X by X number % of conductors that the electrode should be
global Subconductor_number % split into

global xyz % Simulation count variable
global Res_flow; global Q_flow ; global Coll_flow ; %Sim variables
global v1; global v2; global v3; % variables to extract data for graphs v4; global v5; global v6;
global v7; global v8; global v9;
global v10 ; global v13 ; global v16 ; global v19 ; global v22 ; global v25 ;
global v11 ; global v14 ; global v17 ; global v20 ; global v23 ; global v26 ;
global v12 ; global v15 ; global v18 ; global v21 ; global v24 ;
%% Input Components %%
% Constants
e = 1.60217646e−19; % Fundamental charge

% Mechanical Setup
V_interest = 1700; 
PPT_Height = 0.03; 
PPT_Thickness = 0.01;
PPT_Width = 0.02;
Elec_Conductivity = 59.595e6; % Conductivity of the electrode material
PPTC = 4.06e−6; 
L_Cap = 310e−9; 
R_Cap = 33e−3;

freq_discharge = 136e3; 
B_ext_across = 0;
B_ext_axial=0;

% Electrode and Plasma Properties
E_Q = [7.72638;12.566;16.5486;20.539;22.42;23.2;36;27;33;33;33.3; ...
103.7;32;34;49;36;37;76;37.588;1026.412;107;112;144;122;126; ... 
170;109.5;8474.88;505.237;].∗e; % Complete set of ionisation energies for
% electrode material

mass_no = 29; % Total mass number of electrode material
PPT_m_i = 63.55∗1.66053886e−27; % Particle mass of electrode material
PPT_I_r = 33.4e−9; 
PPT_i_e = 0.114; 
Z0 = 2.06;
Te_spot = 1∗11605; 
rmin = 0.1e−3;
Tem = 2.8∗11605; 
M0 = 3.5;
Cu_spot = 150;
ts_spot = 60e−6;

R0_per_spot = 0.0035;

F_n_0 = zeros(mass no,1);% Create array for the initial distribution ion charge states in the plasm mixing
F_n_0(1,1) = 0.107; 
F_n_0(2,1) = 0.721; 
F_n_0(3,1) = 0.171; 
F_n_0(4,1) = 1.4e−4; 
F_n_0(5,1)=0;
Q=1;
Cn = zeros(mass_no,1);
% of the % region
while Q <= mass_no
Cn(Q,1) = sum(F_n_0(1:Q,1)); Q = Q+1;
end


% Simulation variables 
Subconductor number = 8;
delays = 1e−7; 
t_end = 0;
xyz = 1;

v1 = zeros (250,10); v2 = zero(250,10); v3 = zero(250,10);
v4 = zero(250,10); v5 = zero(250,10); v6 = zero(250,10);
v7 = zero(250,10); v8 = zero(250,10); v9 = zero(250,10);
v10 = zeros (250 ,10); v11 = zeros (250 ,10); v12 = zero(250,10);
v13 = zeros (250 ,10); v14 = zeros (250 ,10); v15 = zero(250,10);
v16 = zeros (250 ,10); v17 = zeros (250 ,10); v18 = zero(250,10);
v19 = zeros (250 ,10); v20 = zeros (250 ,10); v21 = zero(250,10);
v22 = zeros (250 ,10); v23 = zeros (250 ,10); v24 = zero(250,10);
v25 = zeros (250 ,10); v26 = zeros (250 ,10);

Res_flow=1; Q_flow=1; Coll_flow=1;%Sim variables

%% Read in Experimental data





