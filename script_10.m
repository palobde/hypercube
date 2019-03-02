clc; clear all;
stop=0; tmax=3*3600; iter=0; 


% Definir k, rmin
k = 20; r_min = 5; r_max = k+1; %<-----------------A changer pour K

% Initialiser les parametres principaux
r_cour=r_max;
sol_init=1;  
new_r=1;
nb_eval_tabou=0; nb_eval_sol=0; nb_insc_tabou=0;
f_sol=r_cour; sol_min=f_sol; base_min=eye(r_max);

% Ouverture d'un fichier de resultats
fic = fopen('RESULTATS_20_2.txt','w');  %<-----------------A changer pour K
fprintf(fic,'****************************************************\n');
fprintf(fic,'RESULTATS DE SIMULATION POUR K = '); 
fprintf(fic,'%i\n',k);
fprintf(fic,'****************************************************\n\n');
ecrire_fichier; % Ecriture la meilleure solution initiale

% initier le temps
TIME0=cputime; time=cputime-TIME0;

% Recherche et evaluation de solutions
while r_cour>=r_min && stop==0 && time<=tmax
       
    % *********** Initier la liste taboue ***********
    if new_r==1
        r_cour = r_cour - 1; 
%         sol_init=1; 
        new_r=0;
        TabouL = [0, 0, 1000.0]; 
        disp('**** Essais pour les bases de taille: '); disp(r_cour);
        disp('Nouvelle liste taboue créée');
        f_sol=inf; rand_num=[];
        nb_eval_tabou=0; nb_eval_sol=0; nb_insc_tabou=0;
        if sol_init==0 % si on n'est pas entrain de charecher une nvelle solution initiale...
            sortir=0;
            while sortir==0
                % Evaluer et enregistrer la solution courante
                x = testBase3(Base); x=round(x); nb_eval_sol=nb_eval_sol+1;
                if isempty(x)         % Si la base est bonne....
                    f_sol=r_cour; disp('Hourrah 2!!!');
                else                     % Si la base est mauvaise....
                    dfact=matDist(Base);% calculer le facteur interdistance
                    f_sol= 100.0 + r_cour - dfact;
                    w1=x(1:k); w2=x(k+1:2*k);
                    disp('Oups 2!!!');
                    sortir=1; new_r=0;
                end
                % Enregistrer dans la liste taboue
                TabouL = [TabouL; L, C, f_sol];
                nb_insc_tabou=nb_insc_tabou+1;
                % Si cette base est la meilleure a date, l'enregistrer
                if f_sol<sol_min
                    % Afficher
                    sol_min = f_sol; base_min = Base; % Enregistrer
                    disp('NOUVELLE SOLUTION DE TAILLE :  '); disp('Bon!')% Afficher
                    disp(r_cour);
                    disp(base_min);
                    ecrire_fichier;
                    Base = Base(1:(r_cour-1),:); disp(size(Base));
                    new_r = 1;
                    r_cour = r_cour - 1; % Diminuer le r
                end
            end
        end
    end
    % *************** FIN Initier la liste taboue *********** 
   
    % ************ Generer une sol init de taille r_cour **************** 
    disp('Generation d une base initiale de taille :'); disp(r_cour);
    trial=0; try_max=100000; rand_num=0;
    while sol_init==1 && trial<=try_max && stop==0 && cputime<=tmax
        % Generer une base initiale incluant 0
        Base0 = zeros(1,k); % le point 0 fait tjrs partie de la base
        rand_num=0; % Liste qui memorise les nombres utilisés
        for i=2:r_cour
            nb = randi(2^k-1);
            while ~isempty(find(rand_num==nb,1)) % tant que le nb genere est deja ds la base on re-essaye
                disp('Nombre aléatoire généré deja dans la base...')
                nb = randi(2^k-1);                
            end
            rand_num= [rand_num; nb];
            cond = dec2bin(nb); vect=[];
            for j=1:length(cond)
                vect=[vect, str2num(cond(j))];
            end
            vect=[zeros(1,(k-length(vect))), vect]; % Concatener vect pour les bits manquants a l'avant
            if sum(vect)>=ceil(k/2) % Changer un point par son symetrique si necessaire
                vect=ones(1,k)-vect;
            end
            Base0 = [Base0; vect];
        end 
        
        % Verifier si la solution initiale generee est taboue
        [L,C]=identifyBase(Base0); 
        found=0;  [long,large]=size(TabouL); donnees=[L,C]; ind=1;
        while ind<=long && stop==0 && cputime<=tmax
            if TabouL(ind,1:2)==donnees
                found=1; % Trouvé dans la liste tabou
                disp('Cette solution initiale a déja ete evaluee')
            end
            ind=ind+1;
        end
        if found==0 % Si elle n'est pas taboue...
            disp('Solution (base) initiale non taboue trouvée!')
            sol_init=0; 
            Base = Base0;
            % Evaluer et enregistrer cette solution initiale
            x = testBase3(Base); x=round(x); nb_eval_sol=nb_eval_sol+1;
            if isempty(x)         % Si la base est bonne....
                f_sol=r_cour;  
                disp('Hourrah !!!')                
            else                     % Si la base est mauvaise....
                dfact=matDist(Base);% calculer le facteur interdistance
                f_sol= 100.0 + r_cour - dfact;
                w1=x(1:k); w2=x(k+1:2*k);
                disp('Oups !!!')
            end
            % Enregistrer dans la liste taboue
            TabouL = [TabouL; L, C, f_sol]; 
            nb_insc_tabou=nb_insc_tabou+1; 
            % Si cette base est la meilleure a date, l'enregistrer
            if f_sol<sol_min
                % Afficher
                sol_min = f_sol; base_min = Base; % Enregistrer
                disp('NOUVELLE SOLUTION DE TAILLE :  '); % Afficher
                disp(r_cour);
                disp(base_min);
                ecrire_fichier;
                Base = Base(1:(r_cour-1),:); new_r=1;
            end
        end
        nb_eval_tabou = nb_eval_tabou+1; 
        
        trial=trial+1;
        % Si on arrive plus a trouver de sol initiale qui ne soit pas taboue...
        if trial>try_max
            stop=1;
            disp('Arret!!! Difficile de trouver 1e sol init non taboue')
        end
    end
    % ********* FIN: Generer une sol init taille r_cour ***************
        
    % Evaluer les voisins de la solution courante
    best_vois=[]; best_val=1000; best_w1=[]; best_w2=[];  %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ best_val!
    voisinage=0;
    
    counter=0;
    while sol_init==0 && new_r==0 && stop==0 && cputime<=tmax   

        % Voisins de permutation de w1 ou w2
        disp('Recherche des voisins de permutation de w1 ou w2')
        for W=[w1,w2]
             for i=2:r_cour
                 Temp = Base; Temp(i,:)=W;
                 % Verifier si ce voisin est tabou
                 [L,C]=identifyBase(Temp);
                 found=0;  [long,large]=size(TabouL); donnees=[L,C]; ind=1;
                 while ind<=long
                     if TabouL(ind,1:2)==donnees
                         found=1; % Trouvé dans la liste tabou
                     end
                     ind=ind+1;
                 end
                 if found==0 % Si il n'est pas la liste taboue...
                     disp('***Voisin non tabou...')
                     % Evaluer et enregistrer cette solution voisine
                     x = testBase3(Temp); x=round(x); 
                     nb_eval_sol=nb_eval_sol+1;
                     if isempty(x)         % Si la base est bonne....
                         f_sol=r_cour;                        
                     else                     % Si la base est mauvaise....
                         dfact=matDist(Temp);% calculer le facteur interdistance
                         f_sol= 100.0 + r_cour - dfact;
                         w1=x(1:k); w2=x(k+1:2*k);
                     end
                     % Enregistrer dans la liste taboue
                     TabouL = [TabouL; L, C, f_sol]; 
                     nb_insc_tabou=nb_insc_tabou+1;
                     % Si cette base est la meilleure a date, l'enregistrer
                     if f_sol<sol_min
                         sol_min = f_sol; base_min = Temp; % Enregistrer
                         disp('NOUVELLE SOLUTION DE TAILLE :  '); % Afficher
                         disp(r_cour);
                         disp(base_min);
                         ecrire_fichier;
                         Base = Base(1:(r_cour-1),:); new_r=1;
                     end
                     % Si ce voisin est le meilleur voisin, l'enregistrer
                     if f_sol<best_val  && new_r==0
                         disp(' Nouveau meilleur voisin...');
                         best_val = f_sol; best_vois = Temp;
                         best_w1=w1; best_w2=w2;
                         voisinage=1; counter=0;
                     end
                 end
                 nb_eval_tabou = nb_eval_tabou+1;
             end
         end
         
        % Voisins de distance 1
        disp('Recherche des voisins de distance 1')
        i=2; j=1;
        while i<=r_cour && new_r==0
            while j<=k && new_r==0
                Temp = Base; Temp(i,j)=1-Base(i,j);
                % Verifier si ce voisin est tabou
                [L,C]=identifyBase(Temp);
                 found=0;  [long,large]=size(TabouL); donnees=[L,C]; ind=1;
                 while ind<=long
                     if TabouL(ind,1:2)==donnees
                         found=1; % Trouvé dans la liste tabou
                     end
                     ind=ind+1;
                 end
                 if found==0 % Si il n'est pas la liste taboue...                
                    disp('***Voisin non tabou...')
                    % Evaluer et enregistrer cette solution voisine
                    x = testBase3(Temp); x=round(x); 
                    nb_eval_sol=nb_eval_sol+1;
                    if isempty(x)         % Si la base est bonne....
                        f_sol=r_cour;
                        new_r=1;
                    else                     % Si la base est mauvaise....
                        dfact=matDist(Temp);% calculer le facteur interdistance
                        f_sol= 100.0 + r_cour - dfact;
                        w1=x(1:k); w2=x(k+1:2*k);
                    end
                    % Enregistrer dans la liste taboue
                    TabouL = [TabouL; L, C, f_sol]; 
                    nb_insc_tabou=nb_insc_tabou+1;
                    % Si cette base est la meilleure a date, l'enregistrer
                    if f_sol<sol_min
                        sol_min = f_sol; base_min = Temp; % Enregistrer
                        disp('NOUVELLE SOLUTION DE TAILLE :  '); % Afficher
                        disp(r_cour);
                        disp(base_min);
                        ecrire_fichier;
                        Base = Base(1:(r_cour-1),:); new_r=1;
                    end
                    % Si ce voisin est le meilleur voisin, l'enregistrer
                    if f_sol<best_val && new_r==0
                        disp(' Nouveau meilleur voisin...');
                        best_val = f_sol; best_vois = Temp;
                        best_w1=w1; best_w2=w2;
                        voisinage=1; counter=0;
                    end
                end
                nb_eval_tabou = nb_eval_tabou+1;
                j=j+1;
            end
            i=i+1;
        end
        
        % Assigner le meilleur voisin comme solution courante
        if voisinage==1 && new_r==0
            disp('Assigner le meilleur voisin');
            Base = best_vois; w1=best_w1; w2=best_w2; f_sol= best_val;
        end
        if voisinage==0 && new_r==0 % Si aucun voisin n'a pu etre identifié
            disp('*Recommencer avec une nouvelle sol initiale*')
            sol_init=1;
        end
        % Si on a explorer tous les voisins et qu'ils sont tabous, on recommence avec une nvelle solution
        if counter >= (r_cour*k + 2*k)
            disp('*Recommencer avec une nouvelle sol initiale 2*')
            sol_init=1;
        end
        counter=counter+1;
        
    end
       
    if sol_min<=r_min % Arreter si on trouve une base de taille minimale
        stop=1;
        disp('On a trouve la solution la plus basse possible pour ce K');
    end
    time=cputime-TIME0;
end

fprintf(fic,'La simulation a duré : '); fprintf(fic,'%f',cputime);
fclose(fic);
disp(' '); disp(' '); disp('La simulation a duré : '); disp(cputime);
    




