function LCOE = LCOEcalc(Per)
    data = xlsread('S4_SHARKS_MetricSpaceWorkbook (2).xlsx');
    format long g

    %Per = 1.6e6;
    N = 1;
    rho = 1026;
    Cp = 0.485;
    V1 = 1.78816;%1.54;
    r = sqrt((2*Per)/(pi*Cp*rho*V1^3));
    dia = 2*r;
    Ar = pi*dia^2/4;
    Pw1 = 0.5*rho*Ar*V1^3;
    Lg = 0.05;
    Ldt = 0.05;
    Lw = 0.10;
    Le = 0.05;
    Lo = 0.05;
    Av = 0.95;

    mu = (1-Lg)*(1-Ldt)*(1-Lw)*(1-Le)*(1-Lo)*Av;
    Pe1 = 0.5*rho*Ar*Cp*mu*V1^3;


    Csref = 2;
    vCutIn = 0.5;
    vCutOut = 2.5;
    FCR = 0.113;

    M1 = Cp*mu;

    theta = 66;

    mc1 = rotorMass(Per);
    [mc2,gbD,l_coax,genMass,gbMass,shaftMass,bearingMass,sealMass,brakeMass,nclBMass]...
        = nacelleMass(Per);
    mc3 = 0;
    [mc4,buoyancy] = floatSysMass(Per);
    [mc6,Drag,tension,clump] = anchorMass(Per, theta, buoyancy);
    mc5 = tetherMass(Drag,tension,theta);


    %{
    theta = 0:.01:90;
    for ii = 1:length(theta)
        [mc6(ii),Drag,tension] = anchorMass(Per, theta(ii), buoyancy);
        mc5(ii) = tetherMass(Drag,tension);
    end

    mooring = mc5 + mc6;


    set(groot,'DefaultTextInterpreter','latex')
    plot(theta,mooring,'r-','LineWidth',2)
    grid on
    box on
    xlim([0 90])
    set(gca,'TickLabelInterpreter','latex')
    set(gca,'FontSize',15)
    xlabel('Tether angle [deg]')
    ylabel('Total mooring mass [kg]')
    saveas(gcf,'theta_dependency.png')








    %}



    ft = [4 1 1 1 2.45 1];
    fm = [2.8 2.8 8.03 7.84 1.72 1.72];
    fi = [0.06 0.06 0.06 0.06 0.12 0.12];

    %% 100 units price

    rotor = mc1*ft(1)*(1 + fm(1) + fi(1))*Csref;
    gen = genMass*ft(2)*(1 + fm(2) + fi(2))*Csref;
    gb = gbMass*ft(2)*(1 + fm(2) + fi(2))*Csref;
    shaft = shaftMass*ft(2)*(1 + fm(2) + fi(2))*Csref;
    bearing = bearingMass*ft(2)*(1 + fm(2) + fi(2))*Csref;
    seal = sealMass*ft(2)*(1 + fm(2) + fi(2))*Csref;
    brake = brakeMass*ft(2)*(1 + fm(2) + fi(2))*Csref;
    nclBody = nclBMass*ft(2)*(1 + fm(2) + fi(2))*Csref;
    structure = mc3*ft(3)*(1 + fm(3) + fi(3))*Csref;
    buoy = mc4*ft(4)*(1 + fm(4) + fi(4))*Csref;
    tether = mc5*ft(5)*(1 + fm(5) + fi(5))*Csref;
    anchor = (mc6-clump)*ft(6)*(1 + fm(6) + fi(6))*Csref + ...
        clump*ft(6)*(1 + 0 + fi(6))*Csref;


    %% 1 unit price
    genpr = 81.45/100;
    gbpr = 86.28/100;
    sealpr = 98.56/100;
    bearingpr = 95.88/100;
    rotorpr = 86.16/100;
    ptopr = 95.00/100;
    otherpr = 78.90/100;
    PR = 50/100;

    rotor1 = rotor*100/(100^(log10(rotorpr)/log10(2) + 1));
    gen1 = gen*100/(100^(log10(genpr)/log10(2) + 1));
    gb1 = gb*100/(100^(log10(gbpr)/log10(2) + 1));
    shaft1 = shaft*100/(100^(log10(gbpr)/log10(2) + 1));
    bearing1 = bearing*100/(100^(log10(bearingpr)/log10(2) + 1));
    seal1 = seal*100/(100^(log10(sealpr)/log10(2) + 1));
    brake1 = brake*100/(100^(log10(ptopr)/log10(2) + 1));
    nclBody1 = nclBody*100/(100^(log10(otherpr)/log10(2) + 1));
    structure1 = structure*100/(100^(log10(PR)/log10(2) + 1));
    buoy1 = buoy*100/(100^(log10(otherpr)/log10(2) + 1));
    tether1 = tether*100/(100^(log10(PR)/log10(2) + 1));
    anchor1 = anchor*100/(100^(log10(PR)/log10(2) + 1));


    %% N units

    rotorN = rotor1*(N^(log10(rotorpr)/log10(2) + 1));

    genN = gen1*(N^(log10(genpr)/log10(2) + 1));
    gbN = gb1*(N^(log10(gbpr)/log10(2) + 1));
    shaftN = shaft1*(N^(log10(gbpr)/log10(2) + 1));
    bearingN = bearing1*(N^(log10(bearingpr)/log10(2) + 1));
    sealN = seal1*(N^(log10(sealpr)/log10(2) + 1));
    brakeN = brake1*(N^(log10(ptopr)/log10(2) + 1));
    nclBodyN = nclBody1*(N^(log10(otherpr)/log10(2) + 1));
    nacelleN = sum([genN,gbN,shaftN,bearingN,sealN,brakeN,nclBodyN]);

    structureN = structure1*(N^(log10(PR)/log10(2) + 1));
    buoyN = buoy1*(N^(log10(otherpr)/log10(2) + 1));

    tetherN = tether1*(N^(log10(PR)/log10(2) + 1));

    anchorN = anchor1*(N^(log10(PR)/log10(2) + 1));

    CapN = [rotorN,genN,gbN,shaftN,bearingN,sealN,brakeN,nclBodyN,structureN,buoyN,tetherN,anchorN];
    CapEx = sum(CapN);


    %% AEP
    %
    nHoursYear = 8760;
    interval = 0.05;
    kk = 1/interval;
    nV0 = 301;
    V0 = [0:interval:(nV0-1)*interval]';

    Time = data(29:135,14);
    Speed = V0(1:length(Time));
    meanWaterVel = sum(Time.*Speed);

    Pwater = 0.5*rho*Ar*V0.^3;

    indLow = find(V0<vCutIn);
    indHigh = find(V0>vCutOut);

    h1 = Time;
    h1(indLow) = zeros(length(indLow),1);
    h1(indHigh) = zeros(length(indHigh),1);


    Pelec = M1*Pwater;
    Pelec(indLow) = zeros(length(indLow),1);
    Pelec(Pelec>Per) = Per;


    WhYear(1,1) = h1(1)*Pelec(1)*nHoursYear;
    for ii = 2:length(h1)
        WhYear(ii,1) = h1(ii)*Pelec(ii)*nHoursYear + WhYear(ii-1);
    end
    WhYear(indHigh) = zeros(length(indHigh),1);

    WhYear1 = max(WhYear);
    CF = WhYear1*100/(nHoursYear*Per);
    AEP = nHoursYear*N*Per*(CF/100)/1000;


    [OpEx,insOp,rplOp,shrOp,mrnOp] = opEx(N,rotorN,nacelleN,tetherN,anchorN,CapEx,Per);

    %%
    LCOE = (FCR*CapEx + 0*OpEx)/AEP
end