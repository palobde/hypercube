% Ecrire dans le fichier 
fprintf(fic,'\n');
fprintf(fic,'NOUVELLE BONNE SOLUTION DE TAILLE :  ');
fprintf(fic,'%d\n',f_sol);
fprintf(fic,'NB d incription tabou = ');
fprintf(fic,'%i\n',nb_insc_tabou);
fprintf(fic,'NB d évaluations tabou = ');
fprintf(fic,'%i\n',nb_eval_tabou+1);
fprintf(fic,'NB d évaluations de solutions = ');
fprintf(fic,'%i\n',nb_eval_sol);
for m=1:r_cour
    for n=1:k
        fprintf(fic,'%i',base_min(m,n)); fprintf(fic,'\t');
    end
    fprintf(fic,'\n');
end
fprintf(fic,'\n');