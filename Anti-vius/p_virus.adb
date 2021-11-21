with p_esiut; use p_esiut;
with sequential_io;
with text_io; use text_io;

package body p_virus is

package p_integer_io is new integer_io(integer); use p_integer_io;

	--------------- Primitives d'initialisation d'une partie

------------------------------------------------------------------------------------------

	procedure InitPartie(Grille : in out TV_Grille; Pieces : in out TV_Pieces) is
	-- {} => {Tous les éléments de Grille ont été initialisés avec la couleur VIDE, y compris les cases inutilisables
	--				Tous les élements de Pieces ont été initialisés à false}

	begin
		Grille := (others => (others => vide));
		Pieces := (others => false);
	end InitPartie;

------------------------------------------------------------------------------------------

	procedure Configurer(f : in out p_piece_io.file_type; num : in integer;
											 Grille : in out TV_Grille; Pieces : in out TV_Pieces) is
	-- {f ouvert, non vide, num est un numéro de défi
	--	dans f, un défi est représenté par une suite d'éléments :
	--	* les éléments d'une même pièce (même couleur) sont stockés consécutivement
	--	* les deux éléments constituant le virus (couleur rouge) terminent le défi}
	-- 			=> {Grille a été mis à jour par lecture dans f de la configuration de numéro num
	--					Pieces a été mis à jour en fonction des pièces de cette configuration}
		num_defi : integer := 1;
		elem : TR_ElemP;
		current_coul : T_Coul := vide;
	begin
		reset(f, in_file);
		while not end_of_file(f) and then num_defi <= num loop
			read(f, elem);
			if current_coul = rouge and elem.couleur /= rouge then
				num_defi := num_defi + 1;
			end if;
			current_coul := elem.couleur;
			if num_defi = num then
				Grille(elem.ligne, elem.colonne) := elem.couleur;
				Pieces(current_coul) := true;
			end if;
		end loop;
	end Configurer;

------------------------------------------------------------------------------------------

	procedure PosPiece(Grille : in TV_Grille; coul : in T_coulP) is
	-- {} => {la position de la pièce de couleur coul a été affichée, si coul appartient à Grille:
	--                exemple : ROUGE : F4 - G5}
			first_pass : boolean := true;
	begin
		for ligne in Grille'range(1) loop
			for colonne in Grille'range(2) loop
				if Grille(ligne,colonne) = coul then
					if first_pass then
						new_line;
						put(coul'image);
						put(" (");
						put(T_coulP'pos(coul), 0);
						put(")");
						put(" : ");
						first_pass := false;
					end if;
					put(colonne);
					put(ligne, 0);
					put(" ");
				end if;
			end loop;
		end loop;
		first_pass := true;
	end PosPiece;

------------------------------------------------------------------------------------------

	function Possible(Grille : in TV_Grille; coul : in T_CoulP; Dir : in T_Direction) return boolean is
	-- {coul /= blanc}
	--	=> {resultat = vrai si la pièce de couleur coul peut être déplacée dans la direction Dir}

	begin
		if coul = blanc then
			return false;
		end if;
		for ligne in Grille'range(1) loop
			for colonne in Grille'range(2) loop
				if Grille(ligne,colonne) = coul then
					if Dir = bg then
						if Grille(ligne + 1,character'pred(colonne)) /= vide and Grille(ligne + 1,character'pred(colonne)) /= coul then
							return false;
						end if;
					elsif Dir = hg then
						if Grille(ligne -1,character'pred(colonne)) /= vide and Grille(ligne -1,character'pred(colonne)) /= coul then
							return false;
						end if;
					elsif Dir = bd then
						if Grille(ligne + 1,character'succ(colonne)) /= vide and Grille(ligne + 1,character'succ(colonne)) /= coul then
							return false;
						end if;
					elsif Dir = hd then
						if Grille(ligne - 1,character'succ(colonne)) /= vide and Grille(ligne - 1,character'succ(colonne)) /= coul then
							return false;
						end if;
					end if;
				end if;
			end loop;
		end loop;

		return true;

	exception
	when CONSTRAINT_ERROR => 	return false;--raise;

	end Possible;

------------------------------------------------------------------------------------------

	procedure MajGrille(Grille : in out TV_Grille; coul : in T_CoulP; Dir : in T_Direction) is
	-- {la pièce de couleur coul peut être déplacée dans la direction Dir}
	--	=> {Grille a été mis à jour suite au deplacement}
	begin
		if dir = bg or dir = bd then
			for ligne in reverse Grille'range(1) loop
				for colonne in reverse Grille'range(2) loop
					if Grille(ligne,colonne) = coul then
						if Dir = bg then
							Grille(ligne + 1,character'pred(colonne)) := Grille(ligne, colonne);
							Grille(ligne, colonne) := vide;
						elsif Dir = bd then
							Grille(ligne + 1,character'succ(colonne)) := Grille(ligne, colonne);
							Grille(ligne, colonne) := vide;
						end if;
					end if;
				end loop;
			end loop;
		else
			for ligne in Grille'range(1) loop
				for colonne in  Grille'range(2) loop
					if Grille(ligne,colonne) = coul then
						if Dir = hg then
							Grille(ligne - 1,character'pred(colonne)) := Grille(ligne, colonne);
							Grille(ligne, colonne) := vide;
						elsif Dir = hd then
							Grille(ligne - 1,character'succ(colonne)) := Grille(ligne, colonne);
							Grille(ligne, colonne) := vide;
						end if;
					end if;
				end loop;
			end loop;
		end if;
	end MajGrille;

------------------------------------------------------------------------------------------

	function Guerison(Grille : in TV_Grille) return boolean is
	-- {} => {résultat = vrai si Grille(1,A) = Grille(2,B) = ROUGE}

	begin
		if Grille(1, 'A') = rouge and Grille(2, 'B') = rouge then
			return true;
		else
			return false;
		end if;
	end Guerison;
	------------------------------------------------------------------------------------------
end p_virus;
