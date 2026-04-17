VAR
    Start : BOOL;           // Przycisk monostabilny (musi być trzymany)
    Czujnik_detalu : BOOL;  // Potwierdzenie obecności materiału
    Czujnik_gora : BOOL;    // Czujnik prasy w gornym polozeniu
    Czujnik_dol : BOOL;     // Czujnik prasyw dolnym polozeniu
    Zawor_3_2 : BOOL;       // 1 - wysunięcie, 0 - schowanie (sprężyna)
    Krok_ukladu : INT := 0; 
    Timer_prasowania : TON; 
END_VAR

Timer_prasowania(PT := T#5S);

CASE Krok_ukladu OF
    0:  // IDLE - Czekamy na start i detal
        Zawor_3_2 := FALSE;
        Timer_prasowania.IN := FALSE;
        
        IF Start AND Czujnik_detalu THEN
            Krok_ukladu := 1;
        END_IF;

    1:  // ruch silownika w dol
        IF Start THEN
            Zawor_3_2 := TRUE;
            IF Czujnik_dol THEN // pzrechodzimy dopiero gdy silownik zjedzie na dol
                Krok_ukladu := 2;
            END_IF;
        ELSE
            // silownik wraca gdy puszcze przycisk start
            Krok_ukladu := 0;
        END_IF;

    2:  // czas pasowania detalu
        IF Start THEN
            Zawor_3_2 := TRUE;
            Timer_prasowania.IN := TRUE; // timer odlicza czas
            
            IF Timer_prasowania.Q THEN
                Krok_ukladu := 3;
            END_IF;
        ELSE
            Krok_ukladu := 0; // przerwanie prasowania
        END_IF;

    3:  // powrot silownika do stanu poczatkowego
        Zawor_3_2 := FALSE;
        Timer_prasowania.IN := FALSE;
        
        // Czekamy chwilę aż siłownik wróci (można dodać czujnik góra)
        IF NOT Start AND Czujnik_gora THEN 
            Krok_ukladu := 0;
        END_IF;
END_CASE;
