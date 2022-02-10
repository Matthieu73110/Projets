with p_esiut; use p_esiut;
with sequential_io;
with text_io; use text_io;
with p_virus; use p_virus;
with p_vuetxt; use p_vuetxt;
use p_virus.p_piece_io;
use p_virus.p_coul_io;
use p_virus.p_dir_io;
use p_virus.p_col_io;

procedure testjeu is
        grille : TV_Grille;
        pieces : TV_Pieces;
        num_config : integer;
        f : p_piece_io.file_type;
        couleur_piece : T_CoulP;
        dir_piece : T_Direction;
begin

        InitPartie(grille, pieces);
        put("Chosissez un numéro de configuration (entre 1 et 20) : ");
        lire(num_config);
        open(f, in_file, "Defis.bin");
        Configurer(f, num_config, grille, pieces);
        for i in T_CoulP'range loop
                PosPiece(grille, i);
                new_line;
        end loop;

        AfficheGrille(Grille);

        put("Quel couleur voulez-vous déplacer ?");
        lire(couleur_piece);
        for i in T_Direction'range loop
                put(i'image);
                put_line(Possible(grille, couleur_piece, i)'image);
        end loop;
        put("Quelle direction voulez-vous emprunter ?");
        lire(dir_piece);
				ecrire(couleur_piece);
				ecrire(dir_piece);
        MajGrille(grille, couleur_piece, dir_piece);
        PosPiece(grille, couleur_piece);
--      Configurer(f, num_config, grille, pieces);
        AfficheGrille(Grille);

        -- exception
        --         when CONSTRAINT_ERROR => put("Déplacement impossible.");

end testjeu;
