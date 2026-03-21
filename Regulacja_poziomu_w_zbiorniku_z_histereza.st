(* Regulacja poziomu w zbiorniku z histereza miedzy 20 a 80 procent zapelnienia w zbiorniku *)

VAR
    Poziom_aktualny  : REAL;    // Odczyt z czujnika faktycznego poziomu wody w zbiorniku [0.0 - 100.0 %]
    Prog_niski       : REAL := 20.0; 
    Prog_wysoki      : REAL := 80.0;
    
    Pompa_dolewowa   : BOOL;    // Obsluga stycznika pompy
    Blad_czujnika    : BOOL;    // Zmienna awarii
END_VAR

// 1. Detekcja awarii czujnika (wartosci niemozliwe)
IF Poziom_aktualny < -5.0 OR Poziom_Aktualny > 105.0 THEN
    Blad_czujnika := TRUE;
ELSE
    Blad_czujnika := FALSE;
END_IF;

// 2. Logika regulacji
IF Blad_czujnika THEN
    Pompa_dolewowa := FALSE; // Bezpieczeństwo: stop przy awarii
    
ELSIF Poziom_aktualny <= Prog_niski THEN
    Pompa_dolewowa := TRUE;  // Startuje pompe dopiero na samym dole (20%)
    
ELSIF Poziom_aktualny >= Prog_wysoki THEN
    Pompa_dolewowa := FALSE; // Wyłączam pompe dopiero przy pelnym zbiorniku (80%)

END_IF; 
