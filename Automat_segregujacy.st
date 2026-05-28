VAR
    Krok : INT := 0;              // krok programu
    Start_Maszyny : BOOL;         // przycisk NO uruchamiajacy maszyne
    E_Stop : BOOL;                // przycisk bezpieczeństwa NC 
    
    Tasma : BOOL;                 // napęd taśmociągu
    Spychacz_Metal : BOOL;        // aiłownik zrzucający metal
    Spychacz_Plastik : BOOL;      // aiłownik zrzucający plastik
    
    Fotokomorka_wlotowa : BOOL;   // wykrycie obiektu na wejściu
    Czujnik_indukcyjny : BOOL;    // detekcja metalu
    Czujnik_pojemnosciowy : BOOL; // detekcja plastiku
    Krancowka_baza : BOOL;        // czujnik potwierdzajacy powrotu siłowników na pozycję startowa
    
    Timer_Dojazdu : TON;          // Odmierzenie drogi od czujnika do spychacza
END_VAR

// system bezpieczenstwa
IF NOT E_stop THEN
    Tasma := FALSE;
    Spychacz_metal := FALSE;
    Spychacz_plastik := FALSE;
    Krok := 0; 
    RETURN; 
END_IF;

Timer_Dojazdu(IN := (Krok = 20 OR Krok = 30), PT := T#3s);

CASE Krok OF
    0:  // IDLE: oczekiwanie na gotowosc systemu
        Tasma := FALSE;
        IF Start_maszyny THEN
            Krok := 10;
        END_IF;

    10: // taśma rusza i czeka na materiał
        Tasma := TRUE;
        IF Czujnik_indukcyjny THEN
            Krok := 20; // wykrycie metalu
        ELSIF Czujnik_pojemnosciowy THEN
            Krok := 30; // wykrycie plastiku
        END_IF;

    20: // transportowaie metalu do spychacza
        IF Timer_dojazdu.Q THEN
            Tasma := FALSE; 
            Krok := 21;
        END_IF;

    21: // uzycie silownika
        Spychacz_metal := TRUE;
        IF NOT Krancowka_baza THEN  // wysuniety spychacz
            Krok := 22;
        END_IF;

    22: // powrot spychacza do bazy
        Spychacz_metal := FALSE;
        IF Krancowka_baza THEN
            Krok := 10; // oczekiwanie na kolejen smieci
        END_IF;

    30: // transport plastiku
        IF Timer_dojazdu.Q THEN
            Tasma := FALSE;
            Krok := 31;
        END_IF;

    31: // zrzut plastiku do pojemnika
        Spychacz_plastik := TRUE;
        IF NOT Krancowka_baza THEN
            Krok := 32;
        END_IF;

    32: // powrot do stanu wyjsciowego
        Spychacz_plastik := FALSE;
        IF Krancowka_baza THEN
            Krok := 10;
        END_IF;

END_CASE;
