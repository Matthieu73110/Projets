with p_fenbase; use p_fenbase;
with Forms; use Forms;
with p_esiut; use p_esiut;
with p_virus; use p_virus;
with p_vuetxt; use p_vuetxt;
with p_vue_graph; use p_vue_graph;
use p_virus.p_piece_io;
use p_virus.p_coul_io;
use p_virus.p_dir_io;
use p_virus.p_col_io;
with text_io; use text_io;


procedure av_graph is
	Grille : TV_Grille;
	pieces : TV_Pieces;
	Accueil, Jeu, Victoire, Regles : TR_Fenetre;
	x, y : integer := 0;
	nombouton : string (1..3);
	num_config, num_config_save : integer := 0;
	f : p_piece_io.file_type;
	couleur_select : FL_PD_COL;
	nb_coups, nb_erreurs : integer := 0;
	niveau_suivant : boolean := false;

begin -- av_graph

  InitialiserFenetres;
------------------------------------------------------------------------------------------
  Accueil:=DebutFenetre("Accueil",400,200);
	AjouterTexte(Accueil,"ChampBienvenue","ANTI-VIRUS",146,1,280,40);
	ChangerTailleTexte(Accueil,"ChampBienvenue",FL_medium_Size);
	AjouterChamp(Accueil,"ChampPseudo","Pseudo ","",100,50,100,30);
	AjouterChamp(Accueil,"ChampDéfi","Defi ","1",100,85,100,30);
	AjouterBouton(Accueil,"BoutonJouer","Jouer",170,130,70,40);
	AjouterBouton(Accueil,"BoutonQuitter","Quitter",325,155,70,40);
	AjouterBouton(Accueil,"BoutonRegles","Regles",5,155,70,40);
  FinFenetre(Accueil);
