function x = testBase6(Base)
t = cputime;

% R�cup�ration des dimensions
[r, k] = size(Base);

% Fonction f a optimiser
f = zeros(3*k,1);
% vecteur des indices des variables entieres
int = [1:2*k];

% Matrice Aeq des �galit�s
B = -2*Base + ones(r, k);
Aeq = [B, -B, zeros(r,k)];
beq = zeros(r,1);
% disp('Matrice decompos�e: ')
% disp(Aeq); 

% % Matrice Aineq des in�galit�s
% % ind = 2.^[k-1:-1:0];
% Aineq = [ones(1,k), zeros(1,2*k); zeros(1,k), ones(1,k), zeros(1,k);...
%    eye(k), eye(k), eye(k); -eye(k), -eye(k), eye(k);...
%    zeros(1,2*k), ones(1,k)];
% bineq = [ceil(k/2); ceil(k/2); 2*ones(k,1); zeros(k,1); -1];

Aineq = [eye(k), eye(k), eye(k); -eye(k), -eye(k), eye(k);...
   zeros(1,2*k), -ones(1,k)];
bineq = [2*ones(k,1); zeros(k,1); -1];

% Bornes sup et inf des variables
lb = zeros(3*k,1);
ub = ones(3*k,1);

% Options de resolution de l'optimisation
% options = optimoptions('intlinprog','Display','off','TolInteger',1e-6,...
%     'IPPreprocess','none','CutGeneration','advanced','TolCon',1e-3);
options = optimoptions('intlinprog','Display','off','TolInteger',1e-6,...
    'IPPreprocess','none','CutGeneration','advanced','TolCon',1e-3);

% Resolution
x = intlinprog(f, int, Aineq, bineq, Aeq, beq, lb, ub, options);

% x = linprog(f, Aineq, bineq, Aeq, beq, lb, ub);

% % Interpretation des resultats
% if length(x)==0
%     disp('BASE OK!')
%     sol=1;
% else
%     disp('Pr�sence de Coincidences!!!:')
%     sol=0;
%     disp(transpose(x(1:k)))
%     disp(transpose(x(k+1:2*k)))
% end
% 
% time = cputime - t;
% disp('Temps de calcul:')
% disp(time)

    
