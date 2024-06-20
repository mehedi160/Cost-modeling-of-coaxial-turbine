clear

data = readmatrix('a_a_front.txt');

TSR = 5.0;

col_num = 4*TSR - 2;

a_a = mean(data(:, col_num))


U = 2.5;
v2 = U*(1 - 2*a_a)


clear
r_f = [.24; 2.7; 6.59; 9.33; 11.42; 13.2];
th=[2.04E+02
2.59E+04
1.54E+05
3.09E+05
4.63E+05
6.18E+05];

f = fit(r_f, th, 'power1')
plot(f, r_f, th)


r_f = 2.7
thrust2 = 3558*r_f^1.999


clear
data = readmatrix('tether_dia_data.csv');

%plot(data(2,:)*9.81, data(1,:)/1000,'ro')

f = fit(data(2,:)'*9.81, data(1,:)'/1000, 'power1')
plot(f, data(2,:)'*9.81, data(1,:)'/1000)
set(groot,'DefaultTextInterpreter','latex')
grid on
box on
set(gca,'TickLabelInterpreter','latex')
set(gca,'FontSize',15)
ylabel('Tether diameter [m]')
xlabel('Tension [N]')
saveas(gcf,'tether_dia.png')
th_dia = (2.73e-05)*strength^0.518;



clear

data = readmatrix('seals_data.txt');
f = fit(data(:,3), data(:,4), 'power1')
plot(f, data(:,3), data(:,4))



%%


clear
vel_data = readmatrix('florida_gs.txt');
freq = vel_data(:,2)'/100;
vel = vel_data(:,1)';
set(groot,'DefaultTextInterpreter','latex')
bar(vel, freq)
box on
set(gca,'TickLabelInterpreter','latex')
set(gca,'FontSize',15)
xlabel('Velocity [m/s]')
ylabel('Frequency')
saveas(gcf,'GSfreq.png')

%%
clear

cp = 0.3949;
rho = 1024;
r_f = 2.7;
b = 1.32;
a_a = 0.1648;
vel = linspace(0.34, 2.5, 100);
P = ((cp * 0.5 * rho * pi * r_f^2 .* vel.^3) + (cp * 0.5 * rho * pi * b^2 .* (vel.*(1 - 2*a_a)).^3));
P_fluid = P/cp;
P(77:end) = P(77);
set(groot,'DefaultTextInterpreter','latex')
plot(vel, P_fluid/1e3,'lineWidth',2)
hold on
plot(vel, P/1e3,'lineWidth',2)
hold off
box on
ylim([0, 45])
set(gca,'TickLabelInterpreter','latex')
set(gca,'FontSize',15)
legend('$P_{fluid}$','$P_{mech}$','Location','best','Interpreter','latex')
xlabel('Velocity [m/s]')
ylabel('Power [kW]')
saveas(gcf,'power_curve.png')





































