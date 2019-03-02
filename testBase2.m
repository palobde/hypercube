function sol = testBase2(Base)
t = cputime;

% Récupération des dimensions
[r k] = size(Base);

% Matrice Aeq des égalités
B = -2*Base + ones(r,k);
Aeq0 = [B, -B, zeros(r,k)];
Aeq = [Aeq0; eye(k), -eye(k), -eye(k)]
A = [zeros(1, 2*k), -ones(1,k)]
% disp('Matrice decomposée: ')
% disp(Aeq);

% Resolution de l'optimisation
% options = optimoptions('intlinprog','Display','off','TolInteger',1e-6);
options = optimoptions('intlinprog','Heuristics','none','TolInteger',1e-6);

x = intlinprog(zeros(3*k,1), [], A, -1, Aeq, zeros((r+k),1),...
    [zeros(2*k,1); -ones(k,1)], ones(3*k,1), options);

% Interpretation
if length(x)==0
    disp('BASE OK!')
    sol=0;
else
    disp('Présence de Coincidences!!!:')
    sol=1;
    disp(transpose(x(1:k)))
    disp(transpose(x(k+1:2*k)))
    disp(transpose(x(2*k+1:3*k)))
end

time = cputime - t;
disp('Temps de calcul:')
disp(time)

    
