VAR
    Stycznik_lewo  : BOOL;
    Stycznik_prawo : BOOL;
    Przycisk_start : BOOL;
    Przycisk_stop  : BOOL; // Zakladamy NC
    
    Timer_pracy    : TON;
    Timer_pauzy    : TON;
    
    Kierunek       : BOOL; // FALSE = Lewo, TRUE = Prawo
    Praca_aktywna  : BOOL; // Informuje o uruchomionym cyklu
END_VAR

// Start i Stop cyklu
IF Przycisk_start AND Przycisk_stop THEN
    Praca_aktywna := TRUE;
ELSIF NOT Przycisk_stop THEN
    Praca_aktywna := FALSE;
END_IF;

// Obsluga timerow
Timer_pracy(IN := Praca_aktywna AND NOT Timer_pauzy.IN, PT := T#5S);
Timer_pauzy(IN := Timer_pracy.Q, PT := T#3S); // Czas na wyhamowanie

// Zmiana kierunku po kazdej pauzie
IF Timer_pauzy.Q THEN
    Kierunek := NOT Kierunek; // Przelacz na przeciwny
END_IF;

// Kontrola stycznikow
Stycznik_lewo  := Praca_aktywna AND NOT Kierunek AND NOT Timer_pauzy.IN;
Stycznik_prawo := Praca_aktywna AND Kierunek AND NOT Timer_pauzy.IN;
