function x = testBase3(Base)
t = cputime;

% Récupération des dimensions
[r k] = size(Base);

% Fonction f a optimiser
f = zeros(2*k,1);
% vecteur des indices des variables entieres
int = [1:1:2*k];

% Matrice Aeq des égalités
B = -2*Base + ones(r, k);
Aeq = [B, -B];%, zeros(r,k)];
beq = zeros(r,1);
% disp('Matrice decomposée: ')
% disp(Aeq); 

% Matrice Aineq des inégalités
ind = 2.^[k-1:-1:0];
Aineq = [-ind, ind; ones(1,k), zeros(1,k); zeros(1,k), ones(1,k)];
bineq = [-1; ceil(k/2); ceil(k/2)];

% Bornes sup et inf des variables
lb = zeros(2*k,1);
ub = ones(2*k,1);

% Options de resolution de l'optimisation
options = optimoptions('intlinprog','Display','off','TolInteger',1e-6,...
    'IPPreprocess','none','CutGeneration','advanced','TolCon',1e-3);
%options = optimoptions('intlinprog','Heuristics','none','TolInteger',1e-6);

% Resolution
x = intlinprog(f, int, Aineq, bineq, Aeq, beq, lb, ub, options);

% % Interpretation des resultats
% if length(x)==0
%     disp('BASE OK!')
%     sol=1;
% else
%     disp('Présence de Coincidences!!!:')
%     sol=0;
%     disp(transpose(x(1:k)))
%     disp(transpose(x(k+1:2*k)))
% end
% 
% time = cputime - t;
% disp('Temps de calcul:')
% disp(time)

    
