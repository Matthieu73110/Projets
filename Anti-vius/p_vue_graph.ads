with Forms; use Forms;
with p_fenbase; use p_fenbase;
with p_virus; use p_virus;

package p_vue_graph is

	function colorTCoulTOcolorFL(couleur_TCoul : in T_Coul) return FL_PD_COL;
	--{} => {La focntion permet de convertir des T_Coul en FL_PD_COL (la couleur humaine en couleur en ada)}
------------------------------------------------------------------------------------------
	function colorFLTOcolorTCoul(couleur_FL : in FL_PD_COL) return T_Coul;
	--{} => {La focntion permet de convertir des FL_PD_COL en T_Coul (la couleur ada en couleur en humaine)}
------------------------------------------------------------------------------------------
	procedure AfficheGraph(grille : in TV_Grille; jeu : in out TR_Fenetre);
	--{} => {La procedure permet d'afficher la grille en Graphique}
------------------------------------------------------------------------------------------
	function RenvoiCouleur(grille : in TV_Grille; bouton_jeu : in string) return FL_PD_COL;
	--{} => {La fonction permet de colorer les bouton directionnelle du jeu}
------------------------------------------------------------------------------------------
	procedure PossibleGraph(grille : in TV_Grille; coul : in T_CoulP; Jeu : in out TR_Fenetre);
	--{} => {La procedure permet de regarder si le déplacement est possible dans les directions
	-- * HG,HD,BG,BD et si cela est possible elle colore la case directionnelle associée }

------------------------------------------------------------------------------------------
	procedure DeplacementGraph(grille : in out TV_Grille; Jeu : in out TR_Fenetre; couleur : in T_CoulP; dir : in string);
	--{} => {La procedure permet de déplacer Graphiquement le coup joué}
------------------------------------------------------------------------------------------
end p_vue_graph;
