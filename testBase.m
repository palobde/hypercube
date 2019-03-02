function sol = testBase(Base)
t = cputime;

% Récupération des dimensions
[r k] = size(Base);

% Matrice Aeq des égalités
B = -2*Base + ones(r, k);
Aeq = [B, -B];
% disp('Matrice decomposée: ')
% disp(Aeq); 

% Matrice A des inégalités
ind = 2.^[k-1:-1:0];
IND = [-ind, ind; [ones(1,k), zeros(1,k)]; [zeros(1,k), ones(1,k)]];

% Resolution de l'optimisation
% options = optimoptions('intlinprog','Display','off','TolInteger',1e-6);
options = optimoptions('intlinprog','Heuristics','none','TolInteger',1e-6);

x = intlinprog(zeros(2*k,1), [1:1:2*k], IND, [-1; ceil(k/2); ...
    ceil(k/2)], Aeq, zeros(r,1), zeros(2*k,1), ones(2*k,1), options);

% Interpretation
if length(x)==0
    disp('BASE OK!')
    sol=1;
else
%     if round(x(1:k))==round(x((k+1):2*k))
%         sol=0;
%         disp('BASE OK (Mais en arrondi)!!')
%         disp(max(x))
%         disp(min(x))
%     else
    disp('Présence de Coincidences!!!:')
    sol=0;
    disp(transpose(x(1:k)))
    disp(transpose(x(k+1:2*k)))
%     end
end

time = cputime - t;
disp('Temps de calcul:')
disp(time)

    
