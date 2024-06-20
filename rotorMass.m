function m_rotor = rotorMass(P_mech)

mass_coax = 3261*P_mech/1e6;

hub_mass = 2*(0.954*mass_coax/6 + 5680.3);

m_rotor = mass_coax + hub_mass;

end