function [aMassMedi,Drag,tension,clump] = anchorMass(P_mech, theta, buoyancy)
    

    yaw = 90;
    Cp = 0.485;%16/25;
    rho = 1026;
    v_inf = 1.78816;
    r = sqrt((2*P_mech)/(pi*Cp*rho*sind(yaw)*v_inf^3));
    
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
   
    
    T1 = .5*rho*(pi*r^2)*v_inf^2*ct_f;
    T2 = .5*rho*(pi*r^2)*v_inf^2*ct_r;

    T_coax = T1 + T2; 
    tension = sqrt(buoyancy^2 + T_coax^2);
    %plot(theta,clump,'ro')
    
    x0 = [100 100];
    sigma_yield = 1059016990.03695;%300e6;
    loop = fsolve(@(x)TetherV2(x,tension,theta),x0);
    Tb = loop(1);
    Ta = loop(2);
    d = sqrt(max([Tb,Ta,tension])/(pi*sigma_yield));
    mu = 0.0010016;
    Re = rho*d*v_inf/mu;
    Cd = 1 + 10*Re^(-2/3);
    Drag = .5*rho*d*v_inf^2*(0.43*2500 + Cd*500);
       
    clump = tension*cosd(theta)/9.81;
    
    uhc = (tension + Drag - clump*9.81)/(9.81e3);
    if uhc < 43.66828741
        aMassMedi = 1e3 + clump;
    else
        aMassMedi = 1e3*(0.01851*uhc - 0.8083) + clump;
    end
end



function F = TetherV2(x,Tt_current,theta_current)
    F(1) = x(1)-(x(2)*sind(theta_current));
    F(2) = Tt_current-(x(2)*cosd(theta_current));
end