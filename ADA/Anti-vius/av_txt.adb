with sequential_io;
with p_esiut; use p_esiut;
with text_io; use text_io;
with p_virus; use p_virus;
with p_vuetxt; use p_vuetxt;
use p_virus.p_piece_io;
use p_virus.p_coul_io;
use p_virus.p_dir_io;
use p_virus.p_col_io;

procedure av_txt is

  f : p_piece_io.file_type;
  Grille : TV_Grille;
  pieces : TV_Pieces;
  couleur_piece : T_CoulP;
  fin : boolean := false;
  Grille_Save : TV_Grille;
  nom : string(1..10);
  nb_tour : integer := 0;
  num_config : integer;

begin -- av_txt
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
    if Guerison(Grille) then
      put_line("Bravo, vous avez gagné !!! La COVID-19 est terminée.");
      put("Vous avez fait");
      put(nb_tour'image);
      put(" coups.");
    else
      FinCoup(Grille_Save, num_config ,Grille, fin);
      if fin then
        put_line("Vous avez abandonné, la partie est terminée.");
        put("Vous avez fait");
        put(nb_tour'image);
        put(" coups.");
      end if;
    end if;
  end loop;
end av_txt;
