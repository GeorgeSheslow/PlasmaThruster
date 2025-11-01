function resistance = plasma_resistance(version)
    if(version == 1)
        resistance = 2.57 * ((r_o-r_i)/(T_e^0.75*r_o+r_i))*sqrt(u_o*ln(1.24*10^7(T_e/n_e)*0.5)/t)
end