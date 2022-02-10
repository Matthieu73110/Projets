with sequential_io;
with p_esiut; use p_esiut;
with p_virus; use p_virus;

package p_vuetxt is

  procedure AfficheGrille(Grille : in TV_Grille) ;
  -- {} => {la grille a été affichée selon les spécifications suivantes :
  -- * la sortie est indiquée par la lettre S
  -- * une case inactive ne contient aucun caractère
  -- * une case de couleur vide contient un point
  -- * une case de couleur blanche contient le caractère F (Fixe)
  -- * une case de la couleur d’une pièce mobile contient le chiffre correspondant à la
  -- position de cette couleur dans le type T_Coul}
  ---------------------------------------------------------------------------
  function ChoixPiece (Grille : in TV_Grille) return T_CoulP;
  --{} => {La fonction permet de choisir un pièce et vérifie si un dépalcement est possible ou non}
  -------------------------------------------------------------------------------
  procedure DeplacerPiece(Grille : in out TV_Grille; couleur_piece : in out T_CoulP);
  --{} => {La procedure permet de déplacer une pièce}
  ------------------------------------------------------------------------------
  function Abandon return boolean;
  --{} => {Le joueur peut choisir d'abandonner le niveaux}
  -------------------------------------------------------------------------------
  procedure AnnuleCoup (GrilleIn : in TV_Grille; GrilleOut : out TV_Grille);
  --{} => {Le joueur peut annuler le coup qui vient d'être jouer}
  ---------------------------------------------------------------------------
    procedure FinCoup (GrilleIn : in out TV_Grille;  num_config : in out integer; GrilleOut : out TV_Grille; fin : out boolean);
    --{} => {Le joueur peut choisir d'annuler son coup, d'abandonner et de changer de niveaux}
  ------------------------------------------------------------------------------------------
  procedure ChoixNiveau (f : in out p_piece_io.file_type; Grille : out TV_Grille; pieces : out TV_Pieces; num_config : out integer);
  --{} => {Le joueur peut choisir le niveaux qu'il désire}
  -------------------------------------------------------------------------------------
  procedure Pseudonyme (nom : in out string);
  --{} => {Le joueur peut avoir un pseudonyme}
  ------------------------------------------------------------------------------------
end p_vuetxt;