------------------------------------------------------------------------------------------
  Jeu := DebutFenetre("Jeu",600,400);
	AjouterTexte(Jeu,"ChampBienvenue","ANTI-VIRUS",230,1,280,40);
	AjouterTexte(Jeu,"ChampPseudo", "",220,40,280,40);
	ChangerTailleTexte(Jeu,"ChampBienvenue",FL_medium_Size);
	AjouterTexte(Jeu,"ChampCoup","Nombre de Coups :",10,150,150,40);
	AjouterTexte(Jeu,"NbCoups", nb_coups'image, 140,150, 40, 40);
	AjouterTexte(Jeu,"ChampErreur","Nombre d'erreurs :",10,200,150,40);
	AjouterTexte(Jeu,"NbErreurs", nb_erreurs'image, 140, 200, 40, 40);
	AjouterBouton(Jeu,"HG","",450,130,40,40);
	AjouterBouton(Jeu,"HD","",530,130,40,40);
	AjouterBouton(Jeu,"BD","",530,210,40,40);
	AjouterBouton(Jeu,"BG","",450,210,40,40);
	AjouterBouton(Jeu,"CouleurSelect","",490,170,40,40);
	y := 100;
    for i in Grille'range(1) loop
      x := 195;
      for j in Grille'range(2) loop
        nombouton := Integer'Image(i) & j;
        if not ((i+character'pos(j)-64)mod 2 /= 0) then
          AjouterBouton(Jeu,nombouton,"",x,y,30,30);
          ChangerCouleurFond(Jeu,nombouton,FL_RIGHT_BCOL);
        end if;
        x := x + 30;
      end loop;
      y := y + 30;
    end loop;
    AjouterBouton(Jeu,"BoutonRecommencer","Recommencer",10,350,100,40);
    AjouterBouton(Jeu,"BoutonAccueil","Accueil",520,350,70,40);
    ChangerCouleurFond(Jeu,"Jeu",FL_RIGHT_BCOL);
  FinFenetre(Jeu);
------------------------------------------------------------------------------------------

	Victoire := DebutFenetre("Victoire", 400, 250);
		AjouterTexte(Victoire,"ChampBienvenue","ANTI-VIRUS",146,1,280,40);
		ChangerTailleTexte(Victoire,"ChampBienvenue",FL_medium_Size);
		AjouterTexte(Victoire,"TexteVictoire","Vous avez gagne !!!",135,30,280,40);
		AjouterBouton(Victoire,"BoutonRejouer","Rejouer",31,175,100,40);
		AjouterBouton(Victoire,"BoutonSuivant","Niveau suivant",146,175,100,40);
		AjouterBouton(Victoire,"BoutonQuitter","Quitter",261,175,100,40);
		AjouterTexte(Victoire,"Nb_coups","", 135, 70,280,40 );
		AjouterTexte(Victoire,"Nb_erreurs","",135,110,280,40);
	FinFenetre(Victoire);

------------------------------------------------------------------------------------------

	Regles := DebutFenetre("Regles", 600, 400);
		AjouterTexte(Regles,"ChampBienvenue","ANTI-VIRUS",230,1,280,40);
		ChangerTailleTexte(Regles,"ChampBienvenue",FL_medium_Size);
		AjouterTexte(Regles,"TxtReg", "Bienvenue sur le Jeu Virus ! Nous allons vous presenter les regles de base du jeu :", 10, 50, 580, 30);
		AjouterTexte(Regles,"TxtReg1", "Au debut de chaque partie, un numero de defi, choisi par l'utilisateur, determine les", 10, 80, 580, 30);
		AjouterTexte(Regles,"TxtReg2", "pieces utilisees et leur placement initial.", 10, 110, 580, 30);
		AjouterTexte(Regles,"TxtReg3", "Pour un defi donne :", 10, 140, 580, 30);
		AjouterTexte(Regles,"TxtReg4", "- Il n'y a pas deux pieces mobiles de meme couleur.", 10, 170, 580, 30);
		AjouterTexte(Regles,"TxtReg5", "- Il peut y avoir entre 0 et 2 pieces fixes (couleur blanc)", 10, 200, 580, 30);
		AjouterTexte(Regles,"TxtReg6", "- Le virus a toujours la meme forme et occupe deux cases", 10, 230, 580, 30);
		AjouterTexte(Regles,"TxtReg7", "Les pieces mobiles se deplacent une par une en diagonale et ne peuvent pas pivoter.", 10, 260, 580, 30);
		AjouterTexte(Regles,"TxtReg9", "Il y a donc 4 directions possibles : bas/gauche, haut/gauche, bas/droite et haut/droite.", 10, 290, 580, 30);
		AjouterTexte(Regles,"TxtReg10", "Pour que le deplacement de ce mobile soit possible, il faut que les cases de destination", 10, 320, 580, 30);
		AjouterTexte(Regles,"TxtReg11", "soient libres (et utilisables).", 10, 350, 580, 30);
		AjouterBouton(Regles,"BoutonAccueil", "Compris !", 520,350,70,40);
	FinFenetre(Regles);

------------------------------------------------------------------------------------------

	open(f, in_file, "Defis.bin");


	<< START >>
	if niveau_suivant then
		reset(f,in_file);
		ChangerContenu(Accueil, "ChampDéfi", integer'image(num_config + 1));
		CacherFenetre(Victoire);
	end if;

	MontrerFenetre(Accueil);

	loop
		declare
			bouton : string := AttendreBouton(Accueil);
		begin
			if bouton = "BoutonJouer" then
				num_config := Integer'value(ConsulterContenu(Accueil,"ChampDéfi"));
				num_config_save := num_config;
				InitPartie(Grille, pieces);
				Configurer(f, num_config, grille, pieces);
				AfficheGraph(grille, jeu);
				CacherFenetre(Accueil);
				MontrerFenetre(Jeu);
				ChangerTexte(Jeu,"ChampPseudo", "Partie de " & ConsulterContenu(Accueil, "ChampPseudo"));
				loop
					declare
						bouton_jeu : string := AttendreBouton(Jeu);
					begin
						if bouton_jeu'length = 3 then
							couleur_select := RenvoiCouleur(grille, bouton_jeu); -- choix de la couleur à déplacer
							if not (colorFLTOcolorTCoul(couleur_select) = blanc or colorFLTOcolorTCoul(couleur_select) = vide) then
								ChangerCouleurFond(Jeu, "CouleurSelect", couleur_select); -- change la couleur du bouton "direction"
								PossibleGraph(grille, colorFLTOcolorTCoul(couleur_select), jeu); -- indique les directions possibles
							end if;
						elsif bouton_jeu'length = 2 and couleur_select /= FL_BLACK then
							if Possible(grille, colorFLTOcolorTCoul(couleur_select), T_Direction'value(bouton_jeu)) then
								nb_coups := nb_coups + 1;
								DeplacementGraph(grille, jeu, colorFLTOcolorTCoul(couleur_select), bouton_jeu);
								AfficheGraph(grille, jeu);
								PossibleGraph(grille, colorFLTOcolorTCoul(couleur_select), jeu); -- indique les directions possibles
							else
								nb_erreurs := nb_erreurs + 1;
							end if;
						elsif bouton_jeu = "BoutonRecommencer" then
							num_config := num_config_save;
							reset(f,in_file);
							InitPartie(Grille, pieces);
							Configurer(f,num_config, Grille, pieces);
							AfficheGraph(Grille, Jeu);
							for dir in T_Direction'range loop
								ChangerCouleurFond(Jeu, dir'image, FL_BLACK);
							end loop;
							ChangerCouleurFond(Jeu, "CouleurSelect", FL_BLACK);
							nb_coups := 0;
							nb_erreurs := 0;
						end if;
						ChangerTexte(Jeu, "NbCoups", nb_coups'image);
						ChangerTexte(Jeu, "NbErreurs", nb_erreurs'image);
						exit when bouton_jeu = "BoutonAccueil" or Guerison(grille);
					end;
			   	end loop;
				CacherFenetre(Jeu);
				if Guerison(grille) then
					ChangerTexte(Victoire,"Nb_coups","Nombre de coups" & nb_coups'image);
					ChangerTexte(Victoire,"Nb_erreurs","Nombre d'erreurs" & nb_erreurs'image);
					MontrerFenetre(Victoire);

					declare
						bouton : string := AttendreBouton(Victoire);
					begin
						if bouton = "BoutonRejouer" then
							reset(f,in_file);
							CacherFenetre(Victoire);
							MontrerFenetre(Accueil);
						elsif bouton = "BoutonSuivant" then
							niveau_suivant := true;
							nb_coups := 0;
							nb_erreurs := 0;
							ChangerTexte(Jeu, "NbCoups", nb_coups'image);
							ChangerTexte(Jeu, "NbErreurs", nb_erreurs'image);
							for dir in T_Direction'range loop
								ChangerCouleurFond(Jeu, dir'image, FL_BLACK);
							end loop;
							ChangerCouleurFond(Jeu, "CouleurSelect", FL_BLACK);
							goto START;
						elsif bouton = "BoutonQuitter" then
							exit;
						end if;
					end;
				else
					MontrerFenetre(Accueil);
					reset(f,in_file);
				end if;
				for dir in T_Direction'range loop
					ChangerCouleurFond(Jeu, dir'image, FL_BLACK);
				end loop;
				ChangerCouleurFond(Jeu, "CouleurSelect", FL_BLACK);
				nb_coups := 0;
				nb_erreurs := 0;
				ChangerTexte(Jeu, "NbCoups", nb_coups'image);
				ChangerTexte(Jeu, "NbErreurs", nb_erreurs'image);
			elsif bouton = "BoutonRegles" then
				CacherFenetre(Accueil);
				MontrerFenetre(Regles);
				declare
					bouton : string := AttendreBouton(Regles);
				begin
					if bouton = "BoutonAccueil" then
						reset(f,in_file);
						CacherFenetre(Regles);
						MontrerFenetre(Accueil);
					end if;
				end;
			elsif Bouton = "BoutonQuitter" then
				exit;
			end if;
		end;
	end loop;

end av_graph;
