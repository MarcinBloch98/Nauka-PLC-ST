// aby prasa dzialala trzeba wcisnac przycisk_1 i przycisk_2

VAR
    Przycisk_1        : BOOL; // przycisk uruchamiajacy lewy
    Przycisk_2        : BOOL; // przycisk uruchamiajacy prawy
    Praca             : INT := 0;  // Krok ukladu: 0-Oczekiwanie na wlaczenie, 1-silownik w dol, 2-postoj silownika, 3-silownik w gore
    Zawor_wysun       : BOOL; 
    Zawor_schowaj     : BOOL; 
    Liczba_sztuk      : INT := 0; 
    Czujnik_swietlny  : BOOL;  // czujnik bezpieczenstwa NC
    Timer_postoju     : TON;
END_VAR

// przecieta wiazka z czujnika swietlnego - powrot silownikow
IF NOT Czujnik_swietlny AND (Praca = 1 OR Praca = 2) THEN
    Praca := 3; 
END_IF;

// maszyna stanow
CASE Praca OF

    0: // OCZEKIWANIE NA URUCHOMIENIE
        Zawor_wysun   := FALSE;
        Zawor_schowaj := TRUE;
        IF Przycisk_1 AND Przycisk_2 AND Czujnik_swietlny THEN
            Praca := 1;
        END_IF;

    1: // SILOWNIK W DOL
        Zawor_wysun   := TRUE;
        Zawor_schowaj := FALSE;
        // Tutaj w realu byłby czujnik krańcowy, ale załóżmy, że dojechał:
        IF Przycisk_1 AND Przycisk_2 THEN // przejscie do kolejnego kroku jesli przyciski stan wysoki
             Praca := 2; 
        ELSIF NOT (Przycisk_1 AND Przycisk_2) THEN  // puszczenie przycisku przed zakonczenie pracy
             Praca := 3;
        END_IF;

    2: // OCZEKIWANIE I DOCISK SILOWNIKA 3 sekundy
        Timer_postoju(IN := TRUE, PT := T#3s);
        IF Timer_postoju.Q THEN
            Liczba_sztuk := Liczba_sztuk + 1; // ziczenie dodatkowej sztuki
            Timer_postoju(IN := FALSE);      // reset timera
            Praca := 3;
        END_IF;

    3: // POWRÓT DO GÓRY
        Zawor_wysun   := FALSE;
        Zawor_schowaj := TRUE;
        //wroc do kroku zero po powrocie silownika
        Praca := 0;

END_CASE;
