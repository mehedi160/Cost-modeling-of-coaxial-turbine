function [nclMass,gbD,l_coax,genMass,gbMass,shaftMass,bearingMass,sealMass,brakeMass,nclBMass] = nacelleMass(P_mech)

    %% generator
    genMass = 5.34*(P_mech/1000)^0.9223;
    
    % Direct drive generator
    %genMass = (2.86990604455115*(P_mech/1e6)^2 + 29.6815513741332*(P_mech/1e6))*1e3;
    %% gearbox
    yaw = 90;
    Cp = 0.485;%16/25;
    rho = 1026;
    v_inf = 1.78816;
    r = sqrt((2*P_mech)/(pi*Cp*rho*sind(yaw)*v_inf^3));
    dia = 2*r;
    cp_f = 0.3908;
    TSR_pf = 5.0110;
    ct_f = 0.6682;
    TSR_tf = 5.0250;
    cp_r = 0.0146;
    TSR_pr = 3.0058;
    ct_r = 0.2827;
    TSR_tr = 3.6573;
    rho = 1026;
    v_inf = 1.78816;
    P1 = .5*rho*(pi*r^2)*v_inf^3*cp_f;
    P2 = .5*rho*(pi*r^2)*v_inf^3*cp_r;

    omega1 = TSR_pf*v_inf/r;
    Torque1 = P1/omega1;

    omega2 = TSR_pr*v_inf/r;
    Torque2 = P2/omega2;
    
    totTorque = Torque1 + Torque2;
    
    gbMass = 0.007661938071666*totTorque;
   
    %% shaft
  

    shaftMass1 = 2075*(P_mech/1e6)^2 + 6104.38*(P_mech/1e6);
    shaftMass2 = 323.8*(P_mech/1e6)^2 + 952.68*(P_mech/1e6);
    shaftMass = shaftMass1 + shaftMass2;

    %% bearing
    T1 = .5*rho*(pi*r^2)*v_inf^2*ct_f;
    T2 = .5*rho*(pi*r^2)*v_inf^2*ct_r;

    thrBearing1 = 0.030674*(T1/1e3); 
    thrBearing2 = 0.030674*(T2/1e3); 
    thrBearing = thrBearing1 + thrBearing2;
    
    rotorM = rotorMass(P_mech);
    %rollerBearing = (8.797e-06)*(9.81*(rotorM+shaftMass)/2)^2 + 0.00121*(9.81*(rotorM+shaftMass)/2) + 0.7135;
    x = 9.81*(rotorM+shaftMass)/(4e3);
    rollerBearing1 = (0.000000779232445)*x^2 + 0.025556946040814*x;
    rollerBearing2 = (0.000000779232445)*x^2 + 0.025556946040814*x;
    rollerBearing = rollerBearing1 + rollerBearing2;
    bearingMass = 2*(thrBearing + 2*rollerBearing);
    
    %% seals
    d_coax = 0.0127*2*r;
    sealMass = 2*16.014590599951*d_coax;
    %% brakes
    %brakeMass = 0.003449*totTorque - 0.04661; % centa
    %brakeMass = 0.0051*totTorque + 33.07; % SFK
    brakeMass = (1.9894*P_mech/1e3 - 0.1141)/10; % NREL
    %% nacelle body
    gbD = .09*dia;
    l_coax = 0.5453*dia;
    nclBMass = 4216*(P_mech/1e6)^2 + 12410.73*(P_mech/1e6);
    
    %% converter
    convMass = 0.929*P_mech/1000 + 508.9;
    
    %% transformer
    tranMass = 2007*P_mech/1e6 + 910;
    %% total
    nclMass = genMass + gbMass + shaftMass + bearingMass + sealMass + brakeMass + nclBMass + convMass + tranMass;

end