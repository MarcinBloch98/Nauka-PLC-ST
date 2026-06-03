VAR
    Wezwanie_pietro_1    : BOOL;  // przycisk wezwania windy na pietro 1
    Wezwanie_pietro_2    : BOOL;  // przycisk wezwania windy na pietro 2
    Czujnik_pietro_1     : BOOL;  // czujnik krancowky obecnosci windy na pietrze 1
    Czujnik_pietro_2     : BOOL;  // czujnik krancowy obecnosci windy na pietrze 2
    Rygiel_zamkniety     : BOOL;  // czujnik bezpieczenstwa - drzwi zablokowane
    
    Timer_rygla          : TON;   // blokada bezpieczenstwa
    Krok                 : INT;   // krok ukladu: 0-stop, 1-ryglowanie, 2-ruch_w_gore, 3-ruch_w_dol
    
    Silnik_gora          : BOOL;  // stycznik poruszajacy winde w gore
    Silnik_dol           : BOOL;  // stycznik poruszajacy winde w dol
    Zwolnij_rygiel       : BOOL;  // cewka otwierajaca brzmi przy postoju
END_VAR

// sekwencja
CASE Krok OF
    0: // Stop - oczekiwanie na wezwanie windy na odpowiednie pietro
        IF Wezwanie_pietro_2 AND Czujnik_pietro_1 THEN
            Krok := 1; // Winda jest na dole, wezwano do gory -> ryglowanie drzwi
        ELSIF Wezwanie_pietro_1 AND Czujnik_pietro_2 THEN
            Krok := 1; // Winda jest na gorze, wezwano w dol -> ryglowanie drzwi
        END_IF;
        
    1: // sprawdzanie bezpieczenstwa przed startem silnika
        IF Rygiel_zamkniety AND Timer_rygla.Q THEN
            IF Wezwanie_pietro_2 THEN
                Krok := 2; // drzwi zablokowane bezpiecznie, ruch w gore
            ELSE
                Krok := 3; // drzwi zablokowane bezpiecznie, ruch w dol
            END_IF;
        ELSIF NOT Wezwanie_pietro_1 AND NOT Wezwanie_pietro_2 THEN
            Krok := 0; // reset kroku przy braku wezwania
        END_IF;
        
    2: // ruch w gore, winda jedzie na pietro 2
        IF Czujnik_pietro_2 OR NOT Rygiel_zamkniety THEN
            Krok := 0; // winda na miejscu lub przerwano rygiel, bezpieczny stop
        END_IF;
        
    3: // ruch w dol, winda jedzie na pietro 1
        IF Czujnik_pietro_1 OR NOT Rygiel_zamkniety THEN
            Krok := 0; // dojechano na miejsce lub przerwano rygiel, bezpieczny stop
        END_IF;
END_CASE;

// blokada bezpieczenstwa, timer odlicza 2 sek po ryglu aby wyeliminowac drgania stykow krancowek
Timer_rygla(IN := (Krok = 1) AND Rygiel_zamkniety, PT := T#2s);
