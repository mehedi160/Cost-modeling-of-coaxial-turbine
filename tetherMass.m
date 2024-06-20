function tMass = tetherMass(Drag,tension,theta)
    tMassD = (2000/cosd(theta))*((7.714e-7)*(Drag) + 0.001349);  
    tMassF = (2000/cosd(theta))*((7.714e-7)*(tension) + 0.001349);
    tMass = tMassD + tMassF;
end