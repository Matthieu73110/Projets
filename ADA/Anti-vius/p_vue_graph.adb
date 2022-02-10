with Forms; use Forms;
with p_fenbase; use p_fenbase;
with p_virus; use p_virus;
with p_esiut; use p_esiut;
with text_io; use text_io;
use p_virus.p_piece_io;

package body p_vue_graph is

	function colorTCoulTOcolorFL(couleur_TCoul : in T_Coul) return FL_PD_COL is
	--{} => {La focntion permet de convertir des T_Coul en FL_PD_COL (la couleur humaine en couleur en ada)}
		couleur : FL_PD_COL;
	begin
		if couleur_TCoul = rouge then
			couleur := FL_RED;
		elsif couleur_TCoul = turquoise then
			couleur := FL_DARKCYAN;
		elsif couleur_TCoul = orange then
			couleur := FL_DARKORANGE;
		elsif couleur_TCoul = rose then
			couleur := FL_DEEPPINK;
		elsif couleur_TCoul = marron then
			couleur := FL_DARKTOMATO;
		elsif couleur_TCoul = bleu then
			couleur := FL_DODGERBLUE;
		elsif couleur_TCoul = violet then
			couleur := FL_DARKVIOLET;
		elsif couleur_TCoul = vert then
			couleur := FL_PALEGREEN;
		elsif couleur_TCoul = jaune then
			couleur := FL_DARKGOLD;
		elsif couleur_TCoul = blanc then
			couleur := FL_WHITE;
		else
			couleur := FL_BLACK;
		end if;
		return couleur;
	end colorTCoulTOcolorFL;

------------------------------------------------------------------------------------------

	function colorFLTOcolorTCoul(couleur_FL : in FL_PD_COL) return T_Coul is
	--{} => {La focntion permet de convertir des FL_PD_COL en T_Coul (la couleur ada en couleur en humaine)}
		couleur : T_Coul;
	begin
		if couleur_FL = FL_RED then
			couleur := rouge;
		elsif couleur_FL = FL_DARKCYAN then
			couleur := turquoise;
		elsif couleur_FL = FL_DARKORANGE then
			couleur := orange;
		elsif couleur_FL = FL_DEEPPINK then
			couleur := rose;
		elsif couleur_FL = FL_DARKTOMATO then
			couleur := marron;
		elsif couleur_FL = FL_DODGERBLUE then
			couleur := bleu;
		elsif couleur_FL = FL_DARKVIOLET then
			couleur := violet;
		elsif couleur_FL = FL_PALEGREEN then
			couleur := vert;
		elsif couleur_FL = FL_DARKGOLD then
			couleur := jaune;
		elsif couleur_FL = FL_WHITE then
			couleur := blanc;
		else
			couleur := vide;
		end if;
		return couleur;
	end colorFLTOcolorTCoul;

------------------------------------------------------------------------------------------

	procedure AfficheGraph(grille : in TV_Grille; jeu : in out TR_Fenetre) is
	--{} => {La procedure permet d'afficher la grille en Graphique}
		nombouton : string(1..3);
		couleur : FL_PD_COL;
		begin
			for i in Grille'range(1) loop
				for j in Grille'range(2) loop
					nombouton := Integer'Image(i) & j;
					if not ((i + character'pos(j)-64) mod 2 /= 0) then
						couleur := colorTCoulTOcolorFL(grille(i, j));
						ChangerCouleurFond(Jeu, nombouton, couleur);
					end if;
				end loop;
			end loop;
	end AfficheGraph;

------------------------------------------------------------------------------------------

	function RenvoiCouleur(grille : in TV_Grille; bouton_jeu : in string) return FL_PD_COL is
	--{} => {La fonction permet de colorer les bouton directionnelle du jeu}
		nombouton : string(1..3);
		couleur_renvoyee : FL_PD_COL;
		couleur_sauv : FL_PD_COL;
	begin
		for i in Grille'range(1) loop
				for j in Grille'range(2) loop
					nombouton := Integer'Image(i) & j;
					if not ((i + character'pos(j)-64) mod 2 /= 0) then
						if nombouton = bouton_jeu then
							couleur_renvoyee := colorTCoulTOcolorFL(grille(i, j));
							couleur_sauv := couleur_renvoyee;
						else
							couleur_renvoyee := couleur_sauv;
						end if;
					end if;
				end loop;
		end loop;
		return couleur_renvoyee;
	end RenvoiCouleur;

------------------------------------------------------------------------------------------

	procedure PossibleGraph(grille : in TV_Grille; coul : in T_CoulP; Jeu : in out TR_Fenetre) is
	--{} => {La procedure permet de regarder si le déplacement est possible dans les directions
	-- * HG,HD,BG,BD et si cela est possible elle colore la case directionnelle associée }

	begin
		for dir in T_Direction'range loop
			if Possible(grille, coul, dir) then
				ChangerCouleurFond(Jeu, dir'image, FL_SPRINGGREEN);
			else
				ChangerCouleurFond(Jeu, dir'image, FL_BLACK);
			end if;
		end loop;
	end PossibleGraph;

------------------------------------------------------------------------------------------

	procedure DeplacementGraph(grille : in out TV_Grille; Jeu : in out TR_Fenetre; couleur : in T_CoulP; dir : in string) is
	--{} => {La procedure permet de déplacer Graphiquement le coup joué}

	begin
		MajGrille(grille, couleur, T_Direction'value(dir));
	end DeplacementGraph;
------------------------------------------------------------------------------------------
end p_vue_graph;
