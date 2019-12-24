%Takes in a3, a2, a1 while a4 = 1 and a0 = -1. Outputs the 4 rts of the
%quartic.
function [rts] = quartic24201088(C)
newC = [1, C, -1];
[p1, Q1] = Muller(newC);
[p2, Q2] = Muller(Q1);  
[p3, Q3] = Muller(Q2); 
p4 = -Q3(2);
rts = [p1 p2 p3 p4];
end

%Input is V, a vector of coefficients that goes an,...,a0; and x0. 
function [rt, Q] = Muller(P)
p0 = -1;
p1 = 0;
p2 = 1;
maxIt = 10^6;
tol = 10^(-5);

h1 = p1 - p0;
h2 = p2 - p1;
del1 = (Horner(P,p1)-Horner(P,p0))/h1;
del2 = (Horner(P,p2)-Horner(P,p1))/h2;
d = (del2 - del1)/(h2 + h1);

for i = 3:maxIt
    b = del2 + h2*d;
    D = sqrt(b^2 - 4*Horner(P,p2)*d);
    if (abs(b-D) < abs(b+D))
        E = b+D;
    else
        E = b-D;
    end
    h = (-2*Horner(P, p2))/E;
    p = p2 + h;
    [chk, dchk, Q1] = Horner(P, p);
    if (abs(chk) < tol)
        rt = p;
        Q = Q1;
       return;
    end
    
    p0 = p1;
    p1 = p2;
    p2 = p;
    h1 = p1 - p0;
    h2 = p2 - p1;
    del1 = (Horner(P,p1)-Horner(P,p0))/h1;
    del2 = (Horner(P,p2)-Horner(P,p1))/h2;
    d = (del2 - del1)/(h2 + h1);
end
disp('Max number of iterations reached.');
rt = p;
Q = P;
end

%Input is P, a vector of coefficients that goes an,...,a0; and x0. Output
%is P(x0), P'(x0) and Q(x).
function [val, dval, Q] = Horner(P, x0)
val = P(1);
dval = P(1);
Q = [P(1)];
n = length(P)-1;

for i = 2:n
    val = x0*val + P(i);
    Q(i) = val;
    dval = x0*dval + val;
end
val = x0*val + P(n+1);
end