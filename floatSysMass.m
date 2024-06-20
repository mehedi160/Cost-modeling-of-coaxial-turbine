function [buoyMass,buoyancy] = floatSysMass(P_mech)

    rotDens = 2000;
    rotMass = rotorMass(P_mech);
    rotVol = rotMass/rotDens;
    
    
    Cp = 0.485;
    rho = 1026;
    v_inf = 1.78816;
    dia = 2*sqrt((2*P_mech)/(pi*Cp*rho*v_inf^3));
    
    [nclMass,gbD,l_coax] = nacelleMass(P_mech);
   
    nclVol = (pi/4)*(gbD^2)*l_coax + (1/6)*pi*gbD^3;
    %[stMass,stVol] = structMass(P_mech);

    subMass = rotVol*1026 - rotMass + nclVol*1026 - nclMass;

    %turbMass = rotorMass(P_mech) + nacelleMass(P_mech) + tetherMass(P_mech);
    buoyancy = (subMass+50)*9.81;
    buoyMass = 0.01966*(subMass+50)*9.81 + 47.3;

end