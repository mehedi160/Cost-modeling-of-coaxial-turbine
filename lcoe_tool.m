clear
clc

%r_f = linspace(0.5, 5000, 1000);
P_turb = linspace(1, 3000e3, 100);

%P_turb = 1.5e6;
N_t = 50;
b = 1.32;
%% rotor
% TSR 4
rho = 1024;
v1 = 2;
v2 = v1*(1 - 2*0.2443);
cp = 4.94856e-01;
%cp = 0.467
%P_turb = (cp * 0.5 * rho * pi * r_f.^2 * v1^3) + (cp * 0.5 * rho * pi * (1.32*r_f).^2 * v2^3);
r_f = sqrt(P_turb/((cp * 0.5 * rho * pi * 1 * v1^3) + (cp * 0.5 * rho * pi * b^2 * v2^3)));
m_rotor = 3*13.72 * r_f .^ 2.219;

f_rmat = ((5.669140137+5.154975149+6.550526042)*(210.45/174.2) + (2.979795521+2.944579975+2.967454915)*(210.45/103.9))/6;
f_rmfg = ((6.359002985+5.631892195+4.408982332)*(241.803/222.3) + (6.726378814+5.257592656+4.86224143)*(241.803/154.4))/6;

c_rotor = m_rotor*(f_rmat + f_rmfg);
lcoe = c_rotor./P_turb;
plot(r_f, lcoe, 'ro')

%% generator
gen_dim = readmatrix('generator_dim.txt');
gen_len = 0.005961*P_turb.^0.3572;
gen_rad = 0.002872*P_turb.^0.459;
P1 = 0.75e3;
m_active_1 = (1280.94894275 + 220.79844 + 818.34845) / 1000;
m_r_arm_1 = 1383.40804 / 1000;
m_s_arm_1 = 1096.83666 / 1000;
m_r_yoke_1 = 2284.31720094 / 1000;
m_s_yoke_1 = 2461.73741918 / 1000;
P2 = P_turb;
m_active_2 = P2 / P1 * m_active_1;
m_r_arm_2 = (P2 / P1) .^ 1.75 * m_r_arm_1;
m_s_arm_2 = (P2 / P1) .^ 1.75 * m_s_arm_1;
m_r_yoke_2 = (P2 / P1) .^ 1.50 * m_r_yoke_1;
m_s_yoke_2 = (P2 / P1) .^ 1.50 * m_s_yoke_1;
m_gen = m_active_2 + m_r_arm_2 + m_s_arm_2 + m_r_yoke_2 + m_s_yoke_2;
f_gen = ((17.56/157.3 + 12.4/206.9 + 15.226/205.7)*248.522 + 13.874)/4;
c_gen = m_gen*f_gen;

lcoe = .113*(c_rotor + c_gen)./(365*24*P_turb/1000);
plot(P_turb, lcoe, 'ro')

%% shaft
torque = 920*r_f^2.99;
thrust = 6610*r_f^1.996;
R1 = m_gen*9.81/2;
M_a = R1*gen_len/2;
T_m = torque;
S_ut = 470e6;
K_f = 2.2;
K_fs = 3;
n_shaft = 1.5;
S_e = 0.5*4.51*S_ut^(-.265) * 0.9 * S_ut;
d_shaft = ((16*n_shaft/pi)*(2*K_f*M_a/S_e + sqrt(3*(K_fs*T_m)^2)/S_ut))^(1/3);
l_shaft = 0.25*2*r_f + gen_len/2;
m_shaft = pi/4 * d_shaft^2 * l_shaft * rho_shaft;

%% nacelle cover
depth = 50;
p_h = rho*9.81*depth;
sigma_y = 250e6;
n_ncl = 1.3;
t_ncl = n_ncl * p_h * 1.1*gen_rad / sigma_y;
rho_ncl = 8000;
m_ncl = pi*rho_ncl*2.2*gen_rad*r_f*t_ncl;

%% nose cone
sa_nose = 6.308*(1.1*gen_rad)^1.998;
t_nose = t_ncl * 0.1;
m_nose = 2 * sa_nose * t_nose * rho_ncl;

%% rotor hub 
d_blade_root = 0.2*r_f/2.7;
dsgn_hub_diam = 2*r_f*0.1;
stress_allow_pa = sigma_y;
dsgn_hub_rad = dsgn_hub_diam/2;
hub_shell_thick = (((dsgn_hub_diam ^ 4.0 - 32.0 / pi * torque * dsgn_hub_rad / stress_allow_pa)^ (1.0 / 4.0))- dsgn_hub_diam) / (-2.0);
sph_hub_vol = 4.0 / 3.0 * np.pi * (dsgn_hub_rad ^ 3.0 - (dsgn_hub_rad - hub_shell_thick) ^ 3.0);
hub_mass = 2 * sph_hub_vol * rho_ncl;

%% brake
m_brake = 1.22 * torque/1000;

%% seals
%seal_data = readmatrix('seals_data.txt');
%f = fit(seal_data(:,3)/39.37, seal_data(:,4)/2.205, 'power1')
%plot(f, seal_data(:,3)/39.37, seal_data(:,4)/2.205)
m_seals = 101.7*d_shaft^1.475;

%% anchor


%% tether


%% installation cost
A_t = (2*r_f*b)*r_f;
v_s = 10.2889;
day_rate = 30e3;
A_sd = 3533.75;
d_ps = 5e3;
t_ptp = 5*3600;
t_pts = 1*3600;
d_ia = 5*(2*r_f*b);
N_m = 12;
r_a = 1/7200;
v_l = 0.0111111;

t_1t = N_t * A_t * 2*d_ps/(A_sd * v_s);

t_2t = (N_t * A_t * t_ptp)/A_sd + N_t * t_pts;

t_3t = (N_t - N_t * A_t/A_sd) * d_ia / v_s;

t_4t = N_t * (N_m/r_a + 4 * 1.2*r_f*b/v_l);

c_ins = day_rate * (t_1t + t_2t + t_3t + t_4t)/86400;

%% opex

opex = c_ins * failure_rate + c_parts;



















