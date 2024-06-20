function [st,vol_par_Q] = structMass(P_mech)

n_blades=3;
def_ratio=0.05;

yaw=90;



E=200e9;

Cp_par=16/27;
e_par=1/3;

rho=1026;
v_inf=1.78816;
AR=4;
TSR_opt=4*pi/3;

e1=1/5;
e2=3/5;
sigma_yield=215e6;
d_D=0.6;

for i=1:length(P_mech)

%Parallel
r_par(i)=sqrt((2*(P_mech(i)/2))/(pi*Cp_par*rho*sind(yaw)*v_inf^3));
omega_par(i)=TSR_opt*v_inf/r_par(i);
Q_par(i)=P_mech(i)/omega_par(i);
T_par(i)=(2*rho*(pi/4)*r_par(i)^2*(v_inf*sind(yaw))^2*(1-e_par)*e_par)/n_blades;
chord_par(i)=r_par(i)/AR;

%Torque
syms s
I_solid_Q=0.00000851*chord_par(i)^4;
I_inner_Q=0.00000851*(chord_par(i)-(2*s))^4;
I=I_solid_Q-I_inner_Q;
eqn_Q_par=I==(Q_par(i)*r_par(i))/(6*E*def_ratio);
skin_thick_par_Q=double(solve(eqn_Q_par,s));
for j=1:length(skin_thick_par_Q)
    if isreal(skin_thick_par_Q(j))
        min_thick_par_Q(j)=skin_thick_par_Q(j);
    end
end
min_thick_par_Q(min_thick_par_Q==0)=nan;
s_par_Q(i)=min(min_thick_par_Q);
A_par_Q(i)=(0.04110432*chord_par(i)^1.99999999)-(0.04110432*(chord_par(i)-2*s_par_Q(i))^1.99999999);
vol_par_Q(i)=A_par_Q(i)*r_par(i);
end


st = vol_par_Q*7000;

end