clear;
Per = linspace(1e5,3e6, 30);

for ii = 1:length(Per)
    LCOE(1,ii) = LCOEcalc(Per(1,ii));
    ii
end

%save('LCOEdata100.mat','Per','LCOE')

%clear

%load('LCOEdata100.mat')
set(groot,'DefaultTextInterpreter','latex')
plot(Per/1e6,LCOE,'--k','LineWidth',2)
%xlim([0 9])
%ylim([0 0.25])
grid on
grid minor
box on
set(gca,'TickLabelInterpreter','latex')
set(gca,'FontSize',15)
xlabel('Rated power of each turbine [MW]')
ylabel('LCOE (\$/kWh)')

%saveas(gcf,'LCOE.png')

%%
%{
clear

Per = 1.71e6;
nTurb = 1:100;
for ii = 1:length(nTurb)
    LCOE(1,ii) = LCOEcalc(Per,nTurb(ii));
end

set(groot,'DefaultTextInterpreter','latex')
plot(nTurb,LCOE,'.b','LineWidth',2)
%xlim([0 3e6])
ylim([0 0.25])
grid on
grid minor
box on
set(gca,'TickLabelInterpreter','latex')
set(gca,'FontSize',15)
xlabel('Number of turbines')
ylabel('LCOE (\$/kWh)')

%saveas(gcf,'LCOEwNum.png')
%%
clear

Per = 8.3e5;
nTurb = 1:100;
for ii = 1:length(nTurb)
    LCOE(1,ii) = LCOEfun(Per,nTurb(ii));
end

set(groot,'DefaultTextInterpreter','latex')
plot(nTurb,LCOE,'m-','lineWidth',2)
%xlim([0 3e6])
%ylim([-2 42])
grid on
grid minor
box on
set(gca,'TickLabelInterpreter','latex')
set(gca,'FontSize',15)
xlabel('Number of turbines')
ylabel('LCOE (\$/kWh)')

%saveas(gcf,'LCOEsamePer.png')

%%
clear

load('LCOEdata.mat')

rho = 1025;
Cp = 0.485;
V1 = 1.54;
r = sqrt((2*Per)./(pi*Cp*rho*V1^3));
dia = 2*r;


set(groot,'DefaultTextInterpreter','latex')
plot(dia,LCOE,'b*')
grid on
grid minor
box on
set(gca,'TickLabelInterpreter','latex')
set(gca,'FontSize',15)
xlabel('Rotor Diameter [m]')
ylabel('LCOE (\$/kWh)')
%saveas(gcf,'LCOEdia.png')
%dia = 34.1189156418648

%}




















