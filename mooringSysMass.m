function tMass = mooringSysMass(P_mech)

    e1=1/5;
    e2=3/5;
    yaw=90;

    rho=1026;
    v_inf=1.78816;
    Cp_coax = 4*((e1*(1-e1)^2)+(((1-e2)^2)*(e2-(2*e1))));
    r_coax=sqrt((2*P_mech)/(pi*Cp_coax*rho*sind(yaw)*v_inf^3));

    T1=2*rho*pi*r_coax^2*(v_inf*sind(yaw))^2*(1-e1)*e1;
    T2=2*rho*pi*r_coax^2*(v_inf*sind(yaw))^2*(1-e2)*(e2-(2*e1));


    T_coax_opt=T1+T2;
    theta1=linspace(10,80,25);
    x0=[100 100];
    sigma_yield=215e6; %Pa http://asm.matweb.com/search/SpecificMaterial.asp?bassnum=mq304a
    turbine_depth=50;
    altitude=3000-turbine_depth;

    for i=1:length(theta1)
        Tt_current=T_coax_opt;
        theta_current=theta1(i);
        loop=fsolve(@(x)TetherV2(x,Tt_current,theta_current),x0);
        Tb(i)=loop(1);
        Ta(i)=loop(2);
        d_min(i)=sqrt(max([Tb(i),Ta(i),T_coax_opt])/(pi*sigma_yield));
        L_need(i)=altitude/sind(theta1(i));
        vol_needed(i)=(pi/4)*d_min(i).^2*(L_need(i)+turbine_depth);
    end
    density = 1000;
    min_d = min(vol_needed);
    tMass = min_d*density;


    function F=TetherV2(x,Tt_current,theta_current)
        F(1)=x(1)-(x(2)*sind(theta_current));
        F(2)=Tt_current-(x(2)*cosd(theta_current));
    end

end