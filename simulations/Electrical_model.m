% Thruster Simulation

clear;
Tstop = 100e-6;

% Constants
mu_o = 4*pi*10^-7;

thruster_type = "Coaxial";  
% 1 = Linear 
% 2 = Coaxial

power_type = "Capacitor";

m_o = 100e-6;
m_rate = 50e-6;

switch(thruster_type)

    case 'Linear'
        w = 10e-3;
        d = 6e-3;
        h = 30e-3;

        F_constant = (0.5 * mu_o * (h/w));
        
        Le = 1e-9;
        Re = 5e-3;
        
        Rpe = 40e-3;
        Lpe = mu_o * (h/w);
        
        delta = 1e-9;
        Lp = mu_o * (delta/2)*(h/w);
        Rp = 15e-3;

    case 'Coaxial'
        % Parameters
        r_o = 15e-3; % mm
        r_i = 5e-3; %mm

        Le = 2.2e-7;
        Re = 5e-3;

        Rpe = 5e-3; % per meter
        Lpe = (mu_o/(4*pi))*log(r_o/r_i);

        delta = 1e-6;
        Lp = mu_o * (delta/4*pi)*log(r_o/r_i);
        Rp = 15e-3;

        F_constant = (0.5 * Lpe);
end



switch (power_type)
    case 'Capacitor'
        V_o = 400;
        C = 2e-3;
        C_l = 34e-9;
        C_r = 30e-3;
end
