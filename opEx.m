function [op,insOp,rplOp,shrOp,mrnOp] = opEx(N,rotorN,nacelleN,tetherN,anchorN,CapEx,Per)
%% shoreside 
       a3 =       101.6;
       b3 =     -0.3119;
       c3 =       5.643;
       d3 =   -0.002421;
shrOp =  Per*N*(a3*exp(b3*N) + c3*exp(d3*N))/1e3;

%% insurance
if N < 11
    n = 2;
else
    n = 2.339*exp(-0.01624*N);
end

insOp = 0.01*n*CapEx;

%% replacement

rplOp = (0.94/100)*(rotorN+nacelleN) + 0.1*(tetherN+anchorN);

%% marine 
dayRate = 22425;
interv = 1.5;

mrnOp = interv*N*dayRate;

%% OpEx

op = insOp + shrOp + rplOp + mrnOp;

end



































