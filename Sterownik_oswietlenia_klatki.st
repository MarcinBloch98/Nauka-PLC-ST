VAR
    Przycisk : BOOL;               // Przycisk NO na ścianie
    Czujnik_ruchu : BOOL;          // Detektor obecności
    Fotokomorka_jasno : BOOL;      // Czujnik zmierzchowy (TRUE = dzień)
    Lampa_wyjscie : BOOL;          // Stycznik światła
    Lampa_dimmer : INT;            // Jasność 0-100%
    
    Timer_swiatla : TON;           // Czas świecenia w trybie Auto
    Timer_przycisku : TON;         // Wykrywanie wcisniecia
    Tryb_reczny : BOOL;            // Zmienna trybu stałego
    Blokada_Zmiany : BOOL;         // Zmienna pomocnicza
END_VAR

// 1. Wykrywanie dlugiego przycisniecia (> 3s)
Timer_przycisku(IN := Przycisk, PT := T#3S);

IF Timer_przycisku.Q AND NOT Blokada_Zmiany THEN
    Tryb_reczny := NOT Tryb_reczny; 
    Blokada_Zmiany := TRUE; 
END_IF;

IF NOT Przycisk THEN
    Blokada_Zmiany := FALSE; 
END_IF;

// 2. Logika automatyczna
Timer_swiatla(
    IN := (Czujnik_ruchu OR Przycisk) AND NOT Fotokomorka_jasno AND NOT Tryb_reczny, 
    PT := T#30S
);

// 3. Sterowanie Wyjściem
IF Tryb_reczny THEN
    Lampa_wyjscie := TRUE;
    Lampa_dimmer := 100;
    
ELSIF Timer_swiatla.IN AND NOT Timer_swiatla.Q THEN
    Lampa_wyjscie := TRUE;
    
    // Funkcja ostrzegawcza (Pre-warning)
    IF Timer_swiatla.ET > T#25S THEN
        Lampa_dimmer := 30;  
    ELSE
        Lampa_dimmer := 100; 
    END_IF;
    
ELSE
    Lampa_wyjscie := FALSE;
    Lampa_dimmer := 0;
END_IF;
