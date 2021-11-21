with sequential_io;
with p_esiut; use p_esiut;
with p_virus; use p_virus;
with text_io; use text_io;
use p_virus.p_piece_io;
use p_virus.p_coul_io;
use p_virus.p_dir_io;
use p_virus.p_col_io;

package body p_vuetxt is

  package p_integer_io is new integer_io(integer); use p_integer_io;
  ----------------------------------------------------------------------
  procedure AfficheGrille(Grille : in TV_Grille) is
  -- {} => {la grille a été affichée selon les spécifications suivantes :
  -- * la sortie est indiquée par la lettre S
  -- * une case inactive ne contient aucun caractère
  -- * une case de couleur vide contient un point
  -- * une case de couleur blanche contient le caractère F (Fixe)
  -- * une case de la couleur d’une pièce mobile contient le chiffre correspondant à la
  -- position de cette couleur dans le type T_Coul}
  begin
    new_line;
    put("    ");
    for i in T_col loop
      put(" ");
      put(i);
    end loop;
      new_line;
    put("   ");
    put("S");
    for i in T_col loop
      put(" ");
      put("-");
    end loop;
  new_line;
    for i in T_Lig  loop
      put(i'image);
      put(" |");
      if (i mod 2) = 0 then
        put(" ");
      end if;
      for j in T_Col loop
        if ((i+character'pos(j)-64)mod 2 /= 0) then
          put(" ");
        else
          if Grille(i,j) = vide  then
            put(" . ");
          else
            if T_coulP'pos(Grille(i,j)) = 9 then
              put(" F ");
            else
              put(" ");
              put(T_coulP'pos(Grille(i,j)), 0);
              put(" ");
            end if;
          end if;
        end if;
      end loop;
      new_line;
    end loop;
    new_line;
  end AfficheGrille;
  ------------------------------------------------------------------------------------
  function ChoixPiece (Grille : in TV_Grille) return T_CoulP is
  --{} => {La fonction permet de choisir un pièce et vérifie si un dépalcement est possible ou non}
    couleur_piece : T_CoulP := rouge;
    nb : integer;
  begin
    loop
      nb := 0;
      new_line;
      put("Quel couleur voulez-vous déplacer ? ");
      lire(couleur_piece);
      new_line;
      put("Déplacement autorisé : ");
      for i in T_Direction'range loop
        if not Possible(grille, couleur_piece, i) then
          nb := nb + 1 ;
        else
          put(i'image & " ");
        end if;
      end loop;
      new_line;
      exit when nb < 4;
    end loop;
    new_line;
    return couleur_piece;
  end ChoixPiece;
  --------------------------------------------------------------------------
  procedure DeplacerPiece(Grille : in out TV_Grille; couleur_piece : in out T_CoulP) is
  --{} => {La procedure permet de déplacer une pièce}
    dir_piece : T_Direction;
  begin
    loop
      put("Quelle direction voulez-vous emprunter ? ");
      lire(dir_piece);
      exit when Possible(Grille,couleur_piece,dir_piece);
      put_line("Déplacement impossible");
    end loop;
    MajGrille(grille, couleur_piece, dir_piece);
  exception
    when CONSTRAINT_ERROR => raise;
  end DeplacerPiece;
  ----------------------------------------------------------------------------
  function Abandon return boolean is
  --{} => {Le joueur peut choisir d'abandonner le niveaux}
    reponse : string(1..3);
  begin
    loop
      put("Voulez-vous arrêter de jouer ? (oui/non) ");
      lire(reponse);
      exit when reponse = "oui" or reponse = "non";
    end loop;
    if reponse = "oui" then
      return true;
    else
      return false;
    end if;
  end Abandon;
  ---------------------------------------------------------------------------
  procedure AnnuleCoup (GrilleIn : in TV_Grille; GrilleOut : out TV_Grille) is
  --{} => {Le joueur peut annuler le coup qui vient d'être jouer}
  begin
    GrilleOut := GrilleIn;
    AfficheGrille(GrilleIN);
  end AnnuleCoup;
  ---------------------------------------------------------------------------
  procedure FinCoup (GrilleIn : in out TV_Grille; num_config : in out integer; GrilleOut : out TV_Grille;  fin : out boolean) is
    --{} => {Le joueur peut choisir d'annuler son coup, d'abandonner et de changer de niveaux}
    f : p_piece_io.file_type;
    Grille : TV_Grille;
    pieces : TV_Pieces;
    couleur_piece : T_CoulP;
    Grille_Save : TV_Grille;
    nom : string(1..10);
    nb_tour : integer := 0;
    reponse : string(1..2);
  begin
    fin := false;
    put_line("an : Annuler le coup");
    put_line("ab : Abandonner la partie");
    put_line("ba : Recommencer le niveau avec la configuration de base");
    put_line("re : Réinitialiser la partie");
    put_line("su : Coup suivant");
    lire(reponse);
    new_line;
    if reponse = "an" then
      AnnuleCoup(GrilleIn, GrilleOut);
    elsif reponse = "ab" then
      if Abandon then
        fin := true;
      end if;
    elsif reponse = "re" then
      Pseudonyme(nom);
      InitPartie(Grille, pieces);
      ChoixNiveau(f,Grille,pieces,num_config);
      AfficheGrille(Grille);
      while not fin and not Guerison(Grille) loop
        nb_tour := nb_tour + 1;
        Grille_Save := Grille;
        couleur_piece := ChoixPiece(Grille);
        DeplacerPiece(Grille,couleur_piece);
        AfficheGrille(Grille);
        FinCoup(Grille_Save, num_config,Grille, fin);
      end loop;
    elsif reponse = "ba" then
      open(f,in_file,"Defis.bin");
      InitPartie(Grille, pieces);
      Configurer(f,num_config, Grille, pieces);
      AfficheGrille(Grille);
      close(f);
      while not fin and not Guerison(Grille) loop
        nb_tour := nb_tour + 1;
        Grille_Save := Grille;
        couleur_piece := ChoixPiece(Grille);
        DeplacerPiece(Grille,couleur_piece);
        AfficheGrille(Grille);
        FinCoup(Grille_Save, num_config,Grille, fin);
      end loop;
    elsif reponse = "su" then
      return;
    else
      return;
    end if;
  end FinCoup;
  -------------------------------------------------------------------------
  procedure ChoixNiveau (f : in out p_piece_io.file_type; Grille : out TV_Grille; pieces : out TV_Pieces; num_config : out integer) is
  --{} => {Le joueur peut choisir le niveaux qu'il désire}

  begin
    loop
      put("Choisissez votre défi (entre 1 et 20) : ");
      lire(num_config);
      exit when num_config >= 1 and num_config <= 20;
    end loop;
    open(f, in_file, "Defis.bin");
    Configurer(f, num_config, Grille, pieces);
    for i in T_CoulP'range loop
      PosPiece(grille, i);
    end loop;
    new_line;
    close(f);
  end ChoixNiveau;
  -----------------------------------------------------------------------
  procedure Pseudonyme (nom : in out string) is
  --{} => {Le joueur peut avoir un pseudonyme}
    begin
      put("Veuillez saisir un Pseudonyme (10 caractères max) : ");
      lire(nom);
      put("Bon Courage " & nom);
      new_line;
    end Pseudonyme;

  -----------------------------------------------------------------------------
end p_vuetxt;
