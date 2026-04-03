VAR
    Tryb_pracy      : INT;     // 0-OFF, 1-AUTO, 2-SERVICE
    Czujnik_paczki  : BOOL;    // Fotokomorka
    Przycisk_jazdy  : BOOL;    // Dla trybu SERVICE (JOG)
    E_STOP          : BOOL;    // TRUE = OK, FALSE = ALARM
    Silnik_wyjscie  : BOOL;
    Licznik_total   : INT;
    
    Timer_jazdy     : TP;      // Timer impulsowy 5s
    R_Trig_licznik  : R_TRIG;
END_VAR

// --- WYWOŁANIE BLOKÓW (Zawsze na początku) ---
Timer_jazdy(IN := (Tryb_pracy = 1 AND Czujnik_paczki), PT := T#5S);
R_Trig_licznik(CLK := Silnik_wyjscie);

// --- 1. NADRZEDNE BEZPIECZENSTWO ---
IF NOT E_STOP THEN
    Tryb_pracy := 0;
END_IF;

// --- 2. AUTOMAT STANOW ---
CASE Tryb_pracy OF
    0: // STAN: OFF
        Silnik_wyjscie := FALSE;
        
        IF E_STOP THEN
            IF Czujnik_paczki THEN
                Tryb_pracy := 1; // Przejdz do AUTO
            ELSIF Przycisk_jazdy THEN
                Tryb_pracy := 2; // Przejdz do SERVICE
            END_IF;
        END_IF;

    1: // STAN: AUTO
        Silnik_wyjscie := Timer_jazdy.Q;
        
        // Powrot do OFF po zakonczeniu cyklu
        IF NOT Timer_jazdy.Q AND NOT Czujnik_paczki THEN
            Tryb_pracy := 0;
        END_IF;

    2: // STAN: SERVICE
        Silnik_wyjscie := Przycisk_jazdy;
        
        // Powrot do OFF, gdy operator pusci przycisk jazdy
        IF NOT Przycisk_jazdy THEN
            Tryb_pracy := 0;
        END_IF;
END_CASE;

// --- 3. LICZENIE PACZEK ---
IF R_Trig_licznik.Q THEN
    Licznik_total := Licznik_total + 1;
END_IF;
